with base_debata_debater_datum as (
    select * from {{ ref('base__debater_debata') }}
    left join {{ ref('base__debata') }} 
    ON base__debater_debata.debata_id = base__debata.debata_id
),


first_last_date_debater as(
    select
        clovek_id,
        min(CAST(debate_date AS datetime)) as first_debate_date,
        max(CAST(debate_date AS datetime)) as last_debate_date,
        DATEDIFF('day', min(CAST(debate_date AS datetime)), max(CAST(debate_date AS datetime))) as days_between_first_last_debate,
        COUNT(DISTINCT debata_id) as number_of_debates
    from base_debata_debater_datum
    group by clovek_id
),

first_last_date_debater_month as(
    select
        clovek_id,
        min(CAST(debate_date AS datetime)) as first_debate_date,
        max(CAST(debate_date AS datetime)) as last_debate_date,
        DATEDIFF('month', min(CAST(debate_date AS datetime)), max(CAST(debate_date AS datetime))) as months_between_first_last_debate,
        count(distinct debata_id) as number_of_debates
    from base_debata_debater_datum
    group by clovek_id
),

agg_first_last_date_debater as(
    select
        months_between_first_last_debate,
        count(distinct clovek_id) as number_of_clovek_id
        from first_last_date_debater_month
        group by months_between_first_last_debate
),

agg_first_last_number_of_debates as(
    select
        FLOOR(number_of_debates / 5) * 5 as debate_range,
        count(distinct clovek_id) as number_of_clovek_id
    from first_last_date_debater
    group by FLOOR(number_of_debates / 5) * 5
),


final as(
    select
        months_between_first_last_debate,
        number_of_clovek_id,
        'months_between_first_last_debate' as type
    from agg_first_last_date_debater
    union all
    select
        debate_range,
        number_of_clovek_id,
        'number_of_debates' as type
    from agg_first_last_number_of_debates
)

select * from final 