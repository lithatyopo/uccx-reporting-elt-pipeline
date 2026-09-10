with source as (

    select * from {{ source('raw', 'csq_activity') }}

),
renamed as (

    select
        (to_date(source."Report_Period", 'MONTH YYYY') + interval '1 Month' - interval '1 Day')::date   as report_period,
        source."CSQ_ID" ::int                                      as csq_id,
        source."CSQ_Name"::text                                    as csq_name,
        source."Calls_Presented"::int                              as calls_presented_csq,
        source."Calls_Handled"::int                                as calls_handled_csq,
        source."Calls_Abandoned"::int                              as calls_abandoned_csq,
        extract (epoch FROM source."Avg_Queue_Time"::time)         as avg_queue_time,
        extract (epoch FROM source."Max_Queue_Time"::time)         as max_queue_time,
        extract (epoch FROM source."Avg_Speed_of_Answer"::time)    as avg_speed_of_answer,
        source."_source_file",
        source."_loaded_at"  
    from source
),

deduped as (

    select
        *,
        row_number() over (
            partition by csq_name, report_period
            order by _loaded_at desc
        ) as _row_num
    from renamed
)


    select report_period,
            csq_id,
            csq_name,
            calls_presented_csq,
            calls_handled_csq,
            calls_abandoned_csq,
            avg_queue_time,
            max_queue_time,
            avg_speed_of_answer
from deduped 
where _row_num=1