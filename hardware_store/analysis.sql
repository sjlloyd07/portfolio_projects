
---- complete inventory count w/ details

-- SELECT 
-- 	c.name AS category,
-- 	p.name AS product,
-- 	p.description,
-- 	p.list_price,
-- 	p.std_cost,
-- 	i.quantity,
-- 	wh.name AS warehouse,
-- 	wh.country_id AS country
-- FROM product p
-- JOIN category c
-- 	ON c.id = p.category_id
-- JOIN inventory i
-- 	ON p.id = i.product_id
-- JOIN warehouse wh
-- 	ON wh.id = i.warehouse_id
-- ORDER BY
-- 	country,
-- 	warehouse,
-- 	category,
-- 	product,
-- 	std_cost DESC
-- LIMIT 5
-- ;







---- ANALYSIS

---- confirm that the company inventory accounts for all warehouses and products
-- SELECT 
-- 	COUNT(DISTINCT i.product_id) AS unique_products_counted,
-- 	COUNT(DISTINCT p.id) AS unique_products_expected,
-- 	COUNT(DISTINCT i.warehouse_id) AS unique_wh_counted,
-- 	COUNT(DISTINCT w.id) AS unique_wh_expected
-- FROM inventory i
-- JOIN warehouse w
-- 	ON w.id = i.warehouse_id
-- JOIN product p
-- 	ON p.id = i.product_id





---- total product count and value
-- SELECT 
-- 	COUNT (DISTINCT i.product_id) AS unique_products,
-- 	TO_CHAR(SUM(i.quantity), '999,999') AS total_product_count,
-- 	TO_CHAR(SUM(i.quantity * p.std_cost), 'L999,999,999D99') AS total_cost,
-- 	TO_CHAR(SUM(i.quantity * p.list_price), 'L999,999,999D99') AS total_list_value
-- FROM inventory i
-- JOIN product p
-- 	ON i.product_id = p.id




---- total product count and value at each warehouse (ordered by value)
-- WITH wh_cte AS (
-- 	SELECT
-- 		w.name AS warehouse,
-- 		co.name AS country,
-- 		TO_CHAR(SUM(i.quantity), '999,999,999') AS product_count,
-- 		ROUND(SUM(i.quantity * p.std_cost)/1000000, 1) AS total_cost,
-- 		ROUND(SUM(i.quantity * p.list_price)/1000000, 1) AS total_list_value
-- 	FROM product p
-- 	JOIN inventory i
-- 		ON i.product_id = p.id
-- 	JOIN warehouse w
-- 		ON w.id = i.warehouse_id
-- 	JOIN country co
-- 		ON co.id = w.country_id
-- 	GROUP BY 
-- 		co.name,
-- 		w.name
-- 	ORDER BY 
-- 		country,
-- 		product_count DESC
-- 	)

-- SELECT
-- 	warehouse,
-- 	country,
-- 	product_count,
-- 	TO_CHAR(total_cost, 'L999D9') || ' m' AS total_cost,
-- 	TO_CHAR(total_list_value, 'L999D9') || ' m' AS total_list_value,
-- 	ROUND((total_list_value / SUM(total_list_value) OVER()) * 100, 1) || ' %' AS pct_gross_inv_value
-- FROM wh_cte
-- ORDER BY ROUND((total_cost / SUM(total_cost) OVER()) * 100, 1) DESC






---- * total company product count and value by category
-- WITH cat_cte AS(	
-- 	SELECT
-- 		c.name AS category,
-- 		SUM(i.quantity) AS product_qty,
-- 		ROUND(AVG(p.std_cost), 2) AS avg_cost,
-- 		ROUND(SUM(i.quantity * p.std_cost)/1000000, 1) AS tot_cost_mil,
-- 		ROUND(AVG(p.list_price), 2) AS avg_list,
-- 		ROUND(SUM(i.quantity * p.list_price)/1000000, 1) AS tot_list_mil
-- 	FROM product p
-- 	JOIN category c
-- 		ON p.category_id = c.id
-- 	JOIN inventory i
-- 		ON i.product_id = p.id
-- 	GROUP BY c.name
-- 	ORDER BY SUM(i.quantity * p.std_cost) DESC
-- 	)

-- SELECT 
-- 	category,
-- 	TO_CHAR(product_qty, '999,999') AS product_qty,
-- 	TO_CHAR(tot_cost_mil, 'L999D9') || ' m' AS total_cost,
-- 	TO_CHAR(tot_list_mil, 'L999D9') || ' m' AS total_list_price,
-- 	ROUND(((tot_list_mil - tot_cost_mil) / tot_cost_mil) * 100, 1) || ' %' AS gross_rate_of_return
-- FROM cat_cte





