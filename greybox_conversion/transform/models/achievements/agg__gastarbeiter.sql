with base as (
    select * from {{ ref('base__debater_debata') }}
),

team_club_count as (
    select
        debata_id,
        is_affirmative_speaker,
        klub_id,
        count(*) as club_count
    from base
    group by 1, 2, 3
),

team_club_count_json as (
    -- Group the previous query so that we can have a single row per
    -- team-within-debate, and a JSON object with the club counts that we can
    -- use as a lookup table.
    select
        debata_id,
        is_affirmative_speaker,
        json_group_object(klub_id, club_count) as club_count_json
    from team_club_count
    where klub_id is not NULL
    group by 1, 2
),

merge_back as (
    -- Merge the JSON object back to debater-within-debate granularity
    select
        base.*,
        team_club_count_json.club_count_json
    from base
    left join team_club_count_json using (debata_id, is_affirmative_speaker)
),

gastarbeiters as (
    -- Subset to relevant columns before making the cull (for some reason,
    -- trying to do `where club_count_json->klub_id = 1` directly throws an
    -- aggregation error)
    select
        clovek_id,
        school_year,
        klub_id,
        club_count_json,
        club_count_json -> klub_id as teammates_from_club_in_debate
    from merge_back
),

gastarbeiter_stats as (
    select
        clovek_id,
        school_year,
        count(*) as debate_count
    from gastarbeiters
    where teammates_from_club_in_debate = 1
    group by 1, 2
),

final as (
    select
        clovek_id,
        school_year,
        'gastarbeiter/' || clovek_id || '/' || school_year as achievement_id,
        'Gastarbeiter' as achievement_name,
        'Debatoval/a jsi v týmu s členy jiných klubů! Tvá tolerance tě šlechtí.' as achievement_description,
        json_object('debate_count', debate_count) as achievement_data,
        'binary' as achievement_type,
        4 as achievement_priority
    from gastarbeiter_stats
)

select * from final
