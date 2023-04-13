with debates_per_language as (
    select
        clovek_id,
        school_year,
        language,
        count() as pocet_debat
    from {{ ref('base__debater_debata') }}
    group by 1, 2, 3
),

languages_per_debater as (
    select
        clovek_id,
        school_year,
        count() as pocet_jazyku
    from debates_per_language
    group by 1, 2
),

achievement as (
    select
        clovek_id,
        school_year,
        pocet_jazyku,
        case
            when pocet_jazyku > 2 then 'multilingvní'
            when pocet_jazyku > 1 then 'bilingvní'
        end as achievement_text
    from languages_per_debater
    where
        clovek_id is not null
        and pocet_jazyku > 1
),

final as (
    select
        clovek_id,
        school_year,
        'Lingvista' as achievement_name,
        'binary' as achievement_type,
        'achievement_linguist/'
        || clovek_id
        || '/'
        || school_year as achievement_id,
        -- => e.g. {"pocet_jazyku": 3}
        'Gratuluji, jsi debatně '
        || achievement_text
        || '!' as achievement_description,
        -- or 'percentile' or 'numeric'
        json_object('pocet_jazyku', pocet_jazyku) as achievement_data,
        pocet_jazyku + 3 as achievement_priority
    from
        achievement
    where
        achievement_text is not null
)

select * from final
