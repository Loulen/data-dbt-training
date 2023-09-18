select
    o.*
    , d.value as dishes_id
from {{ref('base_orders')}} as o
    ,table(flatten(input => o.dishes_ids, outer => true)) as d
