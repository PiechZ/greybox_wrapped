with base as (
    select * from {{ ref('base__debater_debata') }}
),

newbies as (
    select base.* from base
    right join {{ ref('base__newbies') }} using (clovek_id)
),

vyhry as (
    select
        clovek_id,
        school_year,
        debate_date
    from newbies
    where is_winner = TRUE
    order by debate_date
),

/*achievement AS (
    SELECT
        clovek_id,
        school_year,
        MIN(debate_date)
    FROM vyhry
    GROUP BY clovek_id
),*/

achievement as (
    select distinct on (clovek_id) *
    from vyhry
),

final as (
    select
        clovek_id,
        school_year,
        debate_date,
        'První výhra' as achievement_name,
        'Letos se ti povedlo dosáhnout první výhry, a to ' || strftime(debate_date, '%d. %m. %Y') || '!' as achievement_description,
        'achievement_prvni_vyhra/' || clovek_id || '/' || school_year as achievement_id,
        'binary' as achievement_type,
        3 as achievement_priority
    from achievement
)

select * from final
