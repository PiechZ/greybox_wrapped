-- NOTE: Doesn't actually count up separate tournament_id's because they're not in the base model
-- -- only approximates the tournament count by counting up the number of tournament debates
WITH tournament_debates AS (
    SELECT
        clovek_id,
        school_year,
        count(*) as num_tournament_debates,
        ceil(count(*) / 5) as num_tournaments
    FROM
        {{ ref('base__rozhodci_debata') }}
    WHERE
        is_tournament
    GROUP BY
        clovek_id,
        school_year
),

achievement AS (
    SELECT
        tournament_debates.*,
        CASE
            WHEN num_tournaments < 1 THEN null
            WHEN num_tournaments >= 1 AND num_tournaments <= 2 THEN 'dobrý pomocník'
            WHEN num_tournaments <= 4 THEN 'vážená pomoc při organizování turnajů'
            WHEN num_tournaments <= 6 THEN 'srdcař, díky kterému mohou být turnaje tak skvělé. Děkujeme'
            WHEN num_tournaments > 6 THEN 'turnajový závislák, díky kterému turnaje mohou probíhat jedna radost. Takové my milujeme'
        END AS characteristic
    FROM
        tournament_debates
),

final AS (
    SELECT
        clovek_id,
        school_year,
        {{ make_achievement_id('vazena_pomoc') }},
        'Díky za pomoc na turnajích!' AS achievement_name,
        'Děkujeme za pomoc při rozhodování na ' || round(num_tournaments,0) || ' turnajích. Jsi ' || characteristic || '!' AS achievement_description,
        1 AS achievement_priority,
        json_object(
            'num_tournaments', num_tournaments,
            'num_tournament_debates', num_tournament_debates
        ) AS achievement_data,
        'binary' AS achievement_type
    FROM
        achievement
    WHERE characteristic IS NOT NULL
)

SELECT * FROM final