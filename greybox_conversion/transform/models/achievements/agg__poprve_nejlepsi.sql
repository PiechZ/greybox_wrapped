with first_year_debaters as (
    select
        clovek_id,
        MIN(school_year) as first_school_year
    from
        {{ ref("base__debater_debata") }}
    group by
        clovek_id
),

first_ranked_debates as (
    select
        clovek_id,
        school_year,
        debata_id,
        debate_date,
        RANK() over (partition by debata_id order by kidy desc) as speaker_rank
    from
        {{ ref("base__debater_debata") }}
),

first_year_first_ranked_debates as (
    select
        first_year_debaters.clovek_id,
        first_ranked_debates.school_year,
        first_ranked_debates.debata_id,
        first_ranked_debates.debate_date,
        first_ranked_debates.speaker_rank
    from
        first_year_debaters
    inner join
        first_ranked_debates on first_year_debaters.clovek_id = first_ranked_debates.clovek_id and first_year_debaters.first_school_year = first_ranked_debates.school_year
    where
        first_ranked_debates.speaker_rank = 1
),

first_congratulations as (
    select
        clovek_id,
        school_year,
        MIN(debate_date) as first_congratulation_date
    from
        first_year_first_ranked_debates
    group by
        clovek_id,
        school_year
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id("poprve_nejlepsi") }},
        'Poprvé nejlepší!' as achievement_name,
        'Dne ' || STRFTIME(first_congratulation_date, '%d. %m. %Y')
        || ' jsi byl/a poprvé nejlepším mluvčím debaty ve svém prvním roce debatování!' as achievement_description,
        7 as achievement_priority,
        'binary' as achievement_type,
        JSON_OBJECT('date', first_congratulation_date) as achievement_data
    from
        first_congratulations
)

select * from final
