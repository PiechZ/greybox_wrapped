WITH achievement AS (
    SELECT
        clovek_id,
        school_year,
        COUNT() AS pocet_debat,
    FROM {{ ref('base__debater_debata') }}
    WHERE kidy > 75
    GROUP BY clovek_id, school_year
),

final AS(
    SELECT
        clovek_id,
        school_year,
        'Lepší než průměr' AS achievement_name,
        'Gratuluji, povedlo se ti být' || 'achievement_text'|| 'v' || pocet_debat || 'debatách za tento rok!' AS achievement_description,
        'achievement_lepsi_nez_prumer/' || clovek_id || '/' || school_year AS achievement_id,
        'numeric' AS achievement_type,
    FROM achievement

)

SELECT * FROM final
