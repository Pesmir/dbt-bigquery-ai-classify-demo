with ticket_categories as (

    select
        category_id
        , category_name
        , category_description
    from {{ ref('seed_support__ticket_categories') }}

),

renamed as (

    select
        cast(category_id as int64) as category_id
        , cast(category_name as string) as category_name
        , cast(category_description as string) as category_description
    from ticket_categories

)

select * from renamed
