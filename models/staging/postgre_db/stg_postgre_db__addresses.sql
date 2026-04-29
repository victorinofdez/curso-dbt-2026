{{ config(
materialized='incremental',
unique_key='address_id',
incremental_strategy='merge'
) }}


with 

source as (

    select * from {{ source('postgre_db', 'addresses') }}

),

renamed as (

    select
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed

{% if is_incremental() %}
WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }})
{% endif %}