
{{ config(
    materialized='table'
)}}

select 
    array_agg(dish_name) as dishes_name,
    payment_method,
    amount,
    created_at
from
    {{ ref('stg_restaurants__replace_fuzzy') }}
group by
    payment_method,
    amount,
    created_at