WITH achievement AS (
    SELECT
        clovek_id,
        school_year,
        debata_id, -- for debug purposes
        'ultimátní řečník' AS achievement_text
    FROM {{ ref('base__debater_debata') }}
    WHERE kidy > 90
    ORDER BY debate_date
),

final AS(
    SELECT
        clovek_id,
        school_year,
        debata_id, -- for debug purposes
        'Ultimátní řečník' AS achievement_name,
        'Gratuluji, jsi ' || achievement_text || ' v debatní komunitě! Získal jsi přes 90 řečnických bodů!' AS achievement_description,
        'achievement_ultimatni_kidy/' || clovek_id || '/' || school_year AS achievement_id,
        'binary' AS achievement_type,
        10 AS achievement_priority
    FROM achievement

)

SELECT * FROM final