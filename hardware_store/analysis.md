# Analysis

## 📋	Total product ***count*** and ***value***.
<br>

#### ℹ️ Company-wide
	
<details>
    <summary><strong>View Query</strong></summary><br>

```sql
SELECT	COUNT (DISTINCT i.product_id) AS unique_products,
	TO_CHAR(SUM(i.quantity), '999,999') AS total_product_count,
	TO_CHAR(SUM(i.quantity * p.std_cost), 'L999,999,999D99') AS total_cost,
	TO_CHAR(SUM(i.quantity * p.list_price), 'L999,999,999D99') AS total_list_value
FROM inventory i
JOIN product p
ON i.product_id = p.id
;
```
</details>

| unique_products | total_product_count | total_cost       | total_list_value |
|-----------------|---------------------|------------------|------------------|
| 208             | 119,512             | $  85,826,832.40 | $ 107,194,284.32 |

<br>

#### ℹ️ At each warehouse
	
<details>
	<summary><strong>View Query</strong></summary><br>

```sql
WITH wh_cte AS (
	SELECT	w.name AS warehouse,
		co.name AS country,
		TO_CHAR(SUM(i.quantity), '999,999,999') AS product_count,
		ROUND(SUM(i.quantity * p.std_cost)/1000000, 1) AS total_cost,
		ROUND(SUM(i.quantity * p.list_price)/1000000, 1) AS total_list_value
	FROM product p
	JOIN inventory i
		ON i.product_id = p.id
	JOIN warehouse w
		ON w.id = i.warehouse_id
	JOIN country co
		ON co.id = w.country_id
	GROUP BY 
		co.name,
		w.name
	ORDER BY 
		country,
		product_count DESC
	)

SELECT	warehouse,
	country,
	product_count,
	TO_CHAR(total_cost, 'L999D9') || ' m' AS total_cost,
	TO_CHAR(total_list_value, 'L999D9') || ' m' AS total_list_value,
	ROUND((total_list_value / SUM(total_list_value) OVER()) * 100, 1) || ' %' AS pct_gross_inv_value
FROM wh_cte
ORDER BY ROUND((total_cost / SUM(total_cost) OVER()) * 100, 1) DESC
;
```
</details>

| warehouse     | country                  | product_count | total_cost | total_list_value | pct_gross_inv_value |
|---------------|--------------------------|---------------|------------|------------------|---------------------|
| San Francisco | United States of America | 28,613        | $  18.7 m  | $  23.4 m        | 21.8 %              |
| Sydney        | Australia                | 20,457        | $  13.1 m  | $  16.3 m        | 15.2 %              |
| Seattle       | United States of America | 14,860        | $  11.3 m  | $  14.2 m        | 13.2 %              |
| Toronto       | Canada                   | 12,969        | $   8.9 m  | $  11.1 m        | 10.3 %              |
| New Jersey    | United States of America | 7,252         | $   8.3 m  | $  10.4 m        | 9.7 %               |
| Beijing       | China                    | 13,482        | $   8.2 m  | $  10.3 m        | 9.6 %               |
| Southlake     | United States of America | 5,483         | $   5.8 m  | $   7.3 m        | 6.8 %               |
| Mexico City   | Mexico                   | 9,039         | $   5.7 m  | $   7.1 m        | 6.6 %               |
| Bombay        | India                    | 7,357         | $   5.7 m  | $   7.2 m        | 6.7 %               |

<br><br>


 
## 📋	Total product ***count*** and ***value*** of each product category
 
#### ℹ️ **Company-wide**
 
<details>
	<summary><strong>View Query</strong></summary><br>

```sql
WITH cat_cte AS(	
	SELECT	c.name AS category,
		SUM(i.quantity) AS product_qty,
		ROUND(AVG(p.std_cost), 2) AS avg_cost,
		ROUND(SUM(i.quantity * p.std_cost)/1000000, 1) AS tot_cost_mil,
		ROUND(AVG(p.list_price), 2) AS avg_list,
		ROUND(SUM(i.quantity * p.list_price)/1000000, 1) AS tot_list_mil
	FROM product p
	JOIN category c
		ON p.category_id = c.id
	JOIN inventory i
		ON i.product_id = p.id
	GROUP BY c.name
	ORDER BY SUM(i.quantity * p.std_cost) DESC
	)

SELECT	category,
	TO_CHAR(product_qty, '999,999') AS product_qty,
	TO_CHAR(tot_cost_mil, 'L999D9') || ' m' AS total_cost,
	TO_CHAR(tot_list_mil, 'L999D9') || ' m' AS total_list_price,
	ROUND(((tot_list_mil - tot_cost_mil) / tot_cost_mil) * 100, 1) || ' %' AS gross_rate_of_return
FROM cat_cte
;
```
</details>
<br>

