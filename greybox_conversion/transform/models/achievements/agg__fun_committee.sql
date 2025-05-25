with individuals as (
    select 
        clovek_id,
        {{ var('current_school_year') }} as school_year
    from {{ ref('vybor_pro_srandu') }}
),

final as (
    select
        individuals.clovek_id,
        individuals.school_year,
        {{ make_achievement_id('fun_committee') }},
        'Člen neoficiálního výboru pro srandu!' as achievement_name,
        '...byl/a členem neoficiálního výboru pro srandu.' as achievement_description,
        JSON_OBJECT() as achievement_data,
        5 as achievement_priority,
        'binary' as achievement_type
    from
        individuals
)

select * from final