WITH achievement AS (
    SELECT
        clovek_id,
        rocnik,
        debate_date,
        CASE
            WHEN COUNT(rocnik) = 1 THEN 'První ročník' 
            ELSE null
        END AS condition_first,

        CASE
            WHEN kidy > 75 THEN 'První nadprůměrná řeč!' 
            ELSE null
        END AS achievement_text,
),

final AS ( 
    SELECT    
        clovek_id,
        rocnik,
        debate_date,
        'Zlepšuji se.' AS achievement_name,
        achievement_text || 'Gratulujeme, zlepšuješ se! Letos se ti povedlo mít první řeč s více než 75 řečnickými body, a to' || debate_date || '!' AS achievement_description,
        'achievement_zlepsuji_se/' || clovek_id || '/' || rocnik AS achievement_id,
        'binary' AS achievement_type,
    FROM achievement
    WHERE condition_first IS NOT null 
)

SELECT * FROM final