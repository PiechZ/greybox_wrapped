with debates as (
    select * from {{ source('raw', 'debata') }}
),

debates_in_years as (
    select
        *,
        date_sub('year', DATE '2000-09-01', datum) as school_year
    from debates
),

motions as (
    select * from {{ source('raw', 'teze') }}
),

tournaments as (
    select * from {{ source('raw', 'turnaj') }}
),

competitions as (
    select * from {{ source('raw', 'soutez') }}
),

leagues as (
    select * from {{ source('raw', 'liga') }}
),

judges as (
    select 
        clovek_id,
        debata_id,
        rozhodnuti as has_voted_affirmative,
        presvedcive as is_persuasive
    from {{ source('raw', 'clovek_debata') }}
    where role = 'r'
),

ballots as (
    select
        debata_id,
        count(*) as total_ballots,
        sum(case when has_voted_affirmative then 1 else 0 end) as affirmative_ballots,
        count(*) - sum(case when has_voted_affirmative then 1 else 0 end) as negative_ballots
    from judges
    group by 1
),

single_ballot_debates as (
    select
        ballots.debata_id,
        judges.has_voted_affirmative as is_affirmative_win,
        judges.is_persuasive as is_persuasive_win,
        FALSE as is_draw,
        case
            when judges.has_voted_affirmative and judges.is_persuasive then 3
            when judges.has_voted_affirmative and not judges.is_persuasive then 2
            when not judges.has_voted_affirmative and not judges.is_persuasive then 1
            when not judges.has_voted_affirmative and judges.is_persuasive then 0
        end as affirmative_ballots_normalized,
        ballots.affirmative_ballots,
        ballots.negative_ballots,
        ballots.total_ballots as judge_count
    from ballots
    left join judges using (debata_id)
    where ballots.total_ballots = 1
),

multi_ballot_debates as (
    select
        ballots.debata_id,
        affirmative_ballots > negative_ballots as is_affirmative_win,
        affirmative_ballots = 0 or negative_ballots = 0 as is_persuasive_win,
        affirmative_ballots = negative_ballots as is_draw,
        case
            when affirmative_ballots > negative_ballots and negative_ballots = 0 then 3
            when affirmative_ballots > negative_ballots and negative_ballots > 0 then 2
            when affirmative_ballots < negative_ballots and affirmative_ballots > 0 then 1
            when affirmative_ballots < negative_ballots and affirmative_ballots = 0 then 0
            when affirmative_ballots = negative_ballots then 1.5
        end as affirmative_ballots_normalized,
        affirmative_ballots,
        negative_ballots,
        total_ballots as judge_count
    from ballots
    where ballots.total_ballots > 1
),

all_debates as (
    select * from single_ballot_debates
    union all
    select * from multi_ballot_debates
),

final as (
    select
        all_debates.*,
        3 - all_debates.affirmative_ballots_normalized as negative_ballots_normalized,
        debates_in_years.datum as debate_date,
        debates_in_years.school_year,
        motions.jazyk as language,
        motions.tx as motion_text,
        motions.tx_short as motion_short,
        debates_in_years.turnaj_id is not null as is_tournament,
        debates_in_years.soutez_id is not null as is_competition,
        leagues.nazev as league_name,
        -- tournaments.nazev as tournament_name,
        competitions.nazev as competition_name
    from all_debates
    left join debates_in_years using (debata_id)
    left join motions using (teze_id)
    left join tournaments using (turnaj_id)
    left join competitions on debates_in_years.soutez_id = competitions.soutez_id
    left join leagues on tournaments.liga_id = leagues.liga_id
)

select * from final