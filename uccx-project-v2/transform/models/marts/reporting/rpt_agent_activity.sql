
with agent_month_enriched as (
    select * from {{ ref('int_agent_month_enriched') }}
),

agent_monitoring as (select ame.report_period,		
		                ame.agent_name,
		                ame.not_ready_time_hours,
                        ame.calls_presented_agent,
		                ame.calls_handled_agent,
                        round((ame.calls_handled_agent::numeric / nullif(ame.calls_handled_agent + ame.outbound_calls,0)) * 100.0, 2) as activity_ratio
from agent_month_enriched as ame
order by ame.agent_name, ame.report_period asc
)

select *
from agent_monitoring
