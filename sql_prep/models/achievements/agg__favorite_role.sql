with debater_position_count as (
  select
    clovek_id,
    school_year,
    role,
    COUNT(*) as position_count
  from
    {{ ref('base__debater_debata') }}
  group by
    clovek_id,
    school_year,
    role
),

league_position_count as (
  select
    school_year,
    role,
    COUNT(*) as league_position_count
  from
    {{ ref('base__debater_debata') }}
  group by
    school_year,
    role
),

debater_position_rank as (
  select
    clovek_id,
    school_year,
    role,
    position_count,
    DENSE_RANK() over (
      partition by clovek_id, school_year order by position_count desc
    ) as position_rank
  from
    debater_position_count
),

debater_position_with_league_count as (
  select
    debater_position_rank.clovek_id,
    debater_position_rank.school_year,
    debater_position_rank.role,
    debater_position_rank.position_count,
    debater_position_rank.position_rank,
    league_position_count.league_position_count
  from
    debater_position_rank
  inner join
    league_position_count
    using (school_year, role)
  where
    debater_position_rank.position_rank = 1
),

debater_avg_points as (
  select
    clovek_id,
    school_year,
    role,
    AVG(kidy) as avg_points
  from
    {{ ref('base__debater_debata') }}
  where kidy is not null
  group by
    clovek_id,
    school_year,
    role
),

achievement as (
  select
    debater_position_with_league_count.clovek_id,
    debater_position_with_league_count.school_year,
    debater_position_with_league_count.role,
    debater_position_with_league_count.position_count,
    debater_position_with_league_count.league_position_count,
    debater_avg_points.avg_points,
    (
      debater_position_with_league_count.position_count::FLOAT
      / debater_position_with_league_count.league_position_count::FLOAT
    )
    * 100 as individual_frequency_percentage
  from
    debater_position_with_league_count
  inner join
    debater_avg_points using (clovek_id, school_year, role)
  where
    debater_position_with_league_count.position_count >= 5
),

deduplicated_achievements as (
  select
    clovek_id,
    school_year,
    role,
    position_count,
    league_position_count,
    avg_points,
    individual_frequency_percentage,
    ROW_NUMBER() over (partition by clovek_id, school_year order by avg_points desc) as rank_by_avg_points
  from
    achievement
),

highest_avg_point_achievements as (
  select
    *
  from
    deduplicated_achievements
  where
    rank_by_avg_points = 1
),

final as (
  select
    clovek_id,
    school_year,
    {{ make_achievement_id('favorite_role') }},
    'Tvá oblíbená role je...' as achievement_name,
    '...' || upper(role) || '! Dosáhl/a jsi na ní průměrně ' || round(avg_points, 2) || ' bodů.' as achievement_description,
    json_object(
      'role', role,
      'avg_points', avg_points,
      'position_count', position_count,
      'individual_frequency_percentage', individual_frequency_percentage
    ) as achievement_data,
    'binary' as achievement_type,
    6 as achievement_priority
  from highest_avg_point_achievements
)

select * from final
