with base as (
    select * from {{ ref('base__debater_debata') }}
),

newbies as (
    select * from base
    right join {{ ref('base__newbies') }} using (clovek_id)
),

kidy_malych_kidu as (
    select
        clovek_id,
        school_year,
        debate_date
    from newbies
    where kidy > 75
    order by debate_date
),

achievement as (
    select distinct on (clovek_id) *
    from kidy_malych_kidu
),

final as (
    select
        clovek_id,
        school_year,
        debate_date,
        'Zlepšuji se.' as achievement_name,
        'binary' as achievement_type,
        2 as achievement_priority,
        'Gratulujeme, zlepšuješ se! Letos se ti povedlo mít první řeč s více než 75 řečnickými body, a to '
        || debate_date
        || ' !' as achievement_description,
        'achievement_zlepsuji_se/'
        || clovek_id
        || '/'
        || school_year as achievement_id
    from achievement
)

select * from final
