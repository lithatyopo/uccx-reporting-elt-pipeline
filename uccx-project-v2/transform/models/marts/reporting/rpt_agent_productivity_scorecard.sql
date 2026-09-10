with agent_month_enriched as (
    select * from {{ ref('int_agent_month_enriched') }}
),

productivity_score as (select ame.report_period,
		                    ame.agent_name,
		                    ame.calls_handled_agent,
		                    ame.logged_in_time_hours,
                            round(ame.ready_percent::numeric ,2) as ready_percent,
		                    round((ame.calls_handled_agent *1.0 / nullif(ame.logged_in_time_hours,0)) * 8, 0) as productivity
from agent_month_enriched as ame
order by ame.agent_name, ame.report_period asc
),

with_lag as (
    select *,
        productivity - lag(productivity) over (partition by agent_name order by report_period) as productivity_change
    from productivity_score
)
 
select
    *,
    coalesce(productivity_change, 0) as productivity_mom_difference,
    case
        when productivity_change > 0 then 'Increased'
        when productivity_change < 0 then 'Decreased'
        else '-'
    end as productivity_trend
from with_lag

