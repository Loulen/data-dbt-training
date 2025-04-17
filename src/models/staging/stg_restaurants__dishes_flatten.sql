
{{ config(
    materialized='table'
)}}

with parsed_orders as (
    select 
        payment_method,
        amount,
        created_at,
        -- Parse the dishes_name JSON array
        parse_json(dishes_names) as parsed_dishes_name
    from
        {{ ref('base_fuzzy_orders') }}
),

flattened_orders as (
    -- Flatten the JSON array into individual rows
    select
        po.payment_method,
        po.amount,
        po.created_at,
        -- Use lateral flatten to unpack the JSON array
        dish.value::string as dish_name
    from
        parsed_orders po,
        lateral flatten(input => po.parsed_dishes_name) as dish
)
select * 
from flattened_orders
