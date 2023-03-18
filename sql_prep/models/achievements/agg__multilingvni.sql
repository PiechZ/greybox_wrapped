with debates_per_language as (
    select
        clovek_id,
        rocnik,
        jazyk,
        count() as pocet_debat
    from {{ ref('clovek_debata') }}
    group by 1, 2, 3
),

languages_per_debater as (
    select
        clovek_id,
        rocnik,
        count() as pocet_jazyku
    from debates_per_language
    group by 1, 2
),

achievement as (
    select
        clovek_id,
        rocnik,
        pocet_jazyku,
        case 
            when pocet_jazyku > 2 then 'multilingvní'
            when pocet_jazyku > 1 then 'bilingvní'
            else null
        end as achievement_text
    from languages_per_debater
    where clovek_id is not null
    and pocet_jazyku > 1
),

final as (
    select
        clovek_id,
        rocnik,  -- NOTE: This will always be null for three-or-more languages, since it's only assigned to league debates
        'achievement_linguist/' || clovek_id || '/' || rocnik as achievement_id,
        'Lingvista' as achievement_name,
        'Gratuluji, jsi debatně ' || achievement_text || '!' as achievement_description,
        json_object('pocet_jazyku', pocet_jazyku) as achievement_data,  -- => e.g. {"pocet_jazyku": 3}
        'binary' as achievement_type,  -- or 'percentile' or 'numeric'
        pocet_jazyku + 3 as achievement_priority
    from
        achievement
    where
        achievement_text is not null
)

select * from final