select
    identifier
    , name
    , selling_price
    , production_cost
    , type
from 
    {{ source('sources', 'dishes') }}