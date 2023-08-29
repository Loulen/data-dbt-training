select distinct
    parse_json(dishes_names)::array as dishes_names
    {# , dishes_ids #}
    , payment_method
    , amount
    , created_at
from 
    {{ source('sources', 'fuzzy_orders') }}