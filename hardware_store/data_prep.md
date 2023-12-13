# Preparation 
The computer hardware store inventory dataset is stored in a `.csv` file that was downloaded to local storage. 

<br>

### Inspection and upload
Initial data inspection utilizing **Microsoft Excel** revealed that the raw dataset consisted of **22** columns - isolated below.

<!-- column names -->
| CATEGORY_ID | CATEGORY_NAME | PRODUCT_ID | PRODUCT_NAME | DESCRIPTION | DESCRIPTION - Detail 1 | DESCRIPTION - Detail 2 | DESCRIPTION - Detail 3 | DESCRIPTION - Detail 4 | STANDARD_COST | LIST_PRICE | COUNTRY_ID | REGION_ID | LOCATION_ID | WAREHOUSE_ID | QUANTITY | WAREHOUSE_NAME | ADDRESS | POSTAL_CODE | CITY | STATE | COUNTRY_NAME |
|-------------|---------------|------------|--------------|-------------|------------------------|------------------------|------------------------|------------------------|---------------|------------|------------|-----------|-------------|--------------|----------|----------------|---------|-------------|------|-------|--------------|

<br><br>

<!-- uplaod dataset to new postgres database for cleaning, normalization, and analysis -->
**PostgreSQL** was utilized for cleaning, manipulation, and analysis of the dataset via **pgAdmin**.

A postgres database was created on a local server with a `CREATE DATABASE` statement in order to store the inventory analysis project.

Using the `.csv` file column names, table `inventory_raw` was created to store the raw data in the database.


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
);
```
</details>
<br><br>

The dataset was copied to database table `inventory_raw` with a PSQL `/copy` statement.

`\copy inventory_raw FROM 'C:\Users\steve\portfolio_projects\hardware_store\hardwareStore.csv' DELIMITER ',' CSV HEADER;`

<details>
	<summary><strong>View Table Summary</strong></summary>
	
```sql
SELECT *
FROM inventory_raw
LIMIT 5
;
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

The `inventory_raw` table was checked for duplicate rows using the `ROW_NUMBER()` window function and partitioning the rows by known row identifiers - `product_id`, `warehouse_id`, and `quantity`. This returns a row number value of **1** for every unique row and **2** if that row is a duplicate.  
** Correction: `quantity` should not be included in this statement.


```sql
SELECT ROW_NUMBER() OVER(PARTITION BY product_id, warehouse_id, quantity ORDER BY warehouse_id) as rn, *	
FROM inventory_raw
ORDER BY rn DESC
;
```

<details>
	<summary><strong>View Results Summary</strong></summary><br>

 | rn | category_id | category_name | product_id | product_name          | description                    | description_1 | description_2 | description_3 | description_4 | standard_cost | list_price | country_id | region_id | location_id | warehouse_id | quantity | warehouse_name | address               | postal_code | city            | state           | country_name             |
|----|-------------|---------------|------------|-----------------------|--------------------------------|---------------|---------------|---------------|---------------|---------------|------------|------------|-----------|-------------|--------------|----------|----------------|-----------------------|-------------|-----------------|-----------------|--------------------------|
| 1  | 1           | CPU           | 2          | Intel Xeon E5-2697 V4 | Speed:2.3GHz,Cores:18,TDP:145W | Speed:2.3GHz  | Cores:18      | TDP:145W      | 0             | 2144.4        | 2554.99    | US         | 2         | 7           | 3            | 100      | New Jersey     | 2007 Zagora St        | 50090       | South Brunswick | New Jersey      | United States of America |
| 1  | 1           | CPU           | 2          | Intel Xeon E5-2697 V4 | Speed:2.3GHz,Cores:18,TDP:145W | Speed:2.3GHz  | Cores:18      | TDP:145W      | 0             | 2144.4        | 2554.99    | CA         | 2         | 9           | 5            | 71       | Toronto        | 147 Spadina Ave       | M5V 2L7     | Toronto         | Ontario         | Canada                   |
| 1  | 1           | CPU           | 2          | Intel Xeon E5-2697 V4 | Speed:2.3GHz,Cores:18,TDP:145W | Speed:2.3GHz  | Cores:18      | TDP:145W      | 0             | 2144.4        | 2554.99    | AU         | 3         | 13          | 6            | 58       | Sydney         | 12-98 Victoria Street | 2901        | Sydney          | New South Wales | Australia                |
| 1  | 1           | CPU           | 2          | Intel Xeon E5-2697 V4 | Speed:2.3GHz,Cores:18,TDP:145W | Speed:2.3GHz  | Cores:18      | TDP:145W      | 0             | 2144.4        | 2554.99    | MX         | 2         | 23          | 7            | 46       | Mexico City    | Mariano Escobedo 9991 | 11932       | Monterrey       | Nuevo LeÃ³n     | Mexico                   |
| 1  | 1           | CPU           | 2          | Intel Xeon E5-2697 V4 | Speed:2.3GHz,Cores:18,TDP:145W | Speed:2.3GHz  | Cores:18      | TDP:145W      | 0             | 2144.4        | 2554.99    | CN         | 3         | 11          | 8            | 34       | Beijing        | 40-5-12 Laogianggen   | 190518      | Beijing         | Shenzhen        | China                    |

