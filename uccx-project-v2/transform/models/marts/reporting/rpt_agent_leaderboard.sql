with agent_month_enriched as (
    select * from {{ ref('int_agent_month_enriched') }}
),

ranked as (
    select
        ame.agent_id,
        ame.agent_name,
        ame.report_period,
        ame.calls_handled_agent,
        rank() over (partition by ame.report_period order by ame.calls_handled_agent desc) as calls_handled_rank,
        ntile(4) over (partition by ame.report_period order by ame.calls_handled_agent desc) as calls_handled_quartile
    from agent_month_enriched as ame
)

select
    *,
    case
        when calls_handled_quartile = 1 then 'Top Performer'
        when calls_handled_quartile = 4 then 'Needs Support'
        else 'On Track'
    end as performance_tier
from ranked
order by report_period, calls_handled_rank