| category     | product_qty | total_cost | total_list_price | gross_rate_of_return |
|--------------|-------------|------------|------------------|----------------------|
| Video Card   | 38,996      | $  39.6 m  | $  50.0 m        | 26.3 %               |
| Storage      | 47,573      | $  21.6 m  | $  27.0 m        | 25.0 %               |
| CPU          | 19,596      | $  19.7 m  | $  24.0 m        | 21.8 %               |
| Mother Board | 13,347      | $   5.0 m  | $   6.2 m        | 24.0 %               |

<br>


#### ℹ️ **At each warehouse**
	
<details>
	<summary><strong>View Query</strong></summary><br>
	
```sql
WITH wh_cte AS (	
SELECT	w.name AS warehouse,
	co.name AS country,
	cat.name AS category,
	SUM(i.quantity) AS qty,
	ROUND(SUM(i.quantity * p.std_cost),0) AS tot_cost
FROM product p
JOIN category cat
	ON p.category_id = cat.id
JOIN inventory i
	ON i.product_id = p.id
JOIN warehouse w
	ON w.id = i.warehouse_id
JOIN country co
	ON co.id = w.country_id
GROUP BY 
	cat.name,
	co.name,
	w.name
ORDER BY 
	warehouse,
	country,
	category
)

SELECT	warehouse,
	country,
	category,
	TO_CHAR(qty, '999,999') AS qty,
	TO_CHAR(tot_cost, 'L999,999,999D') AS total_cost,
	ROUND((tot_cost / SUM(tot_cost) OVER(PARTITION BY warehouse)) * 100, 1) || ' %' AS pct_gross_wh_cost
FROM wh_cte
;
```
</details>
<br>

| warehouse     | country                  | category     | qty    | total_cost    | pct_gross_wh_cost |
|---------------|--------------------------|--------------|--------|---------------|-------------------|
| Beijing       | China                    | CPU          | 2,472  | $   2,422,261 | 29.5 %            |
| Beijing       | China                    | Mother Board | 1,779  | $     733,699 | 8.9 %             |
| Beijing       | China                    | Storage      | 6,543  | $   2,519,738 | 30.6 %            |
| Beijing       | China                    | Video Card   | 2,688  | $   2,548,010 | 31.0 %            |
| Bombay        | India                    | CPU          | 1,925  | $   1,881,552 | 32.8 %            |
| Bombay        | India                    | Mother Board | 1,178  | $     544,663 | 9.5 %             |
| Bombay        | India                    | Storage      | 2,025  | $   1,315,233 | 22.9 %            |
| Bombay        | India                    | Video Card   | 2,229  | $   1,999,783 | 34.8 %            |
| Mexico City   | Mexico                   | CPU          | 892    | $   1,312,971 | 23.1 %            |
| Mexico City   | Mexico                   | Mother Board | 544    | $     129,429 | 2.3 %             |
| Mexico City   | Mexico                   | Storage      | 4,418  | $   1,120,402 | 19.7 %            |
| Mexico City   | Mexico                   | Video Card   | 3,185  | $   3,129,447 | 55.0 %            |
| New Jersey    | United States of America | CPU          | 1,581  | $   2,323,185 | 28.0 %            |
| New Jersey    | United States of America | Video Card   | 5,671  | $   5,983,450 | 72.0 %            |
| San Francisco | United States of America | CPU          | 4,508  | $   3,622,850 | 19.3 %            |
| San Francisco | United States of America | Mother Board | 3,459  | $   1,227,092 | 6.5 %             |
| San Francisco | United States of America | Storage      | 14,167 | $   6,833,802 | 36.5 %            |
| San Francisco | United States of America | Video Card   | 6,479  | $   7,059,948 | 37.7 %            |
| Seattle       | United States of America | CPU          | 3,284  | $   2,387,531 | 21.1 %            |
| Seattle       | United States of America | Mother Board | 1,734  | $     857,835 | 7.6 %             |
| Seattle       | United States of America | Storage      | 5,084  | $   3,162,021 | 27.9 %            |
| Seattle       | United States of America | Video Card   | 4,758  | $   4,931,195 | 43.5 %            |
| Southlake     | United States of America | CPU          | 258    | $     114,019 | 2.0 %             |
| Southlake     | United States of America | Video Card   | 5,225  | $   5,727,491 | 98.0 %            |
| Sydney        | Australia                | CPU          | 3,381  | $   3,650,781 | 27.9 %            |
| Sydney        | Australia                | Mother Board | 3,707  | $   1,288,180 | 9.9 %             |
| Sydney        | Australia                | Storage      | 9,322  | $   4,383,128 | 33.5 %            |
| Sydney        | Australia                | Video Card   | 4,047  | $   3,743,825 | 28.7 %            |
| Toronto       | Canada                   | CPU          | 1,295  | $   1,936,212 | 21.8 %            |
| Toronto       | Canada                   | Mother Board | 946    | $     223,776 | 2.5 %             |
| Toronto       | Canada                   | Storage      | 6,014  | $   2,224,148 | 25.1 %            |
| Toronto       | Canada                   | Video Card   | 4,714  | $   4,489,177 | 50.6 %            |

