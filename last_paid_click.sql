select
    s.visitor_id,
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    lead_id,
    created_at,
    amount,
    closing_reason,
    status_id,
    max(s.visit_date) as visit_date
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
order by amount, visit_date, utm_source, utm_medium, utm_campaign nulls last
