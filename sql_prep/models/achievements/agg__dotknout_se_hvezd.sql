WITH base AS (
    SELECT * FROM {{ ref('base__debater_debata') }}
),

dobre_debaty AS(
    SELECT
        clovek_id,
        school_year,
    FROM base
    WHERE kidy > 85
),

achievement AS(
    SELECT
        clovek_id,
        school_year,
        COUNT() AS pocet_debat
    FROM dobre_debaty
    GROUP BY clovek_id, school_year
    ORDER BY school_year

),

final AS(
    SELECT
        clovek_id,
        school_year,
        'Dotknout se hvězd' AS achievement_name,
        'V této sezoně se ti podařilo ve ' || pocet_debat || ' debatách podat výkon nad 85 bodů! Bravo!' AS achievement_description,
        'achievement_dotknout_se_hvezd/' || clovek_id || '/' || school_year AS achievement_id,
        'numeric' AS achievement_type,
        8 AS achievement_priority
    FROM achievement
    WHERE pocet_debat >= 2
)

SELECT * FROM final
