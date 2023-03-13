with debates_per_language as (
    select
        clovek_id,
        jazyk,
        count() as pocet_debat
    from {{ ref('clovek_debata') }}
    group by 1, 2
),

languages_per_debater as (
    select
        clovek_id,
        count() as pocet_jazyku
    from debates_per_language
    group by 1
),

final as (
    select
        clovek_id,
        case 
            when pocet_jazyku > 2 then 'multilingvní'
            when pocet_jazyku > 1 then 'bilingvní'
            else null
        end as achievement
    from languages_per_debater
)

select * from final
where achievement is not null