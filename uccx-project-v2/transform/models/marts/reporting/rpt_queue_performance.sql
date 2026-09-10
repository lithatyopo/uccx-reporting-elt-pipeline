with csq_month as (
    select * from {{ ref('fact_csq_month') }}
),

csq_dim as (
    select * from {{ ref('dim_csq') }}
),

date_dim as (
    select * from {{ ref('dim_dates') }}
),

csq_view as (select dd.month_name,
                    cd.csq_name,
					cm.report_period,
					cm.avg_speed_of_answer::int,
					cm.calls_abandoned_csq,
					cm.calls_presented_csq,
					cm.calls_handled_csq,
					cm.avg_queue_time::int,
					round((cm.calls_abandoned_csq *100.0 / nullif(cm.calls_presented_csq,0)),2) as abandon_percent,
					round((cm.calls_handled_csq *100.0 / nullif(cm.calls_presented_csq,0)),2) as handle_percent
			from csq_month as cm 
            join csq_dim as cd on cm.csq_id=cd.csq_id
			join date_dim as dd on cm.report_period=dd.date_day
			order by 2,3

)

select *
from csq_view