with achievement as (
    select
        clovek_id,
        school_year,
        AVG(kidy) as prumerne_kidy,
        COUNT() as pocet_debat
    from {{ ref('base__debater_debata') }}
    where school_year is not NULL
    group by clovek_id, school_year
),

final as (
    select
        clovek_id,
        school_year,
        'Dobrý řečník' as achievement_name,
        'Během letošního roku máš průměrně ' || ROUND(prumerne_kidy, 2) || ' řečnických bodů v ' || pocet_debat || ' debatách za tento rok!' as achievement_description,
        'achievement_dobry_recnik/' || clovek_id || '/' || school_year as achievement_id,
        'numeric' as achievement_type,
        1 as achievement_priority
    from achievement
    where prumerne_kidy is not NULL
)

select * from final
