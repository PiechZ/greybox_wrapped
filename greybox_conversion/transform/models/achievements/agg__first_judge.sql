with debates as (
    select * from {{ ref('base__rozhodci_debata') }}
),

earliest_debate_id as (
    select
        clovek_id,
        -- we can rely on lowest debata_id being the earliest debate
        MIN(debata_id) as first_debata_id
    from
        debates
    group by
        1
),

earliest_debate as (
    select
        earliest_debate_id.clovek_id,
        debates.school_year,
        debates.debate_date,
        debates.motion_text
    from
        earliest_debate_id
    inner join
        debates on earliest_debate_id.first_debata_id = debates.debata_id and earliest_debate_id.clovek_id = debates.clovek_id
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('first_judge') }},
        'Tvá první rozhodnutá debata!' as achievement_name,
        '...byla dne ' || STRFTIME(debate_date, '%d. %m. %Y') || ' na tezi ' || motion_text || '.' as achievement_description,
        JSON_OBJECT('debate_date', debate_date, 'motion_text', motion_text) as achievement_data,
        5 as achievement_priority,
        'binary' as achievement_type
    from
        earliest_debate
)

select * from final
