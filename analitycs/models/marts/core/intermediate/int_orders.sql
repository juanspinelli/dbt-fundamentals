with

orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}
    where status != 'fail'

),

order_totals as (

    select

        order_id,
        status,
        sum(amount) as order_value_dollars

    from payments
    group by 1, 2

),

joined as (

    select

        orders.*,
        order_totals.status,
        order_totals.order_value_dollars

    from orders 
    left join order_totals
        on orders.order_id = order_totals.order_id

)

select * from joined
