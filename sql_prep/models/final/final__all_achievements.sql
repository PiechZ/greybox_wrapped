{% 
    set achievement_relations = dbt_utils.get_relations_by_pattern(
        'adk_wrapped',
        'agg__%',
        exclude=[]
    )
%}
with all_achievements_unioned as (
    {{
        dbt_utils.union_relations(
            relations=[
                ref("agg__prehlasovan"),
                ref("agg__multilingvni"),
            ],
        )
    }}
),

final as (
    select
        clovek_id,
        school_year,
        achievement_id,
        achievement_name,
        achievement_description,
        achievement_data,
        achievement_type,
        achievement_priority
    from all_achievements_unioned
    where achievement_id is not null
)

select * from final
