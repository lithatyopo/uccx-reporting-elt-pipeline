with source as (

    select * from {{ source('raw', 'agent_all_fields') }}

),

renamed as (

    select
        (to_date(source."Report_Period", 'MONTH YYYY') + interval '1 Month' - interval '1 Day')::date                          as report_period,
        source."Agent_ID"::text                                as agent_id,
        source."Agent_Name"::text                              as agent_name,
        source."Agent_Extension"::text                         as agent_extension,
        source."Calls_Presented"::int                          as calls_presented_agent,
        source."Calls_Handled"::int                            as calls_handled_agent,
        source."Calls_Abandoned"::int                          as calls_abandoned_agent,
        source."Handle_Ratio"::float                           as handle_ratio_agent,
        extract (epoch from source."Work_Time"::time)          as work_time,
        extract (epoch from source."Avg_Handle_Time"::time)    as avg_handle_time,
        extract (epoch from source."Avg_Talk_Time"::time)      as avg_talk_time,
        split_part(source."Total_Logged_In_Time", ':', 1)::int as logged_in_time_hours,
        split_part(source."Not_Ready_Time", ':', 1)::int        as not_ready_time_hours,   
        split_part(source."Talk_Time", ':', 1)::int             as talk_time_hours,
        source."Outbound_On_IPCC-Total"::int                       as outbound_calls,
        source."ACD-Transfer_In"::int                          as transfer_to_agent, 
        source."ACD-Transfer_Out"::int                          as transfer_from_agent, 
        source."ACD-Conference"::int                           as conference,
        source."Ready_Time_(%)"::float                          as ready_percent,
        source."Not_Ready_Time_(%)"::float                             as not_ready_percent,
        source."_source_file",
        source."_loaded_at"
    from source

),

deduped as (

    select
        *,
        row_number() over (
            partition by agent_name, report_period
            order by _loaded_at desc
        ) as _row_num
    from renamed
)

select report_period, 
        agent_id, agent_name, 
        agent_extension, 
        calls_presented_agent, 
        calls_handled_agent, 
        calls_abandoned_agent, 
        handle_ratio_agent,
        work_time,
        avg_handle_time,
        avg_talk_time,
        logged_in_time_hours,
        not_ready_time_hours,
        talk_time_hours,
        outbound_calls,
        transfer_to_agent,
        transfer_from_agent,
        conference, 
        ready_percent,
        not_ready_percent
from deduped 
where _row_num=1

 