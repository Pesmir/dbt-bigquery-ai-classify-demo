{% set ai_connection_id = env_var('BIGQUERY_AI_CONNECTION_ID', '') %}
{% set ai_endpoint = env_var('BIGQUERY_AI_ENDPOINT', '') %}
{% set classify_optional_arguments = [] %}
{% set classification_categories = [
    ('Billing and Invoicing', 'Questions about invoices payments refunds plan changes or billing errors.'),
    ('Technical Troubleshooting', 'Requests where the product is not working as expected and needs technical investigation.'),
    ('Feature Request', 'Ideas for new product capabilities workflow improvements or enhancements.'),
    ('Account Access and Permissions', 'Issues related to login access roles user invites or permission changes.'),
    ('Needs Triage', 'Tickets that do not clearly fit another category and should be reviewed manually.')
] %}

{% if ai_connection_id %}
    {% do classify_optional_arguments.append("connection_id => '" ~ ai_connection_id ~ "'") %}
{% endif %}

{% if ai_endpoint %}
    {% do classify_optional_arguments.append("endpoint => '" ~ ai_endpoint ~ "'") %}
{% endif %}

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
            {% for argument in classify_optional_arguments %}
            , {{ argument }}
            {% endfor %}
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
