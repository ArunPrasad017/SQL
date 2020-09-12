/* 
Analyzing traffic sources in my sql
*/

use mavenfuzzyfactory;

-- finding top traffic sources
select 
  utm_source
, utm_campaign
, http_referer
, count(distinct(website_session_id)) as sessions
from website_sessions
where created_at < '2012-04-12'
GROUP BY 1,2,3
order by sessions desc


-- Traffic source conversion rates (4% or higher is better) april 14 2012
select
count(distinct(w.website_session_id)) as sessions,
count(distinct(o.order_id)) as orders,
count(distinct(o.order_id))/count(distinct(w.website_session_id))*100 as sessionToOrderConvRatePercent
from website_sessions w
left join orders o
on w.website_session_id = o.website_session_id
where w.created_at < '2012-04-14' and w.utm_source = 'gsearch' and w.utm_campaign = 'nonbrand'
-- he is overbidding currently on the campaigns and will reduce the amt based on analysis

-- Traffic source trending per week
select 
min(date(created_at)) as week_start_date,
count(distinct(website_session_id)) as sessions
from website_sessions
where created_at<'2012-05-10'
group by year(created_at), week(created_at)

-- Bid optimization by device_type for transaction < may 11 2012
select
w.device_type,
count(distinct(w.website_session_id)) as sessions,
count(distinct(o.order_id)) as orders,
(count(distinct(o.order_id))/count(distinct(w.website_session_id)))*100 as sessionToOrderConvRatePercent
from website_sessions w
left join orders o
on w.website_session_id = o.website_session_id
where w.created_at<'2012-05-11' and w.utm_source = 'gsearch' and w.utm_campaign = 'nonbrand'
group by w.device_type

--  Trending with granular segment of data upto may 19 2012 (session count)
select
min(date(created_at)) as week_start_date,
count(case when device_type='desktop' then 1 else null end) as dtop_sessions,
count(case when device_type='mobile' then 1 else null end) as mob_sessions
from website_sessions
where created_at<'2012-05-19'
group by
year(created_at),
week(created_at)