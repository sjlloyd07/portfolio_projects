# Introduction
### Scenario: After a company wide inventory count, a computer hardware company requests a summary of its current inventory. The inventory is located at multiple international warehouses.

The company wants a summary of that includes the following:

* check that inventory count includes all products and warehouses

* total product *count* and *value*
 * company-wide
 * at each warehouse
 
* total product *count* and *value* of **each product category** w/ percentage of total
 * company-wide
 * at each warehouse
 
* product with highest gross value 
 * company-wide
 * at each warehouse

* most and least profitable product
 * at each warehouse




## Steps taken
<!-- inspect data with excel to determine structure -->
### Preparation 
The computer hardware store inventory dataset is stored in a `.csv` file that was downloaded to local storage. Microsoft Excel was utilized for initial data inspection. PostgreSQL was utilized for further cleaning, manipulation, and analysis.

[kaggle dataset](https://www.kaggle.com/datasets/ivanchvez/hardwarestore?select=hardwareStore.csv)

The dataset consists of 22 columns. 
<!-- column names -->
| CATEGORY_ID | CATEGORY_NAME | PRODUCT_ID | PRODUCT_NAME | DESCRIPTION | DESCRIPTION - Detail 1 | DESCRIPTION - Detail 2 | DESCRIPTION - Detail 3 | DESCRIPTION - Detail 4 | STANDARD_COST | LIST_PRICE | COUNTRY_ID | REGION_ID | LOCATION_ID | WAREHOUSE_ID | QUANTITY | WAREHOUSE_NAME | ADDRESS | POSTAL_CODE | CITY | STATE | COUNTRY_NAME |
|-------------|---------------|------------|--------------|-------------|------------------------|------------------------|------------------------|------------------------|---------------|------------|------------|-----------|-------------|--------------|----------|----------------|---------|-------------|------|-------|--------------|


<!-- uplaod dataset to new postgres database for cleaning, normalization, and analysis -->

A postgres database was created on a local server with a `CREATE DATABASE` statement in order to store the inventory analysis project.

Using the `.csv` column names, table `inventory_raw` was created to store the raw dataset.

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


Dataset was uploaded to `inventory_raw` with a psql `/copy` statement.

`\copy inventory_raw FROM 'C:\Users\steve\portfolio_projects\hardware_store\hardwareStore.csv' DELIMITER ',' CSV HEADER;`

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


The `inventory_raw` table was checked for duplicate rows using the `ROW_NUMBER()` window function.

```sql
SELECT
	ROW_NUMBER() OVER(PARTITION BY product_id, warehouse_id, quantity ORDER BY warehouse_id) as rn,
	*	
FROM inventory_raw
ORDER BY rn DESC
```

No duplicates were found.

<!-- start normalization process of new database -->
At this point, the raw dataset was ready to undertake normalization in order to maintain integrity and avoid redundancy.

### Begin normalizaion
<!-- make ERD -->
An entity relationship diagram (ERD) was constructed to represent the table relationships.

[link to img](img link)

<!-- drop location_id - redundant data with warehouse_id -->
Column `location_id` is redundant to column `warehouse_id` in this analysis.  Column `location_id` data was disregarded.

<!-- create new database tables -->

--------------------------- move to prep file




<!-- perform analysis using sql -->



<!-- create interactive dashboard w/ tableau -->