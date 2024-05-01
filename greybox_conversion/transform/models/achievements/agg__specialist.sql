with ib_points as (
    select * from {{ ref('base__debater_ib') }}
),

grouped_points as (
    select
        clovek_id,
        school_year,
        activity_type,
        sum(ibody)::float as total_ib_points
    from ib_points
    group by 1, 2, 3
),

pivoted_points as (
    select
        clovek_id,
        school_year,
        max(case when activity_type = 'debate' then total_ib_points end) as debate_ib_points,
        max(case when activity_type = 'other' then total_ib_points end) as other_ib_points,
        other_ib_points / debate_ib_points as points_ratio
    from grouped_points
    group by 1, 2
    having 
        debate_ib_points > 5
        and other_ib_points > 5
),

achievement as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('specialist') }},
        'Specialist(k)a' as achievement_name,
        'Kolik nedebatní IB aktivity zvládneš? Alespoň ' || round(points_ratio, 1) || 'x více než debatní!' as achievement_description,
        3 as achievement_priority,
        json_object(
            'debate_ib_points', round(debate_ib_points, 3),
            'other_ib_points', round(other_ib_points, 3),
            'points_ratio', round(points_ratio, 2)
        ) as achievement_data,
        'binary' as achievement_type
    from pivoted_points
    where points_ratio > 1.2
)

select * from achievement