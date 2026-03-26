{% set classification_categories = [
    ('Billing and Invoicing', 'Questions about invoices payments refunds plan changes or billing errors.'),
    ('Technical Troubleshooting', 'Requests where the product is not working as expected and needs technical investigation.'),
    ('Feature Request', 'Ideas for new product capabilities workflow improvements or enhancements.'),
    ('Account Access and Permissions', 'Issues related to login access roles user invites or permission changes.'),
    ('Needs Triage', 'Tickets that do not clearly fit another category and should be reviewed manually.')
] %}


with ticket_categories as (

    select
        category_id
        , category_name
        , category_description
    from {{ ref('stg_support__ticket_categories') }}

),

customer_success_tickets as (

    select
        ticket_id
        , ticket_description
    from {{ ref('stg_support__customer_success_tickets') }}

),

classified_tickets as (

    select
        customer_success_tickets.ticket_id
        , customer_success_tickets.ticket_description
        , ai.classify(
            customer_success_tickets.ticket_description
            , categories => [
                {% for category_name, category_description in classification_categories %}
                struct(
                    '{{ category_name }}' as label
                    , '{{ category_description }}' as description
                ){% if not loop.last %},{% endif %}
                {% endfor %}
            ]
        ) as predicted_category_name
    from customer_success_tickets

),

final as (

    select
        classified_tickets.ticket_id
        , classified_tickets.ticket_description
        , classified_tickets.predicted_category_name
        , ticket_categories.category_id
        , ticket_categories.category_name
        , ticket_categories.category_description
    from classified_tickets
    left join ticket_categories
        on classified_tickets.predicted_category_name = ticket_categories.category_name

)

select * from final
