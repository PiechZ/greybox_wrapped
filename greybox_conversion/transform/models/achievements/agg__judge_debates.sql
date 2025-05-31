with debate_stats as (
    select
        clovek_id,
        school_year,
        COUNT(*) as debate_count,
        COUNT(*) * 1.5 as hour_count
    from
        {{ ref('base__rozhodci_debata') }}
    group by
        clovek_id,
        school_year
),

summary_characteristics as (
    select
        *,
        case
            when hour_count <= 1.5 then 'TODO'
            when hour_count <= 3 then 'příjemný film (a pak o něm napsat recenzi)'
            when hour_count <= 6 then 'pořádný spánek (a pak napsat argumentativní VŠ esej)'
            when hour_count <= 9 then 'půltucet epizod Soudkyně Barbary (a pak napsat dvakrát tolik mstivých ČSFD recenzí)'
            when hour_count <= 12 then 'trilogii Problém tří těles (a pak se o něm dva dny písemně hádat na Redditu)'
            when hour_count <= 18 then 'všechny Harry Pottery (a pak se týden hádat na Facebooku o transfobii JK Rowling)'
            when hour_count <= 24 then 'TODO'
            when hour_count <= 30 then 'půltýdenní sekci El Camino Santiago (a pak o ní napsat 30 lifestylových článků do Vlasty)'
            when hour_count <= 36 then 'TODO'
            when hour_count <= 45 then 'týdenní šichtu (a pak o ní napsat díl do Hrdinů kapitalistické práce)'
            when hour_count > 45 then 'všechny seriály a filmy Aarona Sorkina (a pak napsat zbylých 51 Federalist Papers)'

        end as activity
    from debate_stats
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('judge_debates') }},
        'Rozhodl/a jsi ' || debate_count || ' debat!' as achievement_name,
        'Za tu dobu sis mohl/a užít ' || activity || '.' as achievement_description,
        JSON_OBJECT('debate_count', debate_count, 'hour_count', hour_count) as achievement_data,
        2 as achievement_priority,
        'numeric' as achievement_type
    from
        summary_characteristics
    where activity is not NULL
)

select * from final
