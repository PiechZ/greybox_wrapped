WITH debate_stats AS (
    SELECT 
        clovek_id, 
        school_year,
        COUNT(*) AS debate_count,
        COUNT(*) * 1.5 as hour_count
    FROM 
        {{ ref('base__rozhodci_debata') }}
    GROUP BY 
        clovek_id,
        school_year
),

summary_characteristics as (
    select
        debate_stats.*,
        case
            when hour_count >= 3 then 'příjemný film (a pak o něm napsat recenzi)'
            when hour_count >= 6 then 'pořádný spánek (a pak napsat argumentativní VŠ esej)'
            when hour_count >= 9 then 'půltucet epizod Soudkyně Barbary (a pak napsat dvakrát tolik mstivých ČSFD recenzí)'
            when hour_count >= 12 then 'trilogii Problém tří těles (a pak se o něm dva dny písemně hádat na Redditu)'
            when hour_count >= 18 then 'všechny Harry Pottery (a pak se týden hádat na Facebooku o transfobii JK Rowling)'
            when hour_count >= 30 then 'týdenní šichtu (a pak o ní napsat díl do Hrdinů kapitalistické práce)'
            when hour_count >= 45 then 'týdenní sekci El Camino Santiago (a pak o ní napsat 30 lifestylových článků do Vlasty)'
            when hour_count >= 60 then 'všechny seriály a filmy Aarona Sorkina (a pak napsat zbylých 51 Federalist Papers)'

        end as activity
    from debate_stats
),

final AS (
    SELECT 
        clovek_id, 
        school_year,
        {{ make_achievement_id('judge_debates') }},
        'Rozhodl/a jsi ' || debate_count || ' debat!' as achievement_name,
        'Za tu dobu sis mohl/a užít ' || activity || '.' as achievement_description,
        json_object('debate_count', debate_count, 'hour_count', hour_count) as achievement_data,
        4 as achievement_priority,
        'numeric' as achievement_type
        
    FROM 
        summary_characteristics
)

SELECT * FROM final
