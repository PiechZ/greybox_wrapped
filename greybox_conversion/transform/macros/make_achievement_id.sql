{% macro make_achievement_id(achievement, person_colname="clovek_id", year_colname="school_year") %}
    '{{ achievement }}/' || {{ person_colname }} || '/' || {{ year_colname }} as achievement_id
{% endmacro %}