with debater_in_debate as (
    select * from {{ ref("base__debater_debata") }}
),

-- count up `kidy` to determine which side has the higher count
-- test if the higher-count side also won the debate

points_per_debate as (
    select
        debata_id,
        is_affirmative_speaker,
        sum(kidy) as points
    from debater_in_debate
    group by 1, 2
),

compare_points_between_sides as (
    select
        debata_id,
        -- pivot within group-by to get the points for each side
        sum(
            case 
                when is_affirmative_speaker then points else 0
            end
        ) as affirmative_points,
        sum(
            case 
                when not is_affirmative_speaker then points else 0
            end
        ) as negative_points
    from points_per_debate
    group by 1
),

merge_back as (
    select
        debater_in_debate.*,
        compare_points_between_sides.affirmative_points,
        compare_points_between_sides.negative_points
    from debater_in_debate
    left join compare_points_between_sides using (debata_id)
),

lpw as (
    select
        *,
        (
            (affirmative_points > negative_points and not is_affirmative_win) or
            (affirmative_points < negative_points and is_affirmative_win)
        ) as is_low_point_win
    from merge_back
),

achievement_base as (
    select
        clovek_id,
        school_year,
        count(*) as lpw_debate_count
    from lpw
    where is_low_point_win
    group by 1, 2
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('lpw_count') }},
        'Co je doma, to se počítá' as achievement_name,
        'Vyhrál/a jsi alespoň jednu debatu, ve které měl soupeř dohromady více bodů než ty.' as achievement_description,
        json_object(
            'lpw_debate_count', lpw_debate_count
        ) as achievement_data,
        'binary' as achievement_type,
        4 as achievement_priority
    from achievement_base
)

select * from final