{% 
    set payment_methods = ['card', 'cash', 'meal_ticket', 'cheque']
%}
{%
    set queried_payment_methods = get_payment_methods()
%}
{%
    set queried_payment_methods_utils = dbt_utils.get_column_values(table=source('source','orders'), column='payment_method') 
%}

select
    restaurant_id,
    name,
    address,
    nb_employees,
    open_on_sunday,
    sum(amount) as total_turnover
    {% for payment_method in queried_payment_methods_utils %}
    {{ log(payment_method, info=True) }}
    , coalesce(sum(case when payment_method = '{{ payment_method }}' then amount end),0) as {{ payment_method }}_amount
    {% endfor %}
from
    {{ref('stg_restaurants__turnover')}}
group by
    restaurant_id,
    name,
    address,
    nb_employees,
    open_on_sunday
order by
    total_turnover desc