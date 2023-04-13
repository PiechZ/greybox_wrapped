with achievement as (
    select
        clovek_id,
        school_year,
        count(*) as debate_count
    from {{ ref('base__debater_debata') }}
    where kidy > 90
    group by 1, 2
),

final as (
    select
        clovek_id,
        school_year,
        'Ultimátní řečník' as achievement_name,
        'Gratuluji, jsi ultimátní řečník v debatní komunitě! Získal jsi přes 90 řečnických bodů!' as achievement_description,
        'binary' as achievement_type,
        10 as achievement_priority,
        json_object('debate_count', debate_count) as achievement_data,
        'achievement_ultimatni_kidy/'
        || clovek_id
        || '/'
        || school_year as achievement_id
    from achievement

)

select * from final
