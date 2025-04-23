WITH orders AS (
    SELECT
        identifier AS order_id,
        dishes_ids
    FROM {{ ref('base_orders') }}
),

order_items AS (
    SELECT
        o.order_id,
        f.value::integer AS dish_id -- Extract dish ID from the flattened JSON array element
    FROM orders o,
    LATERAL FLATTEN(input => PARSE_JSON(o.dishes_ids)) f -- Unnest the JSON array string
),

order_dish_names AS (
    SELECT
        oi.order_id,
        d.name AS dish_name
    FROM order_items oi
    JOIN {{ ref('base_dishes') }} d ON oi.dish_id = d.identifier
),

-- Self-join to create pairs of dishes within the same order
dish_pairs AS (
    SELECT
        odn1.order_id,
        odn1.dish_name AS dish_name_a,
        odn2.dish_name AS dish_name_b
    FROM order_dish_names odn1
    JOIN order_dish_names odn2 ON odn1.order_id = odn2.order_id
    WHERE odn1.dish_name < odn2.dish_name -- Ensure pairs are unique (A,B not B,A) and avoid self-pairs (A,A)
)

-- Count the co-occurrence of each dish pair
SELECT
    dish_name_a,
    dish_name_b,
    COUNT(*) AS co_occurrence_count
FROM dish_pairs
GROUP BY
    dish_name_a,
    dish_name_b
ORDER BY
    co_occurrence_count DESC