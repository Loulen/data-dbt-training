with restaurants as (
    select 
    *
    from
    {{ ref('base_restaurants') }}
),
orders as (
    select
    *
    from
    {{ ref('base_orders') }}
)

select
    restaurants.identifier as restaurant_id,
    restaurants.name,
    restaurants.address,
    restaurants.nb_employees,
    restaurants.open_on_sunday,
    orders.identifier as order_id,
    orders.dishes_ids,
    orders.payment_method,
    orders.amount,
    orders.created_at
from
    restaurants
join
    orders on restaurants.identifier = orders.restaurant_identifier
