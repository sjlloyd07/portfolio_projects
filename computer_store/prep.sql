---- create new project database
-- CREATE DATABASE computer_hardware

---- create table for raw inventory dataset
-- CREATE TABLE inventory_raw (
-- 	CATEGORY_ID int,
-- 	CATEGORY_NAME text,
-- 	PRODUCT_ID int,
-- 	PRODUCT_NAME text,
-- 	DESCRIPTION text,
-- 	DESCRIPTION_1 text,
-- 	DESCRIPTION_2 text,
-- 	DESCRIPTION_3 text,
-- 	DESCRIPTION_4 text,
-- 	STANDARD_COST decimal,
-- 	LIST_PRICE decimal,
-- 	COUNTRY_ID text,
-- 	REGION_ID int,
-- 	LOCATION_ID int,
-- 	WAREHOUSE_ID int,
-- 	QUANTITY int,
-- 	WAREHOUSE_NAME text,
-- 	ADDRESS text,
-- 	POSTAL_CODE text,
-- 	CITY text,
-- 	STATE text,
-- 	COUNTRY_NAME text
-- )




---- copy csv dataset to raw data table - COPY does not work - details below
----ERROR:  could not open file "C:\Users\steve\portfolio_projects\hardware_store\hardwareStore.csv" for reading: Permission denied
----HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy. 
----COPY inventory_raw FROM 'C:\Users\steve\portfolio_projects\hardware_store\hardwareStore.csv' CSV HEADER;

---- copy csv dataset to raw data table
-- \copy inventory_raw FROM 'C:\Users\steve\portfolio_projects\hardware_store\hardwareStore.csv' DELIMITER ',' CSV HEADER;




---- check if raw dataset contains any duplicate rows w/ row_number() - sort duplicate rows to the top

-- SELECT
-- 	ROW_NUMBER() OVER(PARTITION BY product_id, warehouse_id, quantity ORDER BY warehouse_id) as rn,
-- 	*	
-- FROM inventory_raw
-- ORDER BY rn DESC

---- NO DUPLICATES




---- create new tables for extracted data from raw data table
-- CREATE TABLE IF NOT EXISTS category (
-- 	id INT CONSTRAINT pk_cat PRIMARY KEY,
-- 	name TEXT NOT NULL
-- 	);

-- CREATE TABLE IF NOT EXISTS product (
-- 	id INT CONSTRAINT pk_product PRIMARY KEY,
-- 	name TEXT NOT NULL,
-- 	description TEXT NOT NULL,
-- 	std_cost DECIMAL NOT NULL,
-- 	list_price DECIMAL NOT NULL,
-- 	category_id INT NOT NULL,
-- 	CONSTRAINT fk_product_category FOREIGN KEY(category_id) 
-- 		REFERENCES category(id) ON DELETE CASCADE
-- 	);

-- CREATE TABLE IF NOT EXISTS region (
-- 	id INT CONSTRAINT pk_region PRIMARY KEY,
-- 	hemisphere TEXT NOT NULL
-- 	);
	
-- CREATE TABLE IF NOT EXISTS country (
-- 	id TEXT CONSTRAINT pk_country PRIMARY KEY,
-- 	name TEXT NOT NULL,
-- 	region_id INT NOT NULL,
-- 	CONSTRAINT pk_country_region FOREIGN KEY (region_id)
-- 		REFERENCES region(id) ON DELETE CASCADE
-- 	);

-- CREATE TABLE IF NOT EXISTS warehouse (
-- 	id INT CONSTRAINT pk_warehouse PRIMARY KEY,
-- 	name TEXT NOT NULL,
-- 	address TEXT NOT NULL,
-- 	postal_code TEXT NOT NULL,
-- 	city TEXT NOT NULL,
-- 	state TEXT NOT NULL,
-- 	country_id TEXT NOT NULL,
-- 	CONSTRAINT fk_warehouse_country FOREIGN KEY (country_id)
-- 		REFERENCES country(id) ON DELETE CASCADE
-- 	);
	
-- CREATE TABLE IF NOT EXISTS inventory (
-- 	product_id INT NOT NULL,
-- 	warehouse_id INT NOT NULL,
-- 	quantity INT NOT NULL,
-- 	CONSTRAINT pk_inv PRIMARY KEY (product_id, warehouse_id),
-- 	CONSTRAINT fk_inv_product FOREIGN KEY (product_id)
-- 		REFERENCES product(id) ON DELETE CASCADE,
-- 	CONSTRAINT fk_inv_wh FOREIGN KEY (warehouse_id)
-- 		REFERENCES warehouse(id) ON DELETE CASCADE
-- 	);





---- extract data from columns in raw data table into new database tables

-- -- categeory
-- INSERT INTO category
-- 	SELECT DISTINCT category_id, category_name
-- 	FROM inventory_raw
-- 	ORDER BY category_id
-- 	;

-- SELECT * 
-- FROM category
-- ;


-- -- product
-- INSERT INTO product(id, name, description, std_cost, list_price, category_id)
-- 	SELECT 
-- 		DISTINCT product_id, product_name, description, standard_cost, list_price, category_id
-- 	FROM inventory_raw
-- 	ORDER BY product_id
-- 	;

-- SELECT * 
-- FROM product 
-- LIMIT 5;


