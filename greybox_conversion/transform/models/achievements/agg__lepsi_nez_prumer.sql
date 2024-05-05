with achievement as (
    select
        clovek_id,
        school_year,
        COUNT() as pocet_debat
    from {{ ref('base__debater_debata') }}
    where
        kidy > 75
        and school_year is not NULL
    group by clovek_id, school_year
),

final as (
    select
        clovek_id,
        school_year,
        'Lepší než průměr' as achievement_name,
        'Gratuluji, povedlo se ti překonat hranici 75 bodů v ' || pocet_debat || ' debatách!' as achievement_description,
        'achievement_lepsi_nez_prumer/' || clovek_id || '/' || school_year as achievement_id,
        'numeric' as achievement_type,
        3 as achievement_priority
    from achievement

)

select * from final
