with base as (
    select * from {{ ref('base__debater_debata') }}
),

newbies as (
    select * from base
    right join {{ ref('base__newbies') }} using (clovek_id)
),

vyhry as (
    select
        clovek_id,
        school_year,
        debate_date
    from newbies
    where is_winner = true
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
        'binary' as achievement_type,
        3 as achievement_priority,
        'Letos se ti povedlo dosáhnout první výhry, a to'
        || debate_date
        || '!' as achievement_description,
        'achievement_prvni_vyhra/'
        || clovek_id
        || '/'
        || school_year as achievement_id
    from achievement
)

select * from final
