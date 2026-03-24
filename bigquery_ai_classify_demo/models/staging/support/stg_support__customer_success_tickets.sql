with customer_success_tickets as (

    select
        ticket_id
        , ticket_description
    from {{ ref('seed_support__customer_success_tickets') }}

),

renamed as (

    select
        cast(ticket_id as int64) as ticket_id
        , cast(ticket_description as string) as ticket_description
    from customer_success_tickets

)

select * from renamed
