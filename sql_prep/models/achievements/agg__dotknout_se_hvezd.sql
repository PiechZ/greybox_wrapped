with base as (
    select * from {{ ref('base__debater_debata') }}
),

dobre_debaty as (
    select
        clovek_id,
        school_year
    from base
    where kidy > 85
),

achievement as (
    select
        clovek_id,
        school_year,
        COUNT() as pocet_debat
    from dobre_debaty
    group by clovek_id, school_year
    order by school_year

),

final as (
    select
        clovek_id,
        school_year,
        'Dotknout se hvězd' as achievement_name,
        'numeric' as achievement_type,
        8 as achievement_priority,
        'V této sezoně se ti podařilo dotknout se hvězd '
        || pocet_debat
        || ' krát. Tolikrát byly tvé řečnické body lepší než 85!' as achievement_description,
        'achievement_dotknout_se_hvezd/'
        || clovek_id
        || '/'
        || school_year as achievement_id
    from achievement
    where pocet_debat >= 2
)

select * from final
