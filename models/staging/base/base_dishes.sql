select
    identifier
    , name
    , selling_price
    , production_cost
    , type
from 
    {{ mockable_source('sources', 'dishes','sample_dishes') }}