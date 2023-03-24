WITH base AS (
    SELECT * FROM {{ ref('base__debater_debata') }}
),

newbies AS (
    SELECT * from base
    RIGHT JOIN {{ ref('base__newbies') }} using (clovek_id)
),

achievement AS (
    SELECT
        clovek_id,
        school_year,
        AVG(kidy) AS prumerne_kidy,
        COUNT() AS pocet_debat,
    FROM newbies
    GROUP BY clovek_id, school_year
),

final AS ( 
    SELECT    
        clovek_id,
        school_year,
        'Talent' AS achievement_name,
        'Gratulujeme, jsi talent! Debatuješ první rok, a v ' || pocet_debat || ' debatách máš průměrně ' || prumerne_kidy || ' řečnických bodů!' AS achievement_description,
        'achievement_talent/' || clovek_id || '/' || school_year AS achievement_id,
        'binary' AS achievement_type,
        5 AS achievement_priority
    FROM achievement
    WHERE prumerne_kidy > 75
)

SELECT * FROM final