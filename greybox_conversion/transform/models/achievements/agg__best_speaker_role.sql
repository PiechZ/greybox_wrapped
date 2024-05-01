-- NOTE: Doesn't currently separate between languages, 
-- nor does it rule out non-Cup debates
with speaker_points_avg as (
  select
    clovek_id,
    school_year,
    role,
    avg(kidy) as average_points,
    count(*) as samples
  from
    {{ ref('base__debater_debata') }}
  where kidy is not null
  group by
    clovek_id,
    school_year,
    role
),

best_speaker as (
  select
    school_year,
    role,
    clovek_id,
    average_points,
    samples,
    rank() over (
      partition by school_year, role order by average_points desc
    ) as speaker_rank
  from
    speaker_points_avg
  where samples >= 5
),

achievement as (
  select
    school_year,
    role,
    clovek_id,
    average_points,
    speaker_rank,
    samples
  from
    best_speaker
  where
    speaker_rank = 1
  order by
    school_year,
    role
),

final as (
  select
    clovek_id,
    school_year,
    {{ make_achievement_id('best_speaker_role', 'clovek_id || role') }},
    'Nejlepší mluvčí roku v roli ' || upper(role) || '!' as achievement_name,
    round(average_points, 2) || ' je skvělý výkon 😎' as achievement_description,
    10 as achievement_priority,
    'binary' as achievement_type,
    json_object('role', role, 'average_points', average_points) as achievement_data
  from achievement
)

select * from final
