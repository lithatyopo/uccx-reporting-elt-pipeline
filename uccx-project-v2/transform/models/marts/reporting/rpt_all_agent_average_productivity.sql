
with agent_month_enriched as (
    select * from {{ ref('int_agent_month_enriched') }}
),
 
productivity_score as (select ame.report_period,
		                    round((avg(ame.calls_handled_agent *1.0) / nullif(avg(ame.logged_in_time_hours),0)) * 8, 0) as avg_productivity,
                            round(avg(ame.logged_in_time_hours),0) as avg_logged_in_time_hours,
                            round(avg(ame.calls_handled_agent),0) as avg_calls_handled_agent
from agent_month_enriched as ame
group by 1
order by ame.report_period asc
),

with_lag as (
    select *,
        avg_productivity - lag(avg_productivity) over (order by report_period) as productivity_change
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












