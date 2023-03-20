WITH vyhra AS (
    SELECT 

),

achievement AS (
    SELECT
        clovek_id,
        rocnik,
        debate_date,
        CASE
            WHEN COUNT(rocnik) = 1 THEN 'První ročník' 
            ELSE null
        END AS condition_first,
        
        CASE
            WHEN vyhra THEN 'První výhra!' 
            ELSE null
        END AS achievement_text,
),

final AS ( 
    SELECT    
        clovek_id,
        rocnik,
        debate_date,
        'První výhra' AS achievement_name,
        achievement_text || 'Letos se ti povedlo dosáhnout první výhry, a to' || debate_date || '!' AS achievement_description,
        'achievement_prvni_vyhra/' || clovek_id || '/' || rocnik AS achievement_id,
        'binary' AS achievement_type,
    FROM achievement
    WHERE condition_first IS NOT null 
)

SELECT * FROM final