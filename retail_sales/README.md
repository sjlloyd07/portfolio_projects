# Retail Store Sales Analysis

### Overview

The owners of a retail store request answers to the following questions they have about the sales data from their store. The sales data contains transaction records that include invoice details by line item and customer location.

### Deliverables
* How much in total sales did they do?
* How many items sold total?
* What times of year had the highest sales?
* What country had the highest sales?
* What item sold the most?
* Who was their best customer?

<br>

### Tools
- PostgreSQL (PgAdmin4)
- Tableau

<br>

---

## Table of Contents
* ### [Data](https://github.com/sjlloyd07/portfolio_projects/tree/main/retail_sales#Data)
* ### [Cleaning and Prep](https://github.com/sjlloyd07/portfolio_projects/tree/main/retail_sales#Cleaning--Prep)
* ### [Dashboard](https://github.com/sjlloyd07/portfolio_projects/tree/main/retail_sales#Dashboard)
* ### [Deliverables](https://github.com/sjlloyd07/portfolio_projects/tree/main/retail_sales#deliverables)

----

<br>

# Data
The dataset consists of mock retail sales data sourced from this kaggle [online retail dataset](https://www.kaggle.com/datasets/siddharththakkar26/online-retail-dataset).  
It was downloaded to local storage in `.xlsx` format, inspected and exported into `.csv` format, and uploaded to a PostgreSQL database for cleaning and preparation.

<br>

----

# Cleaning / Prep
The PostgreSQL GUI PgAdmin4 was utilized to perform data inspection and cleaning tasks to prepare the data for analysis and visualization in Tableau.

**Summary of the prepared dataset:**

| records | invoices | unique_stock_items | total_items_sold | total_sales | customers | countries |
|---------|----------|--------------------|------------------|-------------|-----------|-----------|
| 353039  | 16232    | 3581               | 4559048          | 6369539.52  | 4168      | 36        |

<br>

----

# Dashboard

<div class='tableauPlaceholder' id='viz1702568107933' style='position: relative'>
  <noscript>
    <a href='https://public.tableau.com/views/retail_sales_report_17022538787610/Dashboard?:language=en-US&:display_count=n&:origin=viz_share_link'>
      <img alt='Dashboard ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;re&#47;retail_sales_report_17022538787610&#47;Dashboard&#47;1_rss.png' style='border: none' />
    </a>


<br>

----

# Deliverables
* How much in total sales did they do?
  * **$ 6369539.52**
    
* How many items sold total?
   * **4559048**

* What times of year had the highest sales?
   * **The fourth quarter.**

* What country had the highest sales?
   * **United Kingdom**

* What item sold the most?
   * **Papercraft, Little Birdie**

* Who was their best customer?
   * **Customer 14646, Netherlands.**
