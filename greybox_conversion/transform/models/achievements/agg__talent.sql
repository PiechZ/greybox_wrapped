with base as (
    select * from {{ ref('base__debater_debata') }}
),

newbies as (
    select base.* from base
    right join {{ ref('base__newbies') }} using (clovek_id)
),

achievement as (
    select
        clovek_id,
        school_year,
        AVG(kidy) as prumerne_kidy,
        COUNT() as pocet_debat
    from newbies
    group by clovek_id, school_year
),

final as (
    select
        clovek_id,
        school_year,
        'Talent' as achievement_name,
        'Gratulujeme, jsi talent! Debatuješ první rok, a v ' || pocet_debat || ' debatách máš průměrně ' || ROUND(prumerne_kidy, 2) || ' řečnických bodů!' as achievement_description,
        'achievement_talent/' || clovek_id || '/' || school_year as achievement_id,
        'binary' as achievement_type,
        5 as achievement_priority
    from achievement
    where prumerne_kidy > 75
)

select * from final
