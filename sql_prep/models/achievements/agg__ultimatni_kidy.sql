/*SELECT * FROM {{ ref('clovek_debata') }}
WHERE kidy > 90
AND nazev IN ('Debatní liga XXVIII.', 'Debate League XXVIII.')*/

WITH achievement AS (
    SELECT
        clovek_id,
        rocnik,
        CASE
            WHEN kidy > 90 THEN 'ultimátní řečník' 
            ELSE null
        END AS achievement_text,
    FROM {{ ref('clovek_debata') }}
    WHERE clovek_id IS NOT null
),

final AS(
    SELECT
        clovek_id,
        rocnik,
        'Ultimátní řečník' AS achievement_name,
        'Gratuluji, jsi ' || achievement_text || 'v debatní komunitě! Získal jsi přes 90 řečnických bodů!' AS achievement_description,
        'achievement_ultimatni_kidy/' || clovek_id || '/' || rocnik AS achievement_id,
        'binary' AS achievement_type,
    FROM achievement
    WHERE achievement_text IS NOT null

)

SELECT * FROM final