<br><br> 


## 📋	Highest priced company products

#### ℹ️ Top 5

<details>
	<summary><strong>View Query</strong></summary><br>
	
```sql
SELECT	c.name,
	p.id AS product_id,
	p.name AS product,
	TO_CHAR(p.list_price, 'L999,999,999D99') AS list_price
FROM product p
JOIN inventory i
	ON i.product_id = p.id
JOIN category c
	ON c.id = p.category_id
GROUP BY
	c.name,
	p.id,
	p.name
ORDER BY p.list_price DESC
LIMIT 5
;
```
</details>
<br>

| name       | product_id | product                          | list_price       |
|------------|------------|----------------------------------|-----------------:|
| Storage    | 50         | Intel SSDPECME040T401            | $       8,867.99 |
| Video Card | 133        | PNY VCQP6000-PB                  | $       5,499.99 |
| CPU        | 228        | Intel Xeon E5-2699 V3 (OEM/Tray) | $       3,410.46 |
| Video Card | 207        | PNY VCQM6000-PB                  | $       3,254.99 |
| Video Card | 110        | ATI FirePro W9000                | $       3,192.97 |

<br><br>


## 📋 	Product with ***highest*** gross value

#### ℹ️ **Company-wide (Top 10)**

<details>
	<summary><strong>View Query</strong></summary><br>
	
```sql
SELECT	c.name,
	p.id AS product_id,
	p.name AS product,
	SUM(i.quantity) AS gross_product_qty,
	TO_CHAR(ROUND(SUM(i.quantity * p.list_price),0), 'L999,999,999') AS gross_inv_val
FROM product p
JOIN inventory i
	ON i.product_id = p.id
JOIN category c
	ON c.id = p.category_id
GROUP BY
	c.name,
	p.id,
	p.name
ORDER BY gross_inv_val DESC
LIMIT 10
;
```
</details>
<br>

| name       | product_id | product                          | gross_product_qty | gross_inv_val |
|------------|------------|----------------------------------|-------------------|-----------------|
| Video Card | 207 | PNY VCQM6000-PB                         | 1413 | $   4,599,301 |
| Video Card | 133 | PNY VCQP6000-PB                         | 785  | $   4,317,492 |
| Storage    | 50  | Intel SSDPECME040T401                   | 360  | $   3,192,476 |
| Video Card | 245 | ATI FirePro S9050                       | 1557 | $   2,645,343 |
| Video Card | 123 | ATI FirePro S9150                       | 769  | $   2,443,451 |
| Video Card | 142 | AMD FirePro W9100                       | 795  | $   2,384,118 |
| Video Card | 110 | ATI FirePro W9000                       | 725  | $   2,314,903 |
| Video Card | 105 | EVGA 12G-P4-3992-KR                     | 715  | $   2,001,993 |
| Video Card | 281 | Asus ROG-POSEIDON-GTX1080TI-P11G-GAMING | 1827 | $   1,580,318 |
| Video Card | 4   | AMD 100-505989                          | 576  | $   1,555,194 |


<br>

#### ℹ️ **At each warehouse**

<details>
	<summary><strong>View Query</strong></summary><br>
	