-- -- region
-- -- ISSUE: region id has no definition for reference
-- -- SOLUTION: further investigation of the dataset reveals that this variable is likely hemisphere and data analysis will proceed as such
-- INSERT INTO region
-- 	SELECT 
-- 		DISTINCT region_id,
-- 		(CASE
-- 			WHEN region_id = 2
-- 			THEN 'WESTERN'
-- 		ELSE
-- 			'EASTERN'
-- 		END) AS hemisphere
-- 	FROM inventory_raw
-- 	ORDER BY region_id
-- ;

-- SELECT * 
-- FROM region 
-- ;


-- -- country
-- INSERT INTO country
-- 	SELECT DISTINCT country_id, country_name, region_id
-- 	FROM inventory_raw
-- 	ORDER BY country_id
-- ;

-- SELECT * 
-- FROM country 
-- ;


-- -- warehouse
-- INSERT INTO warehouse
-- 	SELECT 
-- 		DISTINCT warehouse_id, 
-- 		warehouse_name, address, postal_code, 
-- 		city, state, country_id
-- 	FROM inventory_raw
-- 	ORDER BY warehouse_id
-- ;

-- SELECT * 
-- FROM warehouse 
-- ;


-- -- inventory 
-- INSERT INTO inventory
-- 	SELECT DISTINCT product_id, warehouse_id, quantity
-- 	FROM inventory_raw
-- 	ORDER BY product_id, warehouse_id
-- ;

-- SELECT * 
-- FROM inventory 
-- LIMIT 5;








---- CLEANING

-- TABLE: warehouse
-- ISSUE: multiple name column values contain warehouse name and state
-- ACTION: remove state where exists w/ substring()

-- UPDATE warehouse
-- SET name = 
-- 	(CASE
-- 		WHEN strpos(name, ',') > 0
-- 	 	THEN substring(name, 0, strpos(name, ','))
-- 	 ELSE name
-- 	 END)
-- ;

-- SELECT name
-- FROM warehouse
-- ;			
			

---- ISSUE: warehouse table, state column, Mexican state name has character encoding error
---- ACTION: fix Mexican state character encoding with substring replace()

-- UPDATE warehouse
-- SET state = replace(state, 'Ã³', 'ó' )
-- WHERE country_id = 'MX'
-- ;

-- SELECT state
-- FROM warehouse
-- ;




-- ---- check product table (too much data to visually inspect)

-- -- ISSUE: confirm product ids are unique to name-description pairs by checking for duplicate name-description pairs
-- -- ACTION: 
-- -- #1: partition name-description pairs with row_number() function, sort duplicates to top of list
-- SELECT				
--  id,
--  name,
--  description,
--  ROW_NUMBER() OVER(PARTITION BY name, description ORDER BY id) as rn
-- FROM product
-- ORDER BY
-- 	rn DESC,
-- 	name,
-- 	description


-- -- #2: use ctes to isolate duplicate name-description pairs in order to find all corresponding ids
-- ---- first- cte returns full unique product id list w/ row numbers and duplicates sorted to the top
-- WITH row_cte AS (
-- 	SELECT				
-- 	 id,
-- 	 name,
-- 	 description,
-- 	 ROW_NUMBER() OVER(PARTITION BY name, description ORDER BY id) as rn
-- 	FROM product
-- 	ORDER BY
-- 		rn DESC,
-- 		name,
-- 		description
-- 	),
-- ------ second- cte isolates concatenated duplicate name-description pairs in list for reference
-- 	row2_cte AS (
-- 		SELECT name || ';' || description AS name_desc
-- 		FROM row_cte
-- 		WHERE rn = 2
-- 		)
		
-- ------ final query returns list of all duplicate name-description pairs w/ corresponding id, std_cost, and list_price
-- SELECT 
-- 	p.id,
-- 	p.name,
-- 	p.description,
-- 	p.std_cost,
-- 	p.list_price
-- FROM row_cte rc
-- JOIN product p
-- 	ON p.id = rc.id
-- WHERE rc.name || ';' || rc.description IN (
-- 	SELECT *
-- 	FROM row2_cte)
-- GROUP BY
-- 	p.id,
-- 	p.name,
-- 	p.description,
-- 	p.std_cost,
-- 	p.list_price
-- ORDER BY
-- 	p.name,
-- 	p.description,
-- 	p.id
	
-- -- CONCLUSION: The product ids w/ duplicate name-description pairs have different std_cost column values - the higher product id corresponds w/ a higher cost.
-- -- This confirms that product ids w/ matching name-descriptions are not exact duplicates. 
-- -- Speculatively, this is likely due to the higher product id being a later release/version of the same product. 

-- -- ADVICE: update description of later released products to reflect the difference or keep the same product id for all versions.
-- -- Further investigation into the initial data entry is needed before updating dataset.
	
	
	
	

-- -- ISSUE: confirm all inventory table rows are unique
-- -- ACTION: use row_number() to return any duplicate rows sorted to the top of the list
-- SELECT
-- 	*, ROW_NUMBER() OVER(PARTITION BY product_id, warehouse_id, quantity ORDER BY warehouse_id) as rn
-- FROM inventory
-- ORDER BY rn DESC

-- -- NO RESULTS	








