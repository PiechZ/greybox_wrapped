WITH speaker_points_sum AS (
  SELECT
    clovek_id,
    school_year,
    role,
    avg(kidy) AS total_points,
    count(*) as samples
  FROM
    {{ ref('base__debater_debata') }}
  WHERE kidy is not null
  GROUP BY
    clovek_id,
    school_year,
    role
),

best_speaker AS (
  SELECT
    school_year,
    role,
    clovek_id,
    total_points,
    samples,
    RANK() OVER (PARTITION BY school_year, role ORDER BY total_points DESC) AS speaker_rank
  FROM
    speaker_points_sum
  WHERE samples >= 5
),

achievement as (
    SELECT
        school_year,
        role,
        clovek_id,
        total_points,
        speaker_rank,
        samples
    FROM
        best_speaker
    WHERE
        speaker_rank = 1
    ORDER BY
        school_year,
        role
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('best_speaker_role') }},
        'Nejlepší mluvčí roku v roli ' || upper(role) || '!' as achievement_name,
        round(total_points, 2) || ' je skvělý výkon :)' as achievement_description,
        7 as achievement_priority,
        'binary' as achievement_type,
        json_object('role', role, 'total_points', total_points) as achievement_data
    from achievement
)

select * from final