```sql
WITH gross_value_cte AS (
	SELECT	w.name AS warehouse,
		c.name AS category,
		p.id AS product_id,
		p.name AS product,
		SUM(i.quantity) AS gross_product_qty,
		TO_CHAR(ROUND(SUM(i.quantity * p.list_price),0), 'L999,999,999') AS gross_product_value,
		RANK() OVER(PARTITION BY w.name ORDER BY SUM(i.quantity * p.list_price) DESC)
	FROM product p
	JOIN inventory i
		ON i.product_id = p.id
	JOIN category c
		ON c.id = p.category_id
	JOIN warehouse w
		ON i.warehouse_id = w.id
	GROUP BY 
		w.name,
		c.name,
		p.id,
		p.name
	ORDER BY
		w.name,
		SUM(i.quantity * p.list_price) DESC
	)

SELECT	warehouse,
	category,
	product,
	gross_product_qty,
	gross_product_value
FROM gross_value_cte
WHERE rank = 1
;
```
</details>
<br>

| warehouse     | category   | product               | gross_product_qty | gross_product_value |
|---------------|------------|-----------------------|-------------------|---------------------|
| Beijing       | Video Card | PNY VCQM6000-PB       | 121               | $     393,854       |
| Bombay        | Video Card | PNY VCQM6000-PB       | 109               | $     354,794       |
| Mexico City   | Storage    | Intel SSDPECME040T401 | 58                | $     514,343       |
| New Jersey    | Video Card | PNY VCQP6000-PB       | 136               | $     747,999       |
| San Francisco | Storage    | Intel SSDPECME040T401 | 117               | $   1,037,555       |
| Seattle       | Video Card | PNY VCQP6000-PB       | 104               | $     571,999       |
| Southlake     | Video Card | PNY VCQP6000-PB       | 133               | $     731,499       |
| Sydney        | Storage    | Intel SSDPECME040T401 | 84                | $     744,911       |
| Toronto       | Storage    | Intel SSDPECME040T401 | 69                | $     611,891       |

<br>


#### ℹ️ **In each category**

<details>
	<summary><strong>View Query</strong></summary><br>
	
```sql
WITH gross_value_cte AS (
	SELECT	c.name AS category,
		p.id AS product_id,
		p.name AS product,
		SUM(i.quantity) AS gross_product_qty,
		TO_CHAR(ROUND(SUM(i.quantity * p.list_price),0), 'L999,999,999') AS gross_product_value,
		RANK() OVER(PARTITION BY c.name ORDER BY SUM(i.quantity * p.list_price) DESC)
	FROM product p
	JOIN inventory i
		ON i.product_id = p.id
	JOIN category c
		ON c.id = p.category_id
	GROUP BY 
		c.name,
		p.id,
		p.name
	ORDER BY SUM(i.quantity * p.list_price) DESC
	)

SELECT	category,
	product,
	gross_product_qty,
	gross_product_value
FROM gross_value_cte
WHERE rank = 1
;
```
</details>
<br>

| category     | product                          | gross_product_qty | gross_product_value |
|--------------|----------------------------------|-------------------|---------------------|
| Video Card   | PNY VCQM6000-PB                  | 1413              | $   4,599,301       |
| Storage      | Intel SSDPECME040T401            | 360               | $   3,192,476       |
| CPU          | Intel Xeon E5-2699 V4 (OEM/Tray) | 846               | $   1,485,576       |
| Mother Board | Supermicro X10SDV-8C-TLN4F       | 825               | $     782,917       |


<br><br>


## 📋	**Gross profit** and **rate of return**

<details>
	<summary><strong>View DDL Statement</strong></summary><br>

```sql
CREATE TEMP TABLE products_ranked AS (
	SELECT	c.name AS category,
		p.id AS product_id,
		p.name AS product,
		p.list_price - p.std_cost AS gross_profit,
		RANK() OVER(PARTITION BY c.name ORDER BY p.list_price - p.std_cost DESC) AS profit_rank_hi,
		RANK() OVER(PARTITION BY c.name ORDER BY p.list_price - p.std_cost) AS profit_rank_lo,
		ROUND(((p.list_price - p.std_cost) / p.std_cost) * 100, 2) AS gross_ror,
		RANK() OVER(PARTITION BY c.name ORDER BY (p.list_price - p.std_cost) / p.std_cost DESC) AS ror_rnk_hi,
		RANK() OVER(PARTITION BY c.name ORDER BY (p.list_price - p.std_cost) / p.std_cost) AS ror_rnk_lo

	FROM product p
	JOIN inventory i
		ON i.product_id = p.id
	JOIN category c
		ON c.id = p.category_id
	GROUP BY 
		c.name,
		p.name,
		p.id,
		p.list_price,
		p.std_cost
	ORDER BY 
		category,
		p.list_price - p.std_cost DESC
	);
```
</details>
<br>

