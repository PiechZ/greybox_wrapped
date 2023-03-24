WITH achievement AS (
    SELECT
        clovek_id,
        school_year,
        AVG(kidy) AS prumerne_kidy,
        COUNT() AS pocet_debat,
    FROM {{ ref('base__debater_debata') }}
    GROUP BY clovek_id, school_year
),

final AS(
    SELECT
        clovek_id,
        school_year,
        'Dobrý řečník' AS achievement_name,
        'Během letošního roku máš průměrně ' || prumerne_kidy || ' řečnických bodů v ' || pocet_debat || ' debatách za tento rok!' AS achievement_description,
        'achievement_dobry_recnik/' || clovek_id || '/' || school_year AS achievement_id,
        'numeric' AS achievement_type,
        1 as achievement_priority
    FROM achievement
    WHERE prumerne_kidy IS NOT NULL
)

SELECT * FROM final
