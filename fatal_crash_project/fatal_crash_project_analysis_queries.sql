

----:::::::::: ANALYSIS ::::::::::----

---- ACCIDENT RECORDS - TOTALS & AVERAGE PER DAY
-- SELECT 
-- 	COUNT(*) AS accident_total,
-- 	COUNT(*) / 365 AS avg_accidents_per_day,
-- 	SUM(fatalities) AS fatal_total,
-- 	SUM(fatalities) / 365 AS avg_fatalities_per_day
-- FROM accident_data_2019
-- ;

---- TOTAL FATALITIES BY STATE AND MONTH IN 2019
-- SELECT
-- 	state,
-- 	month,
-- 	SUM(fatalities) AS fatalities_total
-- FROM accident_data_2019
-- GROUP BY state, month
-- ORDER BY state, month
-- ;




---- FATALITIES PER MONTH (RANKED)
-- SELECT
-- 	TO_CHAR(TO_DATE(month::TEXT, 'MM'), 'MONTH') AS month,
-- 	SUM(fatalities) AS fatalities_total,
-- 	RANK() OVER(ORDER BY SUM(fatalities) DESC)
-- FROM accident_data_2019
-- GROUP BY month
-- ORDER BY rank
-- ;

---- MOST FATALITIES PER MONTH (TOP 3)
-- WITH month_cte AS (
-- 	SELECT
-- 		month, 
-- 		SUM(fatalities) AS fatalities_total,
-- 		RANK() OVER(ORDER BY SUM(fatalities) DESC)
-- 	FROM accident_data_2019
-- 	GROUP BY month
-- 	ORDER BY month
-- 	)
-- SELECT
-- 	rank,
-- 	TO_CHAR(TO_DATE(month::TEXT, 'MM'), 'MONTH') AS month,
-- 	fatalities_total
-- FROM month_cte
-- WHERE rank < 4
-- ORDER BY rank
-- ;


---- FATALITIES PER MONTH (PERCENT DIFFERENCE MOST VS LEAST)
-- WITH month_cte AS (
-- 	SELECT
-- 		month, 
-- 		SUM(fatalities) AS fatalities_total,
-- 		RANK() OVER(ORDER BY SUM(fatalities) DESC)
-- 	FROM accident_data_2019
-- 	GROUP BY month
-- 	ORDER BY month
-- 	)
-- SELECT
-- 	ROUND((MAX(fatalities_total) - 
-- 	 	MIN(fatalities_total))::decimal / 
-- 			MIN(fatalities_total) * 100, 1) AS percent_diff
-- FROM month_cte
-- ;




---- FATALITIES BY DAY OF WEEK
-- SELECT
-- 	day_of_week,
-- 	SUM(fatalities) AS fatalities_total
-- FROM accident_data_2019
-- GROUP BY day_of_week
-- ORDER BY fatalities_total DESC
-- ;

--------------------------------------
---- not used
--------------------------------------
---- 	(CASE
---- 	 	WHEN day_of_week ILIKE 'mon%'
---- 	 	THEN 1
---- 		WHEN day_of_week ILIKE 'tue%'
---- 		THEN 2
---- 	 	WHEN day_of_week ILIKE 'wed%'
---- 		THEN 3
---- 	 	WHEN day_of_week ILIKE 'thu%'
---- 		THEN 4
---- 	 	WHEN day_of_week ILIKE 'fri%'
---- 		THEN 5
---- 	 	WHEN day_of_week ILIKE 'sat%'
---- 		THEN 6
---- 	 	WHEN day_of_week ILIKE 'sun%'
---- 		THEN 7
---- 	END
---- 	) AS dow
-----------------------------------------
-----------------------------------------



---- FATALITIES BY HOUR (RANKED)
-- CREATE TEMP TABLE hours_ranked AS
-- SELECT
-- 	day_of_week,
-- 	EXTRACT('hour' FROM time) AS time,
-- 	SUM(fatalities) AS fatalities_total,
-- 	RANK() OVER(ORDER BY SUM(fatalities) DESC)
-- FROM accident_data_2019
-- WHERE time IS NOT NULL
-- GROUP BY 
-- 	day_of_week, 
-- 	EXTRACT('hour' FROM time) 
-- ;

-- SELECT *
-- FROM hours_ranked
-- LIMIT 25
-- ;

---- FATALITIES BY HOUR (TOP 10 - SATURDAY, SUNDAY)
-- SELECT 
-- 	day_of_week,
-- 	TO_CHAR(MAKE_TIME(time::int, 0, 0), 'HH:00:00 AM'),
-- 	fatalities_total
-- FROM hours_ranked
-- WHERE rank < 11 AND day_of_week IN ('SATURDAY', 'SUNDAY')
-- ORDER BY day_of_week, time
-- ;




---- RURAL URBAN FATALITIES
-- SELECT
--   rural_urban,
--   COUNT(*) AS accident_count,
--   SUM(fatalities) AS fatality_total
-- FROM accident_data_2019
-- WHERE rural_urban NOT ILIKE 'unknown'
-- GROUP BY rural_urban


