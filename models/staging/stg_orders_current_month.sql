select
    *
from
    {{ ref('base_orders') }}
where
    created_at >= (select max(date_trunc(month, created_at::timestamp)) from {{ ref('base_orders') }} )