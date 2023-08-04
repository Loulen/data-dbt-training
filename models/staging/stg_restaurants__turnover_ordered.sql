select 
    r.identifier                       as restaurant_identifier
    , r.name
    , r.address
    , coalesce(sum(o.amount),0)   as turnover
from 
    {{ref('base_restaurants')}} as r
left join
    {{ref('base_orders')}} as o
    on o.restaurant_identifier = r.identifier
group by 
    r.identifier
    , r.name
    , r.address
order by 
    turnover desc