---- * total product count and value by category at each warehouse 
-- WITH wh_cte AS (	
-- 	SELECT
-- 		w.name AS warehouse,
-- 		co.name AS country,
-- 		cat.name AS category,
-- 		SUM(i.quantity) AS qty,
-- 		ROUND(SUM(i.quantity * p.std_cost),0) AS tot_cost
-- 	FROM product p
-- 	JOIN category cat
-- 		ON p.category_id = cat.id
-- 	JOIN inventory i
-- 		ON i.product_id = p.id
-- 	JOIN warehouse w
-- 		ON w.id = i.warehouse_id
-- 	JOIN country co
-- 		ON co.id = w.country_id
-- 	GROUP BY 
-- 		cat.name,
-- 		co.name,
-- 		w.name
-- 	ORDER BY 
-- 		warehouse,
-- 		country,
-- 		category
-- 	)

-- SELECT 
-- 	warehouse,
-- 	country,
-- 	category,
-- 	TO_CHAR(qty, '999,999') AS qty,
-- 	TO_CHAR(tot_cost, 'L999,999,999D') AS total_cost,
-- 	ROUND((tot_cost / SUM(tot_cost) OVER(PARTITION BY warehouse)) * 100, 1) || ' %' AS pct_gross_wh_cost
-- FROM wh_cte







---- * products with highest gross value (top 10)
-- SELECT
-- 	c.name,
-- 	p.id AS product_id,
-- 	p.name AS product,
-- 	SUM(i.quantity) AS gross_product_qty,
-- 	TO_CHAR(ROUND(SUM(i.quantity * p.std_cost),0), 'L999,999,999') AS gross_inv_value
-- FROM product p
-- JOIN inventory i
-- 	ON i.product_id = p.id
-- JOIN category c
-- 	ON c.id = p.category_id
-- GROUP BY 
-- 	c.name,
-- 	p.id,
-- 	p.name
-- ORDER BY
-- 	gross_inv_value DESC
-- LIMIT 10




---- * products with highest gross value at each warehouse
-- WITH gross_value_cte AS (
-- 	SELECT
-- 		w.name AS warehouse,
-- 		c.name AS category,
-- 		p.id AS product_id,
-- 		p.name AS product,
-- 		SUM(i.quantity) AS gross_product_qty,
-- 		TO_CHAR(ROUND(SUM(i.quantity * p.std_cost),0), 'L999,999,999') AS gross_product_value,
-- 		RANK() OVER(PARTITION BY w.name ORDER BY SUM(i.quantity * p.std_cost) DESC)
-- 	FROM product p
-- 	JOIN inventory i
-- 		ON i.product_id = p.id
-- 	JOIN category c
-- 		ON c.id = p.category_id
-- 	JOIN warehouse w
-- 		ON i.warehouse_id = w.id
-- 	GROUP BY 
-- 		w.name,
-- 		c.name,
-- 		p.id,
-- 		p.name
-- 	ORDER BY
-- 		w.name,
-- 		gross_product_value DESC
-- 	)

-- SELECT
-- 	warehouse,
-- 	category,
-- 	product,
-- 	gross_product_qty,
-- 	gross_product_value
-- FROM gross_value_cte
-- WHERE rank = 1






---- * product with highest gross value in each category
-- WITH gross_value_cte AS (
-- 	SELECT
-- 		c.name AS category,
-- 		p.id AS product_id,
-- 		p.name AS product,
-- 		SUM(i.quantity) AS gross_product_qty,
-- 		TO_CHAR(ROUND(SUM(i.quantity * p.std_cost),0), 'L999,999,999') AS gross_product_value,
-- 		RANK() OVER(PARTITION BY c.name ORDER BY SUM(i.quantity * p.std_cost) DESC)
-- 	FROM product p
-- 	JOIN inventory i
-- 		ON i.product_id = p.id
-- 	JOIN category c
-- 		ON c.id = p.category_id
-- 	GROUP BY 
-- 		c.name,
-- 		p.id,
-- 		p.name
-- 	ORDER BY
-- 		gross_product_value DESC
-- 	)

-- SELECT
-- 	category,
-- 	product,
-- 	gross_product_qty,
-- 	gross_product_value
-- FROM gross_value_cte
-- WHERE rank = 1





------ most / least profitable product of each category

-- CREATE TEMP TABLE products_ranked AS (
-- 	SELECT
-- 		c.name AS category,
-- 		p.id AS product_id,
-- 		p.name AS product,
-- 		p.list_price - p.std_cost AS gross_profit,
-- 		RANK() OVER(PARTITION BY c.name ORDER BY p.list_price - p.std_cost DESC) AS profit_rank_hi,
-- 		RANK() OVER(PARTITION BY c.name ORDER BY p.list_price - p.std_cost) AS profit_rank_lo,
-- 		ROUND(((p.list_price - p.std_cost) / p.std_cost) * 100, 2) AS gross_ror,
-- 		RANK() OVER(PARTITION BY c.name ORDER BY (p.list_price - p.std_cost) / p.std_cost DESC) AS ror_rnk_hi,
-- 		RANK() OVER(PARTITION BY c.name ORDER BY (p.list_price - p.std_cost) / p.std_cost) AS ror_rnk_lo

-- 	FROM product p
-- 	JOIN inventory i
-- 		ON i.product_id = p.id
-- 	JOIN category c
-- 		ON c.id = p.category_id
-- 	GROUP BY 
-- 		c.name,
-- 		p.name,
-- 		p.id,
-- 		p.list_price,
-- 		p.std_cost
-- 	ORDER BY 
-- 		category,
-- 		p.list_price - p.std_cost DESC
-- 	);


