{{ config(
materialized='incremental',
incremental_strategy='append'
) }}

with 

source as (

    select * from {{ source('postgre_db', 'order_items') }}

),

renamed as (

    select
        order_id,
        product_id,
        quantity,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed

{% if is_incremental() %}
WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }})
{% endif %}