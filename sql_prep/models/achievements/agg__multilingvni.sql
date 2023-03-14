with debates_per_language as (
    select
        clovek_id,
        jazyk,
        count() as pocet_debat
    from {{ ref('clovek_debata') }}
    group by 1, 2
),

languages_per_debater as (
    select
        clovek_id,
        count() as pocet_jazyku
    from debates_per_language
    group by 1
),

achievement as (
    select
        clovek_id,
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
        'achievement_linguist/' || clovek_id as achievement_id,
        'Lingvista' as achievement_name,
        'Gratuluji, jsi debatně ' || achievement_text || '!' as achievement_description,
        json_object('pocet_jazyku', pocet_jazyku) as achievement_data,  -- => e.g. {"pocet_jazyku": 3}
        pocet_jazyku + 3 as achievement_priority
    from
        achievement
    where
        achievement_text is not null
)

select * from final