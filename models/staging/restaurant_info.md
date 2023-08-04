{% docs order_status %}

One of the following values: 

| status         | definition                                       |
|----------------|--------------------------------------------------|
| placed         | Order placed, not yet shipped                    |
| shipped        | Order has been shipped, not yet been delivered   |
| completed      | Order has been received by customers             |
| return pending | Customer indicated they want to return this item |
| returned       | Item has been returned                           |

{% enddocs %}

{% docs order_payment %}

One of the following type of payments: 

| payment_methods | definition                                       |
|---------------- |--------------------------------------------------|
| card            | Payment in credit card                           |
| cash            | Payment in cash                                  |
| cheque          | Payment in cheque                                |
| meal_tikets     | Payement with meal tickets                       |

{% enddocs %}