-- SELECT *
-- FROM products_ranked
-- LIMIT 5;


------ GROSS PROFIT -------------------

-- WITH profit_hi_cte AS (
-- 	SELECT
-- 		category,
-- 		product,
-- 		product_id,
-- 		TO_CHAR(gross_profit, 'L999,999,999D99') AS profit_per_unit 
-- 	FROM products_ranked 
-- 	WHERE profit_rank_hi = 1
-- 	ORDER BY profit_per_unit DESC
-- 	),
-- profit_lo_cte AS (
-- 	SELECT
-- 		category,
-- 		product,
-- 		product_id,
-- 		TO_CHAR(gross_profit, 'L999,999,999D99') AS profit_per_unit 
-- 	FROM products_ranked 
-- 	WHERE profit_rank_lo = 1
-- 	ORDER BY profit_per_unit
-- 	)

-- SELECT
-- 	ph.category,
-- 	ph.product AS product_gross_profit_hi,
-- 	ph.profit_per_unit,
-- 	pl.product AS product_gross_profit_lo,
-- 	pl.profit_per_unit

-- FROM profit_hi_cte ph
-- JOIN profit_lo_cte pl
--  ON ph.category = pl.category


------ RATE OF RETURN ------

-- WITH ror_hi_cte AS (
-- 	SELECT
-- 		category,
-- 		product,
-- 		product_id,
-- 		gross_ror || ' %' AS rate_of_return 
-- 	FROM products_ranked 
-- 	WHERE ror_rnk_hi = 1
-- 	),
-- ror_lo_cte AS (
-- 	SELECT
-- 		category,
-- 		product,
-- 		product_id,
-- 		gross_ror || ' %' AS rate_of_return 
-- 	FROM products_ranked 
-- 	WHERE ror_rnk_lo = 1
-- 	)

-- SELECT
-- 	rh.category,
-- 	rh.product_id,
-- 	rh.product AS product_ror_hi,
-- 	rh.rate_of_return,
-- 	rl.product_id,
-- 	rl.product AS product_ror_lo,
-- 	rl.rate_of_return

-- FROM ror_hi_cte rh
-- JOIN ror_lo_cte rl
-- 	ON rl.category = rh.category


------------------------------------------


---- * most profitable product at each warehouse

-- WITH profit_cte AS (
-- 	SELECT
-- 		w.name AS warehouse,
-- 		c.name AS category,
-- 		p.id AS product_id,
-- 		p.name AS product,
-- 		p.list_price - p.std_cost AS profit,
-- 		ROUND(((p.list_price - p.std_cost) / p.std_cost) * 100, 1) AS ror ,
-- 		RANK() OVER(PARTITION BY w.name ORDER BY (p.list_price - p.std_cost) / p.std_cost DESC)
-- 	FROM product p
-- 	JOIN inventory i
-- 		ON i.product_id = p.id
-- 	JOIN category c
-- 		ON c.id = p.category_id
-- 	JOIN warehouse w
-- 		ON w.id = i.warehouse_id
-- 	GROUP BY 
-- 		w.name,
-- 		c.name,
-- 		p.name,
-- 		p.id,
-- 		p.list_price,
-- 		p.std_cost
-- 	ORDER BY 
-- 		warehouse,
-- 		(p.list_price - p.std_cost) / p.std_cost DESC
-- 	)

-- SELECT
-- 	warehouse,
-- 	category,
-- 	product,
-- 	TO_CHAR(profit, 'L999,999,999D99') AS profit_per_unit,
-- 	ror || ' %' AS rate_of_return
-- FROM profit_cte
-- WHERE rank = 1
-- ORDER BY ror DESC




---- * distinct products in each category, average (list price/profit) per item
-- SELECT
-- 	c.name AS product_category,
-- 	TO_CHAR(SUM(i.quantity), '999,999') AS total_qty,
-- 	TO_CHAR(ROUND(AVG(p.std_cost), 2), 'L999,999D99') AS avg_item_cost, 
-- 	TO_CHAR(ROUND(AVG(p.list_price - p.std_cost), 2), 'L999,999D99') AS avg_profit_per_item,
-- 	ROUND(AVG((p.list_price - p.std_cost) / p.std_cost)*100,1) || ' %' AS avg_rate_of_return
-- FROM product p
-- JOIN category c
-- 	ON c.id = p.category_id
-- JOIN inventory i
-- 	ON i.product_id = p.id
-- GROUP BY c.name
-- ORDER BY AVG(p.std_cost) DESC

