select
    s.visitor_id,
    max(s.visit_date) as visit_date,
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    lead_id,
    created_at,
    amount,
    closing_reason,
    status_id
from sessions as s
left join leads as l
    on s.visitor_id = l.visitor_id
where medium != 'organic'
group by
    s.visitor_id,
    source,
    medium,
    campaign,
    lead_id,
    amount,
    created_at,
    closing_reason,
    status_id
order by amount desc nulls last, visit_date, utm_source, utm_medium, utm_campaign
limit 10

with sub2 as (select campaign_date as data,
	utm_source,
	utm_medium,
	utm_campaign,
	daily_spent
from vk_ads va
union all
select campaign_date as data,
	utm_source,
	utm_medium,
	utm_campaign,
	daily_spent
from ya_ads ya)
select date_trunc('day', visit_date) as visit_dates,
	count(s.visitor_id) as visitors_count,
	s.source utm_source,
	s.medium utm_medium,
	s.campaign utm_campaign,
	sum(daily_spent) as total_cost,
	count(lead_id) leads_count,
	count(lead_id) filter (where status_id = 142) as purchases_count,
	sum(amount) as revenue
from sessions s
left join leads l
	on l.visitor_id = s.visitor_id
left join sub2 
	on sub2.utm_source = s.source 
	and sub2.utm_medium = s.medium
	and sub2.utm_campaign = s.campaign
where s.medium != 'organic' and s.source in ('yandex', 'vk')
group by visit_dates, s.source, s.medium, s.campaign
order by revenue desc nulls last, visit_dates, visitors_count desc, utm_source, utm_medium, utm_campaign