<details>
	<summary><strong>View Query</strong></summary><br>

```sql
SELECT *
FROM products_ranked
LIMIT 5
;
```
</details>
<br>

| category | product_id | product                          | gross_profit | profit_rank_hi | profit_rank_lo | gross_ror | ror_rnk_hi | ror_rnk_lo |
|----------|------------|----------------------------------|--------------|----------------|----------------|-----------|------------|------------|
| CPU      | 228        | Intel Xeon E5-2699 V3 (OEM/Tray) | 542.95       | 1              | 41             | 18.93     | 27         | 15         |
| CPU      | 46         | Intel Xeon E5-2695 V3 (OEM/Tray) | 506.82       | 2              | 40             | 26.33     | 13         | 29         |
| CPU      | 159        | Intel Xeon E5-2690 V4            | 495.23       | 3              | 39             | 33.03     | 8          | 34         |
| CPU      | 243        | Intel Xeon E5-2643 V4 (OEM/Tray) | 483.27       | 4              | 38             | 39.43     | 5          | 37         |
| CPU      | 166        | Intel Xeon E5-2680 V3 (OEM/Tray) | 472.00       | 5              | 37             | 40.45     | 2          | 40         |

<br><br>


#### ℹ️ **Highest & lowest *gross profit* by category**
	
<details>
	<summary><strong>View Query</strong></summary><br>
	
```sql
WITH profit_hi_cte AS (
	SELECT	category,
		product,
		product_id,
		TO_CHAR(gross_profit, 'L999,999,999D99') AS profit_per_unit 
	FROM products_ranked 
	WHERE profit_rank_hi = 1
	ORDER BY profit_per_unit DESC
	),
profit_lo_cte AS (
	SELECT	category,
		product,
		product_id,
		TO_CHAR(gross_profit, 'L999,999,999D99') AS profit_per_unit 
	FROM products_ranked 
	WHERE profit_rank_lo = 1
	ORDER BY profit_per_unit
	)

SELECT	ph.category,
	ph.product AS product_gross_profit_highest,
	ph.profit_per_unit,
	pl.product AS product_gross_profit_lowest,
	pl.profit_per_unit
FROM profit_hi_cte ph
JOIN profit_lo_cte pl
	ON ph.category = pl.category
;
```
</details>
<br>

| category     | product_gross_profit_highest     | profit_per_unit  | product_gross_profit_lowest | profit_per_unit-2 |
|--------------|----------------------------------|------------------|-----------------------------|-------------------|
| Storage      | Intel SSDPECME040T401            | $       1,744.33 | Western Digital WD2500AAJS  | $           1.76  |
| Video Card   | PNY VCQP6000-PB                  | $       1,441.00 | MSI GTX 1080 TI AERO 11G OC | $          82.54  |
| CPU          | Intel Xeon E5-2699 V3 (OEM/Tray) | $         542.95 | Intel Xeon E5-2640 V2       | $          63.76  |
| Mother Board | Supermicro X10SDV-8C-TLN4F       | $         284.70 | Asus VANGUARD B85           | $          28.90  |

<br><br>

 
#### ℹ️ **Highest / lowest *rate of return* by category** 

<details>
	<summary><strong>View Query</strong></summary><br>
	
```sql
WITH ror_hi_cte AS (
	SELECT	category,
		product,
		product_id,
		gross_ror || ' %' AS rate_of_return 
	FROM products_ranked 
	WHERE ror_rnk_hi = 1
	),
ror_lo_cte AS (
	SELECT	category,
		product,
		product_id,
		gross_ror || ' %' AS rate_of_return 
	FROM products_ranked 
	WHERE ror_rnk_lo = 1
	)

SELECT	rh.category,
	rh.product_id,
	rh.product AS product_ror_hi,
	rh.rate_of_return,
	rl.product_id,
	rl.product AS product_ror_lo,
	rl.rate_of_return
FROM ror_hi_cte rh
JOIN ror_lo_cte rl
	ON rl.category = rh.category
;
```
</details>
<br>

