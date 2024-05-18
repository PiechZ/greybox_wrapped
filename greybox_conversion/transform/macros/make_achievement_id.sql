{% macro make_achievement_id(achievement, person_colname="clovek_id", year_colname="school_year") %}
    '{{ achievement }}/' || {{ person_colname }} || '/' || (case when {{ year_colname }} is not NULL then {{ year_colname }} else 'NULL' end) as achievement_id
{% endmacro %}
