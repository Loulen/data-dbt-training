select
    restaurant_id,
    name,
    address,
    nb_employees,
    open_on_sunday,
    sum(amount) as total_turnover
from
    {{ref('stg_restaurants__turnover')}}
group by
    restaurant_id,
    name,
    address,
    nb_employees,
    open_on_sunday
order by
    total_turnover desc
limit {{ var('nb_restaurants_to_show')}}