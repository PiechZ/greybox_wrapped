with final as (
    select 
        clovek_id,
        {{ var('current_school_year') }} as school_year
    from {{ ref('vybor_pro_srandu') }}
)

select * from final