---- TEN MOST FATAL HOURS OF THE WEEK FOR RURAL/URBAN AREAS
-- WITH cte AS (	
-- 	SELECT ----every hour of every day total fatalities ranked desc
-- 		rural_urban,
-- 		day_of_week,
-- 		TO_CHAR(time, 'HH:00:00 AM') AS time,
-- 		SUM(fatalities) AS fatalities_total,
-- 		RANK() OVER(PARTITION BY rural_urban ORDER BY SUM(fatalities) DESC)
-- 	FROM accident_data_2019
-- 	WHERE rural_urban NOT ILIKE 'unknown'
-- 		AND time IS NOT NULL
-- 	GROUP BY 
-- 		rural_urban, 
-- 		day_of_week, 
-- 		TO_CHAR(time, 'HH:00:00 AM')
-- 	)

-- SELECT *
-- FROM cte
-- WHERE rank <= 10
-- ORDER BY rural_urban, day_of_week, time






---- TOTAL FATALITIES BY LIGHT CONDITION
-- WITH lc_cte AS (
-- 	SELECT
-- 		light_condition,
-- 		SUM(fatalities) AS fatalities_total
-- 	FROM accident_data_2019
-- 	WHERE light_condition NOT ILIKE 'unknown'
-- 	GROUP BY light_condition
-- 	)
-- SELECT
-- 	light_condition,
-- 	fatalities_total,
-- 	ROUND((fatalities_total / 
-- 		   SUM(fatalities_total) OVER()) * 100, 1) || ' %' AS percent_total
-- FROM lc_cte





---- TOTAL FATALITIES - RURAL URBAN LIGHT CONDITION COMPARISON
-- WITH cte AS (
-- 	SELECT
-- 		rural_urban,
-- 		light_condition,
-- 		SUM(fatalities) AS fatalities_total
-- 	FROM accident_data_2019
-- 	WHERE light_condition NOT ILIKE 'unknown'
-- 		AND rural_urban NOT ILIKE 'unknown'
-- 	GROUP BY rural_urban, light_condition
-- 	)

-- SELECT
-- 	rural_urban, 
-- 	light_condition,
-- 	fatalities_total,
-- 	ROUND(fatalities_total /
-- 		  (SUM(fatalities_total) OVER(
-- 			  PARTITION BY rural_urban))*100, 1) || ' %'  AS percent_total
-- FROM cte
-- ORDER BY rural_urban, light_condition





------ TOTAL ACCIDENT FATALITIES PER STATE RANKED WITH POPULATION COMPARISON	
-- SELECT 
-- 	a.state,
-- 	RANK() OVER(ORDER BY SUM(a.fatalities) DESC) AS fatalities_rank,
-- 	SUM(a.fatalities) AS fatalities_total,
-- 	RANK() OVER(ORDER BY sp.population DESC) AS population_rank,
-- 	sp.population
-- FROM accident_data_2019 AS a
-- JOIN state_pop AS sp
-- 	ON a.state = sp.state
-- GROUP BY a.state, sp.population
-- ORDER BY fatalities_total DESC


-- SELECT 
-- 	a.state,
-- 	RANK() OVER(ORDER BY SUM(a.fatalities) DESC) AS fatalities_rank,
-- 	SUM(a.fatalities) AS fatalities_total,
-- 	RANK() OVER(ORDER BY sp.population DESC) AS population_rank,
-- 	sp.population,
-- 	RANK() OVER(ORDER BY sp.population DESC)
-- 		- RANK() OVER(ORDER BY SUM(a.fatalities) DESC) AS disparity
-- FROM accident_data_2019 AS a
-- JOIN state_pop AS sp
-- 	ON a.state = sp.state
-- GROUP BY a.state, sp.population
-- ORDER BY disparity DESC




-- ---- ACCIDENT FATALITIES PER 100,000 RESIDENTS
-- SELECT 
-- 	a.state,
-- 	ROUND((100000 / sp.population::decimal) * 
-- 		SUM(a.fatalities),1) AS fatalities_per_100k
-- FROM accident_data_2019 AS a
-- JOIN state_pop AS sp
-- 	ON a.state = sp.state
-- GROUP BY a.state, sp.population
-- ORDER BY fatalities_per_100k DESC


-- 	---- w/ PERCENT MORE THAN NEXT LOWEST
-- 	WITH cte AS (
-- 		SELECT 
-- 			a.state,
-- 			ROUND((100000 / sp.population::decimal) * 
-- 				SUM(a.fatalities),1) AS fatalities_per_100k
-- 		FROM accident_data_2019 AS a
-- 		JOIN state_pop AS sp
-- 			ON a.state = sp.state
-- 		GROUP BY a.state, sp.population
-- 		ORDER BY fatalities_per_100k DESC
-- 		)
-- 	SELECT
-- 		state,
-- 		fatalities_per_100k AS fp,
-- 		LAG(fatalities_per_100k, 1) OVER(ORDER BY fatalities_per_100k) AS rank_below,
-- 		ROUND(((fatalities_per_100k - LAG(fatalities_per_100k) OVER(ORDER BY fatalities_per_100k)) /
-- 			LAG(fatalities_per_100k, 1) OVER(ORDER BY fatalities_per_100k)) * 100,1) || ' %' AS percent_more
-- 	FROM cte
-- 	ORDER BY fp DESC















