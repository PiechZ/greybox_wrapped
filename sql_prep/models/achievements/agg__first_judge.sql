WITH debates as (
    select * from {{ ref('base__rozhodci_debata') }}
),

earliest_debate_id AS (
    SELECT
        clovek_id,
        -- we can rely on lowest debata_id being the earliest debate
        MIN(debata_id) AS first_debata_id,
    FROM
        debates
    GROUP BY
        1
),

earliest_debate as (
    SELECT
        earliest_debate_id.clovek_id,
        debates.school_year,
        debates.debate_date,
        debates.motion_text
    FROM
        earliest_debate_id
    INNER JOIN
        debates ON earliest_debate_id.first_debata_id = debates.debata_id and earliest_debate_id.clovek_id = debates.clovek_id
),

final AS (
    SELECT
        clovek_id,
        school_year,
        {{ make_achievement_id('first_judge') }},
        'Tvá první rozhodnutá debata!' as achievement_name,
        '...byla dne ' || strftime(debate_date, '%d. %m. %Y') || ' na tezi ' || motion_text || '.' as achievement_description,
        json_object('debate_date', debate_date, 'motion_text', motion_text) as achievement_data,
        5 as achievement_priority,
        'binary' as achievement_type
    FROM
        earliest_debate
)

SELECT * FROM final
