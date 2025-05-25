{#
    set achievement_relations = dbt_utils.get_relations_by_pattern(
        'adk_wrapped',
        'agg__%',
        exclude=[]
    )
#}
with all_achievements_unioned as (
    {{
        dbt_utils.union_relations(
            relations=[
                ref("agg__best_speaker_role"),
                ref('agg__dobry_recnik'),
                ref('agg__dotknout_se_hvezd'),
                ref("agg__favorite_role"),
                ref("agg__gastarbeiter"),
                ref('agg__lepsi_nez_prumer'),
                ref("agg__lpw_count"),
                ref("agg__multilingvni"),
                ref("agg__neporazitelny"),
                ref("agg__poprve_nejlepsi"),
                ref("agg__prehlasovan"),
                ref("agg__pripravenost"),
                ref("agg__prvni_vyhra"),
                ref("agg__talent"),
                ref("agg__ultimatni_kidy"),
                ref("agg__zlepsuji_se"),
                ref("agg__sberatel_debat"),
                ref("agg__turnajovy_zavislak"),
                ref("agg__first_judge"),
                ref("agg__judge_debates"),
                ref("agg__vazena_pomoc"),
                ref("agg__ib_fanatik"),
                ref("agg__napul_cesty"),
                ref("agg__prvni_kroky"),
                ref("agg__fun_committee"),
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
        coalesce(achievement_data, json_object()) as achievement_data,
        achievement_type,
        achievement_priority,
        -- Grab internal name of achievement as identifier for the slide image
        regexp_extract(_dbt_source_relation, '"agg__([^"]+)"$', 1) as achievement_image
    from all_achievements_unioned
    where achievement_id is not NULL
)

select * from final
