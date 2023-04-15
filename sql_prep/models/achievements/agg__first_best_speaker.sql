WITH base AS (
    SELECT * FROM {{ ref('base__debater_debata') }}
),

newbies AS (
    SELECT * from base
    RIGHT JOIN {{ ref('base__newbies') }} using (clovek_id)
),

