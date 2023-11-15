# Cleaning and Preparation

1.	Download raw data .csv file to local storage.

2.	Save copy as .xlsx file.

3.	Problem: Check for and remove duplicate rows
	Action: use 'Remove Duplicates' tool to check for and remove duplicate rows
	* no duplicates found

4.	Problem: Check that row ids are unique. 
	Action:	Compare total row and unique row_id counts using `=COUNT()` function.
	* values match
	
5.	Problem: Check for blank/null values in dataset. 
	Action: Apply 'Filter' to all rows and check that there are no blank values.
	* no blank values

6.	Problem: Check that all `Order ID` values are the same formatting and length.
	Action: Create new check column and use `=LEN()` and `Filter` to check all column values.
	* all ids are the same length
	* delete check column
	
7.	Problem: `Order date` and `Ship date` columns have raw data values that are date formatted DD/MM/YYYY and caused formatting errors when the data was imported.
	Action: Change all date values to YYYY/MM/DD format.
	 * create new check column right of order_date.
	 * use `=IF()` and `=ISNUMBER()` to insert all order date values as general format in check column
	 * create 3 new columns to extract day, month, and year from check column
	 * create new column order_date_us to insert extracted day, month, and year data as YYYY/MM/DD
	* past values in new column
	* perform same steps on ship_date column

8.	Problem: Check that all `Customer ID` values are the same length.
	Action: Create new check column and use `=LEN()` and `Filter` to check all column values.
	* all values are same length
	* delete check column

9.	Problem: `Postal code` column values should have 5 characters. Values with 4 characters should have leading 0s
	Action: Create new check column to add leading 0s to postal codes with 4 character length using formula: `=IF(LEN(L2)<5,CONCAT("0",L2),L2)`.
	* copy and paste check column values into `Postal code`
	
10. Problem: Check that all `Product ID` values are the same length.
	Action: Create new check column and use `=LEN()` and `Filter` to check all column values.
	* all ids are the same length
	* delete check column

11.	Problem: `Sales` and `Profit` columns should be currency format.
	Action: Change `Sales` and `Profit` columns to currency w/ 2 decimal points.


	

