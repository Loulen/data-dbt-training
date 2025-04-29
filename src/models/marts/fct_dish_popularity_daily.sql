{{
  config(
    materialized='table'
  )
}}

with orders as (
    select * from {{ ref('base_orders') }}
),

dishes as (
    select * from {{ ref('sample_dishes') }}
),

order_items as (
    select
        o.identifier as order_id,
        try_cast(f.value::string as int) as dish_id, -- Ensure dish_id is integer
        o.created_at
    from orders o,
    lateral flatten(input => parse_json(o.dishes_ids)) f
    where try_cast(f.value::string as int) is not null -- Filter out potential non-integer values if JSON is malformed
),

final as (
    select
        oi.dish_id,
        date_trunc('day', oi.created_at)::date as date, -- Truncate timestamp to date
        count(*) as total_quantity_ordered,
        sum(d.selling_price) as total_revenue
    from order_items oi
    join dishes d on oi.dish_id = d.identifier
    group by 1, 2
)

select * from final