<br>
 
 **No duplicates were found.**

</details>
<br><br>

<!-- start normalization process of new database -->
At this point, steps were taken to normalize the raw dataset into 3rd normal form.  This is done in order to maintain data integrity and avoid redundancy in the dataset, as well as make the data easier to work with in analysis.

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
The ERD was used as a guide to create the following tables and define their corresponding primary and foreign keys: `category`, `product`, `region`, `country`, `warehouse`, and `inventory`.

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

#### Data was extracted from `inventory_raw` table into newly created tables.

<br>

**`category`**

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
	
| id | name         |
|----|--------------|
| 1  | CPU          |
| 2  | Video Card   |
| 4  | Mother Board |
| 5  | Storage      |

</details>
<br><br><br>

**`product`**

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
LIMIT 5
;
```

| id | name                  | description                                               | std_cost | list_price | category_id |
|----|-----------------------|-----------------------------------------------------------|----------|------------|-------------|
| 2  | Intel Xeon E5-2697 V4 | Speed:2.3GHz,Cores:18,TDP:145W                            | 2144.4   | 2554.99    | 1           |
| 3  | Corsair CB-9060011-WW | Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.57GHz | 573.51   | 799.99     | 2           |
| 4  | AMD 100-505989        | Chipset:FirePro W9100,Memory:32GBCore Clock:930MHz        | 2128.67  | 2699.99    | 2           |
| 5  | PNY VCQK6000-PB       | Chipset:Quadro K6000,Memory:12GBCore Clock:902MHz         | 1740.31  | 2290.79    | 2           |
| 6  | Zotac ZT-P10810A-10P  | Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.48GHz | 702.35   | 849.99     | 2           |

</details>
<br><br><br>

**`region`**

⚠️ **ISSUE:** `region_id` values have no corresponding column for reference

🛠️ **SOLUTION:** further investigation of the dataset reveals that this variable is likely hemisphere and data analysis will proceed as such

```sql
INSERT INTO region
	SELECT	DISTINCT region_id,
		(CASE	WHEN region_id = 2
			THEN 'WESTERN'
			ELSE 'EASTERN'
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

| id | hemisphere |
|----|------------|
| 2  | WESTERN    |
| 3  | EASTERN    |

</details>
<br><br><br>

**`country`**

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
	
| id | name                     | region_id |
|----|--------------------------|-----------|
| AU | Australia                | 3         |
| CA | Canada                   | 2         |
| CN | China                    | 3         |
| IN | India                    | 3         |
| MX | Mexico                   | 2         |
| US | United States of America | 2         |

</details>
<br><br><br>

**`warehouse`**

```sql
INSERT INTO warehouse
	SELECT	DISTINCT warehouse_id, 
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
ORDER BY id
;
```
	
| id | warehouse_name      | address               | postal_code | city                | state           | country_id |
|--------------|---------------------|-----------------------|-------------|---------------------|-----------------|------------|
| 1            | Southlake, Texas    | 2014 Jabberwocky Rd   | 26192       | Southlake           | Texas           | US         |
| 2            | San Francisco       | 2011 Interiors Blvd   | 99236       | South San Francisco | California      | US         |
| 3            | New Jersey          | 2007 Zagora St        | 50090       | South Brunswick     | New Jersey      | US         |
| 4            | Seattle, Washington | 2004 Charade Rd       | 98199       | Seattle             | Washington      | US         |
| 5            | Toronto             | 147 Spadina Ave       | M5V 2L7     | Toronto             | Ontario         | CA         |
| 6            | Sydney              | 12-98 Victoria Street | 2901        | Sydney              | New South Wales | AU         |
| 7            | Mexico City         | Mariano Escobedo 9991 | 11932       | Monterrey           | Nuevo LeÃ³n     | MX         |
| 8            | Beijing             | 40-5-12 Laogianggen   | 190518      | Beijing             | Shenzhen        | CN         |
| 9            | Bombay              | 1298 Vileparle (E)    | 490231      | Bombay              | Maharashtra     | IN         |


</details>
<br><br><br>

**`inventory`**

```sql
INSERT INTO inventory
	SELECT DISTINCT product_id, warehouse_id, quantity
	FROM inventory_raw
	ORDER BY product_id, warehouse_id
;
```

<details>
	<summary><strong>View Table Summary</strong></summary><br>
	
```sql
SELECT * 
FROM inventory 
LIMIT 5;
```

| product_id | warehouse_id | quantity |
|------------|--------------|----------|
| 2          | 3            | 100      |
| 2          | 5            | 71       |
| 2          | 6            | 58       |
| 2          | 7            | 46       |
| 2          | 8            | 34       |

</details>
<br><br><br>



## Cleaning

### TABLE: `warehouse`

⚠️ **ISSUE:** multiple `name` values contain warehouse name and state

🛠️ **ACTION:** remove state where exists w/ `SUBSTRING()`

<br>

```sql 
UPDATE warehouse
SET name = 
	(CASE	WHEN STRPOS(name, ',') > 0
	 	THEN SUBSTRING(name, 0, STRPOS(name, ','))
		 ELSE name
	 END)
;
```

<br><br>

⚠️ **ISSUE:** `state` column - Mexican state name has character encoding error

🛠️ **ACTION:** investigation of source data reveals the correct ASCII character replacement; fix wrongly encoded Mexican state character with `REPLACE()`

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

| id | name          | address               | postal_code | city                | state           | country_id |
|----|---------------|-----------------------|-------------|---------------------|-----------------|------------|
| 1  | Southlake     | 2014 Jabberwocky Rd   | 26192       | Southlake           | Texas           | US         |
| 2  | San Francisco | 2011 Interiors Blvd   | 99236       | South San Francisco | California      | US         |
| 3  | New Jersey    | 2007 Zagora St        | 50090       | South Brunswick     | New Jersey      | US         |
| 4  | Seattle       | 2004 Charade Rd       | 98199       | Seattle             | Washington      | US         |
| 5  | Toronto       | 147 Spadina Ave       | M5V 2L7     | Toronto             | Ontario         | CA         |
| 6  | Sydney        | 12-98 Victoria Street | 2901        | Sydney              | New South Wales | AU         |
| 7  | Mexico City   | Mariano Escobedo 9991 | 11932       | Monterrey           | Nuevo León      | MX         |
| 8  | Beijing       | 40-5-12 Laogianggen   | 190518      | Beijing             | Shenzhen        | CN         |
| 9  | Bombay        | 1298 Vileparle (E)    | 490231      | Bombay              | Maharashtra     | IN         |

</details>
<br><br><br>



### TABLE: `product`

⚠️ **ISSUE:** confirm product ids are unique to name-description pairs by checking for duplicate name-description pairs

🛠️ **ACTION:** check for duplicates using `ROW_NUMBER()`

* **1:** partition name-description pairs with `ROW_NUMBER()` function, sort duplicates (rn >= 2) to top of list

	```sql
	SELECT	id,
 		name,
 		description,
 		ROW_NUMBER() OVER(PARTITION BY name, description ORDER BY id) as rn
	FROM product
	ORDER BY
		rn DESC,
		name,
		description
 	;
	```
	

* **2:** use CTEs to isolate duplicate name-description pairs in order to find all corresponding ids

	```sql
	---- first- cte returns full unique product id list w/ row numbers and duplicates sorted to the top
	WITH row_cte AS (
		SELECT	id,
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
	SELECT	p.id,
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
 	;
	```
	
	
**CONCLUSION:** The product ids w/ duplicate name-description pairs have different std_cost column values - the higher product id corresponds w/ a higher cost. This confirms that product ids w/ matching name-descriptions are not exact duplicates. Speculatively, this is likely due to the higher product id being a later release/version of the same product. 

**ADVICE:** update description of later released products to reflect the difference or keep the same product id for all versions. Further investigation into the initial data entry is needed before updating dataset.
	
<br><br>
 
⚠️ **ISSUE:** confirm all inventory table rows are unique

🛠️ **ACTION:** use `ROW_NUMBER()` to return any duplicate rows (rn >= 2) sorted to the top of the list

```sql
SELECT *, ROW_NUMBER() OVER(PARTITION BY product_id, warehouse_id, quantity ORDER BY warehouse_id) as rn
FROM inventory
ORDER BY rn DESC
;
```

**NO RESULTS**	
