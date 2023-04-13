with achievement as (
    select
        clovek_id,
        school_year,
        COUNT() as pocet_debat
    from {{ ref('base__debater_debata') }}
    where
        kidy > 75
        and school_year is not null
    group by clovek_id, school_year
),

final as (
    select
        clovek_id,
        school_year,
        'Lepší než průměr' as achievement_name,
        'numeric' as achievement_type,
        3 as achievement_priority,
        'Gratuluji, povedlo se ti být lepší než průměr v '
        || pocet_debat
        || ' debatách za tento rok!' as achievement_description,
        'achievement_lepsi_nez_prumer/'
        || clovek_id
        || '/'
        || school_year as achievement_id
    from achievement

)

select * from final
