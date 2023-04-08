WITH achievement AS (
    SELECT
        clovek_id,
        school_year,
        count(*) as debate_count
    FROM {{ ref('base__debater_debata') }}
    WHERE kidy > 90
    GROUP BY 1, 2
),

final AS (
    SELECT
        clovek_id,
        school_year,
        'Ultimátní řečník' AS achievement_name,
        'Gratuluji, jsi ultimátní řečník v debatní komunitě! Získal jsi přes 90 řečnických bodů!' AS achievement_description,
        json_object('debate_count', debate_count) as achievement_data,
        'achievement_ultimatni_kidy/' || clovek_id || '/' || school_year AS achievement_id,
        'binary' AS achievement_type,
        10 AS achievement_priority
    FROM achievement

)

SELECT * FROM final