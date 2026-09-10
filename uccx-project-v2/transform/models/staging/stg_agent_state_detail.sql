with source as (

    select * from {{ source('raw', 'agent_state_detail') }}

),

renamed as (

    select
        source."Agent_ID"::text                                as agent_id,
        source."Agent_Name"::text                              as agent_name,
        source."Extension"::text                               as agent_extension,
        source."Agent_State"::text                             as agent_state,
        source."Reason"::text                                  as state_reason,
        source."State_Transition_Time"::timestamp              as state_transition_time,
        source."_source_file",
        source."_loaded_at"        
    from source
),

deduped as (

    select
        *,
        row_number() over (
            partition by agent_name, state_transition_time, agent_state
            order by _loaded_at desc
        ) as _row_num
    from renamed
)

select agent_id,
        agent_name,
        agent_extension,
        agent_state,
        state_reason,
        state_transition_time

from deduped 
where _row_num=1