with base as (
    select * from {{ ref('base__debater_debata') }}
),

prepare_hours as (
    select
        clovek_id,
        school_year,
        COUNT(*) * 2 as hours_debated
    from base
    where school_year is not NULL
    group by clovek_id, school_year
),

achievement as (
    select
        *,
        case
            when hours_debated > 350 then 'naučit se nový jazyk na úroveň B1'
            when hours_debated > 200 then 'dohrát Total War: Empire - Definitive Edition'
            when hours_debated > 100 then 'dokončit průměrný online kurz na Udemy'
            when hours_debated >= 80 then 'TODO'
            -- ^ Nobody actually achieves this, but we can tease them as possible goals
            when hours_debated >= 60 then 'zhlédnout všechny díly seriálu Breaking Bad'
            when hours_debated >= 40 then 'zaletět na otočku do Japonska'
            when hours_debated >= 36 then 'TODO'
            when hours_debated >= 30 then 'dohrát Cyberpunk 2077'
            when hours_debated >= 24 then 'zhlédnout všechny díly seriálu Comeback'
            when hours_debated >= 20 then 'TODO'
            when hours_debated >= 16 then 'projet všech 254 stanic metra v Dillí'
            when hours_debated >= 12 then 'TODO'
            when hours_debated >= 8 then 'odpracovat jednu směnu'
        end as achievement_decider
    from prepare_hours

),

final as (
    select
        clovek_id,
        school_year,
        hours_debated,
        'Sběratel debat' as achievement_name,
        'V této sezóně se ti podařilo debatovat přibližně ' || hours_debated || ' hodin. Za tu dobu se by se dalo například ' || achievement_decider || '. Zlepšovat se v debatování však dlouhodobně může být ještě užitečnější!' as achievement_description,
        'achievement_sberatel_debat/' || clovek_id || '/' || school_year as achievement_id,
        'numeric' as achievement_type,
        1 as achievement_priority
    from achievement
    where achievement_decider is not NULL
)

select * from final
