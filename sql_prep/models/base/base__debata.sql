with debates as (
    select * from {{ source('raw', 'debata') }}
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
        debates.datum
    from all_debates
    left join debates using (debata_id)
)

select * from final