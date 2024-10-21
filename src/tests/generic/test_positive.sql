{% test is_positive(model, column_name) %}
with validation as (
    select 
        {{column_name}} as positive_column
    from
        {{ model }}
),
validation_errors as (
    select
        *
    from
        validation
    where
        positive_column <= 0
)
select
    *
from
    validation_errors

{% endtest %}