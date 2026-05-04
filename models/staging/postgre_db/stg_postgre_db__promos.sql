with 

source as (

    select * from {{ source('postgre_db', 'promos') }}

),

renamed as (

    select
        promo_id,
        {{ porcentaje_descuento('discount') }} as descuento,
        status,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed