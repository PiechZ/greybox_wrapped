WITH achievement AS (
    SELECT
        clovek_id,
        rocnik,
        AVG(kidy) AS prumerne_kidy,
        'průměrně' || prumerne_kidy || 'řečnických bodů' AS achievement_text,
        COUNT() AS pocet_debat,
    FROM {{ ref('clovek_debata') }}
    WHERE clovek_id IS NOT null
),

final AS(
    SELECT
        clovek_id,
        rocnik,
        'Dobrý řečník' AS achievement_name,
        'Během letošního roku máš' || achievement_text || 'v' || pocet_debat || 'debatách za tento rok!' AS achievement_description,
        'achievement_dobry_recnik/' || clovek_id || '/' || rocnik AS achievement_id,
        'numeric' AS achievement_type,
    FROM achievement
    WHERE prumerne_kidy IS NOT null

)

SELECT * FROM final
