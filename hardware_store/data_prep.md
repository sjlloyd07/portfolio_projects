# Preparation 
The computer hardware store inventory dataset is stored in a `.csv` file that was downloaded to local storage. Microsoft Excel was utilized for initial data inspection. PostgreSQL was utilized for further cleaning, manipulation, and analysis.

[kaggle dataset](https://www.kaggle.com/datasets/ivanchvez/hardwarestore?select=hardwareStore.csv)

The dataset consists of 22 columns. 
<!-- column names -->
| CATEGORY_ID | CATEGORY_NAME | PRODUCT_ID | PRODUCT_NAME | DESCRIPTION | DESCRIPTION - Detail 1 | DESCRIPTION - Detail 2 | DESCRIPTION - Detail 3 | DESCRIPTION - Detail 4 | STANDARD_COST | LIST_PRICE | COUNTRY_ID | REGION_ID | LOCATION_ID | WAREHOUSE_ID | QUANTITY | WAREHOUSE_NAME | ADDRESS | POSTAL_CODE | CITY | STATE | COUNTRY_NAME |
|-------------|---------------|------------|--------------|-------------|------------------------|------------------------|------------------------|------------------------|---------------|------------|------------|-----------|-------------|--------------|----------|----------------|---------|-------------|------|-------|--------------|

<br><br>

<!-- uplaod dataset to new postgres database for cleaning, normalization, and analysis -->

A postgres database was created on a local server with a `CREATE DATABASE` statement in order to store the inventory analysis project.

Using the `.csv` column names, table `inventory_raw` was created to store the raw dataset.


<details>
	<summary><strong>View <code>CREATE TABLE</code> statement</strong></summary>

```sql
CREATE TABLE inventory_raw (
	CATEGORY_ID int,
	CATEGORY_NAME text,
	PRODUCT_ID int,
	PRODUCT_NAME text,
	DESCRIPTION text,
	DESCRIPTION_1 text,
	DESCRIPTION_2 text,
	DESCRIPTION_3 text,
	DESCRIPTION_4 text,
	STANDARD_COST decimal,
	LIST_PRICE decimal,
	COUNTRY_ID text,
	REGION_ID int,
	LOCATION_ID int,
	WAREHOUSE_ID int,
	QUANTITY int,
	WAREHOUSE_NAME text,
	ADDRESS text,
	POSTAL_CODE text,
	CITY text,
	STATE text,
	COUNTRY_NAME text
)
```
</details>
<br><br>

The dataset was uploaded to `inventory_raw` with a psql `/copy` statement.

`\copy inventory_raw FROM 'C:\Users\steve\portfolio_projects\hardware_store\hardwareStore.csv' DELIMITER ',' CSV HEADER;`

<details>
	<summary><strong>View Results Summary</strong></summary>
	
```sql
SELECT *
FROM inventory_raw
LIMIT 5
```

| category_id | category_name | product_id | product_name                     | description                   | description_1 | description_2 | description_3 | description_4 | standard_cost | list_price | country_id | region_id | location_id | warehouse_id | quantity | warehouse_name    | address               | postal_code | city                | state           | country_name             |
|-------------|---------------|------------|----------------------------------|-------------------------------|---------------|---------------|---------------|---------------|---------------|------------|------------|-----------|-------------|--------------|----------|-------------------|-----------------------|-------------|---------------------|-----------------|--------------------------|
| 1           | CPU           | 8          | Intel Xeon E5-1650 V4            | Speed:3.6GHz/Cores:6/TDP:140W | Speed:3.6GHz  | Cores:6       | TDP:140W      | 0             | 535.47        | 601.99     | AU         | 3         | 13          | 6            | 30       | Sydney            | 12-98 Victoria Street | 2901        | Sydney              | New South Wales | Australia                |
| 1           | CPU           | 124        | Intel Xeon E5-1650 V4 (OEM/Tray) | Speed:3.6GHz/Cores:6/TDP:140W | Speed:3.6GHz  | Cores:6       | TDP:140W      | 0             | 453.14        | 594.99     | AU         | 3         | 13          | 6            | 59       | Sydney            | 12-98 Victoria Street | 2901        | Sydney              | New South Wales | Australia                |
| 1           | CPU           | 8          | Intel Xeon E5-1650 V4            | Speed:3.6GHz/Cores:6/TDP:140W | Speed:3.6GHz  | Cores:6       | TDP:140W      | 0             | 535.47        | 601.99     | US         | 2         | 6           | 2            | 97       | San Francisco     | 2011 Interiors Blvd   | 99236       | South San Francisco | California      | United States of America |
| 1           | CPU           | 8          | Intel Xeon E5-1650 V4            | Speed:3.6GHz/Cores:6/TDP:140W | Speed:3.6GHz  | Cores:6       | TDP:140W      | 0             | 535.47        | 601.99     | US         | 2         | 8           | 4            | 67       | SeattleWashington | 2004 Charade Rd       | 98199       | Seattle             | Washington      | United States of America |
| 1           | CPU           | 72         | Intel Xeon E5-2630 V3 (OEM/Tray) | Speed:2.4GHz/Cores:8/TDP:85W  | Speed:2.4GHz  | Cores:8       | TDP:85W       | 0             | 421.9         | 589.99     | AU         | 3         | 13          | 6            | 35       | Sydney            | 12-98 Victoria Street | 2901        | Sydney              | New South Wales | Australia                |

</details>
<br><br>

The `inventory_raw` table was checked for duplicate rows using the `ROW_NUMBER()` window function.

```sql
SELECT ROW_NUMBER() OVER(PARTITION BY product_id, warehouse_id, quantity ORDER BY warehouse_id) as rn, *	
FROM inventory_raw
ORDER BY rn DESC
```

<details>
	<summary><strong>View Results</strong></summary>

</details>

**No duplicates were found.**

<br>

<!-- start normalization process of new database -->
At this point, the raw dataset was ready to undertake normalization in order to maintain integrity and avoid redundancy.

<br><br>

## Normalization
<!-- make ERD -->
### Entity Relationship Diagram
An entity relationship diagram (ERD) was constructed to represent the table relationships.

<br>

![computer_hardware_ERD](/hardware_store/images/computerHardware_erd.png)

<br>

<!-- drop location_id - redundant data with warehouse_id -->
* Column `location_id` is redundant to column `warehouse_id` in this analysis.  Column `location_id` data was dropped from the dataset.

<br>

### Database
<!-- create new database tables -->
Tables `category`, `product`, `region`, `country`, `warehouse`, and `inventory` were created.

<details>
	<summary><strong>View <code>CREATE TABLE</code> statements.</strong></summary><br>
	
```sql
CREATE TABLE IF NOT EXISTS category (
	id INT CONSTRAINT pk_cat PRIMARY KEY,
	name TEXT NOT NULL
	);

CREATE TABLE IF NOT EXISTS product (
	id INT CONSTRAINT pk_product PRIMARY KEY,
	name TEXT NOT NULL,
	description TEXT NOT NULL,
	std_cost DECIMAL NOT NULL,
	list_price DECIMAL NOT NULL,
	category_id INT NOT NULL,
	CONSTRAINT fk_product_category FOREIGN KEY(category_id) 
		REFERENCES category(id) ON DELETE CASCADE
	);

CREATE TABLE IF NOT EXISTS region (
	id INT CONSTRAINT pk_region PRIMARY KEY,
	hemisphere TEXT NOT NULL
	);

CREATE TABLE IF NOT EXISTS country (
	id TEXT CONSTRAINT pk_country PRIMARY KEY,
	name TEXT NOT NULL,
	region_id INT NOT NULL,
	CONSTRAINT pk_country_region FOREIGN KEY (region_id)
		REFERENCES region(id) ON DELETE CASCADE
	);

CREATE TABLE IF NOT EXISTS warehouse (
	id INT CONSTRAINT pk_warehouse PRIMARY KEY,
	name TEXT NOT NULL,
	address TEXT NOT NULL,
	postal_code TEXT NOT NULL,
	city TEXT NOT NULL,
	state TEXT NOT NULL,
	country_id TEXT NOT NULL,
	CONSTRAINT fk_warehouse_country FOREIGN KEY (country_id)
		REFERENCES country(id) ON DELETE CASCADE
	);

CREATE TABLE IF NOT EXISTS inventory (
	product_id INT NOT NULL,
	warehouse_id INT NOT NULL,
	quantity INT NOT NULL,
	CONSTRAINT pk_inv PRIMARY KEY (product_id, warehouse_id),
	CONSTRAINT fk_inv_product FOREIGN KEY (product_id)
		REFERENCES product(id) ON DELETE CASCADE,
	CONSTRAINT fk_inv_wh FOREIGN KEY (warehouse_id)
		REFERENCES warehouse(id) ON DELETE CASCADE
	);
```

</details>

<br><br>

Data was extracted from `inventory_raw` table into newly created tables.


```sql
INSERT INTO category
	SELECT DISTINCT category_id, category_name
	FROM inventory_raw
	ORDER BY category_id
	;
```

<details>
	<summary><strong>View Table</strong></summary><br>
	
```sql
SELECT * 
FROM category
;
```
	
	<insert table>

</details>
<br>

```sql
INSERT INTO product(id, name, description, std_cost, list_price, category_id)
	SELECT DISTINCT product_id, product_name, description, standard_cost, list_price, category_id
	FROM inventory_raw
	ORDER BY product_id
	;
```

<details>
	<summary><strong>View Table</strong></summary><br>
	
```sql
SELECT * 
FROM product 
LIMIT 5;
```
	
	<insert table>

</details>
<br>

**ISSUE:** region id has no definition for reference

**SOLUTION:** further investigation of the dataset reveals that this variable is likely hemisphere and data analysis will proceed as such

```sql
INSERT INTO region
	SELECT 
		DISTINCT region_id,
		(CASE
			WHEN region_id = 2
			THEN 'WESTERN'
		ELSE
			'EASTERN'
		END) AS hemisphere
	FROM inventory_raw
	ORDER BY region_id
;
```

<details>
	<summary><strong>View Table</strong></summary><br>
	
```sql
SELECT * 
FROM region 
;
```

	<insert table>

</details>
<br>


```sql
INSERT INTO country
	SELECT DISTINCT country_id, country_name, region_id
	FROM inventory_raw
	ORDER BY country_id
;
```

<details>
	<summary><strong>View Table</strong></summary><br>
	
```sql
SELECT * 
FROM country 
;
```
	
	<insert table>

</details>
<br>


```sql
INSERT INTO warehouse
	SELECT 
		DISTINCT warehouse_id, 
		warehouse_name, address, postal_code, 
		city, state, country_id
	FROM inventory_raw
	ORDER BY warehouse_id
;
```

<details>
	<summary><strong>View Table</strong></summary><br>
	
```sql
SELECT * 
FROM warehouse 
;
```
	
	<insert table>

</details>
<br>



```sql
INSERT INTO inventory
	SELECT DISTINCT product_id, warehouse_id, quantity
	FROM inventory_raw
	ORDER BY product_id, warehouse_id
;
```

<details>
	<summary><strong>View Table</strong></summary><br>
	
```sql
SELECT * 
FROM inventory 
LIMIT 5;
```
	<insert table>

</details>
<br>



## Cleaning

**TABLE: warehouse*

**ISSUE:** multiple `name` values contain warehouse name and state

**ACTION:** remove state where exists w/ `SUBSTRING()`

```sql 
UPDATE warehouse
SET name = 
	(CASE
		WHEN STRPOS(name, ',') > 0
	 	THEN SUBSTRING(name, 0, STRPOS(name, ','))
	 ELSE name
	 END)
;
```

<br>

**ISSUE:** `state` column - Mexican state name has character encoding error

**ACTION:** fix Mexican state character encoding with `REPLACE()`

<br>

```sql
UPDATE warehouse
SET state = REPLACE(state, 'Ã³', 'ó' )
WHERE country_id = 'MX'
;
```

<br>

<details>
	<summary><strong>View Table</strong></summary><br>
	
```sql
SELECT * 
FROM warehouse 
;
```
	<insert table>

</details>
<br><br>



**TABLE: product**

**ISSUE:** confirm product ids are unique to name-description pairs by checking for duplicate name-description pairs

**ACTION:** check for duplicates using `ROW_NUMBER()`

* 1: partition name-description pairs with row_number() function, sort duplicates to top of list

	```sql
	SELECT				
	 id,
	 name,
	 description,
	 ROW_NUMBER() OVER(PARTITION BY name, description ORDER BY id) as rn
	FROM product
	ORDER BY
		rn DESC,
		name,
		description
	```
	

* 2: use ctes to isolate duplicate name-description pairs in order to find all corresponding ids

	```sql
	---- first- cte returns full unique product id list w/ row numbers and duplicates sorted to the top
	WITH row_cte AS (
		SELECT				
		 id,
		 name,
		 description,
		 ROW_NUMBER() OVER(PARTITION BY name, description ORDER BY id) as rn
		FROM product
		ORDER BY
			rn DESC,
			name,
			description
		),
	---- second- cte isolates concatenated duplicate name-description pairs in list for reference
		row2_cte AS (
			SELECT name || ';' || description AS name_desc
			FROM row_cte
			WHERE rn = 2
			)
			
	---- final query returns list of all duplicate name-description pairs w/ corresponding id, std_cost, and list_price
	SELECT 
		p.id,
		p.name,
		p.description,
		p.std_cost,
		p.list_price
	FROM row_cte rc
	JOIN product p
		ON p.id = rc.id
	WHERE rc.name || ';' || rc.description IN (
		SELECT *
		FROM row2_cte)
	GROUP BY
		p.id,
		p.name,
		p.description,
		p.std_cost,
		p.list_price
	ORDER BY
		p.name,
		p.description,
		p.id
	```
	
	
**CONCLUSION:** The product ids w/ duplicate name-description pairs have different std_cost column values - the higher product id corresponds w/ a higher cost. This confirms that product ids w/ matching name-descriptions are not exact duplicates. Speculatively, this is likely due to the higher product id being a later release/version of the same product. 

**ADVICE:** update description of later released products to reflect the difference or keep the same product id for all versions. Further investigation into the initial data entry is needed before updating dataset.
	
<br><br>
 
**ISSUE:** confirm all inventory table rows are unique
**ACTION:** use row_number() to return any duplicate rows sorted to the top of the list

```sql
SELECT *, ROW_NUMBER() OVER(PARTITION BY product_id, warehouse_id, quantity ORDER BY warehouse_id) as rn
FROM inventory
ORDER BY rn DESC
```

**NO RESULTS**	