| category     | product_id | product_ror_hi             | rate_of_return | product_id-2 | product_ror_lo              | rate_of_return-2 |
|--------------|------------|----------------------------|----------------|--------------|-----------------------------|------------------|
| CPU          | 80         | Intel Xeon E5-1650 V3      | 41.30 %        | 163          | Intel Xeon E5-2683 V4       | 11.31 %          |
| Mother Board | 190        | Supermicro X10SDV-8C-TLN4F | 42.86 %        | 145          | Asus VANGUARD B85           | 11.20 %          |
| Storage      | 30         | G.Skill Ripjaws V Series   | 42.57 %        | 14           | G.Skill Ripjaws V Series    | 11.26 %          |
| Video Card   | 238        | EVGA 06G-P4-4998-KR        | 42.37 %        | 174          | MSI GTX 1080 TI AERO 11G OC | 11.53 %          |

<br><br>


## 📋	Most profitable product at each warehouse


<details>
	<summary><strong>View Query</strong></summary><br>
	
```sql
WITH profit_cte AS (
SELECT	w.name AS warehouse,
	c.name AS category,
	p.id AS product_id,
	p.name AS product,
	p.list_price - p.std_cost AS profit,
	ROUND(((p.list_price - p.std_cost) / p.std_cost) * 100, 1) AS ror ,
	RANK() OVER(PARTITION BY w.name ORDER BY (p.list_price - p.std_cost) / p.std_cost DESC)
FROM product p
JOIN inventory i
	ON i.product_id = p.id
JOIN category c
	ON c.id = p.category_id
JOIN warehouse w
	ON w.id = i.warehouse_id
GROUP BY 
	w.name,
	c.name,
	p.name,
	p.id,
	p.list_price,
	p.std_cost
ORDER BY 
	warehouse,
	(p.list_price - p.std_cost) / p.std_cost DESC
	)

SELECT	warehouse,
	category,
	product,
	TO_CHAR(profit, 'L999,999,999D99') AS profit_per_unit,
	ror || ' %' AS rate_of_return
FROM profit_cte
WHERE rank = 1
ORDER BY ror DESC
;
```
</details>
<br>

| warehouse     | category     | product                    | profit_per_unit  | rate_of_return |
|---------------|--------------|----------------------------|------------------|----------------|
| Beijing       | Mother Board | Supermicro X10SDV-8C-TLN4F | $         284.70 | 42.9 %         |
| Bombay        | Mother Board | Supermicro X10SDV-8C-TLN4F | $         284.70 | 42.9 %         |
| San Francisco | Mother Board | Supermicro X10SDV-8C-TLN4F | $         284.70 | 42.9 %         |
| Seattle       | Mother Board | Supermicro X10SDV-8C-TLN4F | $         284.70 | 42.9 %         |
| Sydney        | Mother Board | Supermicro X10SDV-8C-TLN4F | $         284.70 | 42.9 %         |
| Toronto       | Storage      | Corsair Vengeance LPX      | $         387.01 | 42.4 %         |
| Mexico City   | Storage      | Corsair Vengeance LPX      | $         387.01 | 42.4 %         |
| New Jersey    | Video Card   | Zotac ZT-P10810C-10P       | $         224.96 | 42.0 %         |
| Southlake     | Video Card   | Zotac ZT-P10810C-10P       | $         224.96 | 42.0 %         |

<br>
<br>


## 📋	Average *gross profit* and *rate of return* by category

<details>
	<summary><strong>View Query</strong></summary><br>

```sql
SELECT	c.name AS product_category,
	TO_CHAR(SUM(i.quantity), '999,999') AS total_qty,
	TO_CHAR(ROUND(AVG(p.std_cost), 2), 'L999,999D99') AS avg_item_cost, 
	TO_CHAR(ROUND(AVG(p.list_price - p.std_cost), 2), 'L999,999D99') AS avg_profit_per_item,
	ROUND(AVG((p.list_price - p.std_cost) / p.std_cost)*100,1) || ' %' AS avg_rate_of_return
FROM product p
JOIN category c
	ON c.id = p.category_id
JOIN inventory i
	ON i.product_id = p.id
GROUP BY c.name
ORDER BY AVG(p.std_cost) DESC
;
```
</details>
<br>

| product_category | total_qty | avg_item_cost | avg_profit_per_item | avg_rate_of_return |
|------------------|-----------|---------------|---------------------|--------------------|
| Video Card       | 38,996    | $   1,145.19  | $     292.72        | 26.1 %             |
| CPU              | 19,596    | $   1,042.90  | $     228.37        | 23.6 %             |
| Storage          | 47,573    | $     490.75  | $     119.97        | 25.7 %             |
| Mother Board     | 13,347    | $     329.55  | $      80.49        | 24.7 %             |

<br><br>
