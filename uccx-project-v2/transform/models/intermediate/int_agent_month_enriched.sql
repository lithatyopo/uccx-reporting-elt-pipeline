with agent_month as (
    select * from {{ ref('fact_agent_month') }}
),

agent_dim as (
    select * from {{ ref('dim_agents') }}
),

date_dim as (
    select * from {{ ref('dim_dates') }}
)

select
    am.agent_id,
    ad.agent_name,
    am.report_period,
    dd.month_name,
    am.calls_presented_agent,
    am.calls_handled_agent,
    am.not_ready_time_hours,
    am.outbound_calls,
    am.logged_in_time_hours,
    am.ready_percent
from agent_month am
join agent_dim ad on am.agent_id = ad.agent_id
join date_dim dd on am.report_period = dd.date_day