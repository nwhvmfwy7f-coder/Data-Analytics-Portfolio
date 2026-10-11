-- Question 12: Which product category has the highest profit margin?

SELECT
    p.category,

    SUM(p.price * oi.quantity) AS total_revenue,

    SUM((p.price - p.cost) * oi.quantity) AS total_profit,

    ROUND(
        100.0 * SUM((p.price - p.cost) * oi.quantity)
        / NULLIF(SUM(p.price * oi.quantity), 0),
        2
    ) AS profit_margin_pct

FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY profit_margin_pct DESC;
