
-- June Leaderboard --
select * 
uccxmodels_marts.rpt_agent_leaderboard
where report_period='2026-06-30';

-- Monthly Agent Productivity Scorecard --
select * 
from uccxmodels_marts.rpt_agent_productivity_scorecard
[[where {{agent}}]];

-- Monthly All Agents Average Productivity  --
select * 
from uccxmodels_marts.rpt_all_agent_average_productivity;

-- Monthly Agent Activity --
select * 
from uccxmodels_marts.rpt_agent_activity
[[where {{Agent}}]]

-- Monthly Queue Performance --
select * 
from uccxmodels_marts.rpt_queue_performance
[[where {{queue}}]]