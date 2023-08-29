{{
    config(
        materialized='table'
    )
}}

with base as (
    select * from {{ ref('base_fuzzy_orders') }}
)

, add_fake_id as (
    select
        row_number() over (order by 1) as fake_id
        , *
    from
        base
)

select
    b.fake_id
    , n.value as dish_user_input
    , payment_method
    , amount
    , created_at
    {# , dishes_ids #}
from
    add_fake_id as b
, lateral flatten(input => b.dishes_names) as n