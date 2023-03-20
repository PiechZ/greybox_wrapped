/*SELECT nazev, clovek_id, COUNT() FROM {{ ref('clovek_debata') }}
WHERE nazev IN ('Debatní liga XXVIII.', 'Debate League XXVIII.')
AND kidy > 75
GROUP BY nazev, clovek_id*/

WITH achievement AS (
    SELECT
        clovek_id,
        rocnik,
        COUNT() AS pocet_debat,
        /*CASE
            WHEN kidy > 75 THEN 'Lepší než průměr' 
            ELSE null
        END AS achievement_text,*/
    FROM {{ ref('clovek_debata') }}
    WHERE clovek_id IS NOT null AND kidy > 75
    GROUP BY clovek_id, rocnik
),

final AS(
    SELECT
        clovek_id,
        rocnik,
        'Lepší než průměr' AS achievement_name,
        'Gratuluji, povedlo se ti být' || 'achievement_text'|| 'v' || pocet_debat || 'debatách za tento rok!' AS achievement_description,
        'achievement_lepsi_nez_prumer/' || clovek_id || '/' || rocnik AS achievement_id,
        'numeric' AS achievement_type,
    FROM achievement

)

SELECT * FROM final
