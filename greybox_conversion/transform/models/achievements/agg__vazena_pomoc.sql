-- NOTE: Doesn't actually count up separate tournament_id's because they're not in the base model
-- -- only approximates the tournament count by counting up the number of tournament debates
with tournament_debates as (
    select
        clovek_id,
        school_year,
        count(*) as num_tournament_debates,
        ceil(count(*) / 5) as num_tournaments
    from
        {{ ref('base__rozhodci_debata') }}
    where
        is_tournament
    group by
        clovek_id,
        school_year
),

achievement as (
    select
        *,
        case
            when num_tournaments < 1 then NULL
            when num_tournaments = 1 then 'skvělý pomocník'
            when num_tournaments <= 2 then 'vážená pomoc při organizování turnajů'
            when num_tournaments <= 4 then 'srdcař, díky kterému mohou být turnaje tak skvělé. Děkujeme'
            when num_tournaments <= 6 then 'turnajový závislák, díky kterému turnaje mohou probíhat jedna radost. Takové my milujeme'
            when num_tournaments > 6 then 'doslova duše našich turnajů a epická pomoc. Jsme Ti opravdu vděčni'
        end as characteristic
    from
        tournament_debates
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('vazena_pomoc') }},
        'Díky za pomoc na turnajích!' as achievement_name,
        'Děkujeme za pomoc při rozhodování na ' || num_tournaments::integer || ' turnajích. Jsi ' || characteristic || '!' as achievement_description,
        1 as achievement_priority,
        json_object(
            'num_tournaments', num_tournaments,
            'num_tournament_debates', num_tournament_debates
        ) as achievement_data,
        'binary' as achievement_type
    from
        achievement
    where characteristic is not NULL
)

select * from final
