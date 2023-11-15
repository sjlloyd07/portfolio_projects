# Exploratory Analysis
Each row in the dataset is a transaction item and has a unique `row_id`.

| row_count | row_id_count |
| - | - |
| 9994 | 9994 |

<br>

| description |	formula | result |
| - | - | - |
| order_id_count |	`=COUNTA(UNIQUE(Table4[Order ID],FALSE))` |	5009 |
| customer_id_count	| `=COUNTA(UNIQUE(Table4[Customer ID],,FALSE))` |	793 |
| product_id_count |	`=COUNTA(UNIQUE(Table4[Product ID],,FALSE))`	| 1862 |

<br>

| orders_per_customer |	formula	| result |
| - | - | - |
|orders_per_customer_min |	`=MIN(COUNTIFS(Table4[Customer ID],UNIQUE(Table4[Customer ID],,FALSE)))` |	1 |
|orders_per_customer_max |	`=MAX(COUNTIFS(Table4[Customer ID],UNIQUE(Table4[Customer ID],,FALSE)))`	| 37 |
|orders_per_customer_median |	`=MEDIAN(COUNTIFS(Table4[Customer ID],UNIQUE(Table4[Customer ID],,FALSE)))` |	12 |
|orders_per_customer_avg |	`=ROUND(AVERAGE(COUNTIFS(Table4[Customer ID],UNIQUE(Table4[Customer ID],,FALSE))),1)` |	12.6 |
|orders_per_customer_mode |	`=MODE.SNGL(COUNTIFS(Table4[Customer ID],UNIQUE(Table4[Customer ID],,FALSE)))`	| 10 |

<br>

| products_per_order	| formula	| result |
| - | - | - |
| products_per_order_min	| `=MIN(COUNTIFS(Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE)))`	| 1 |
| products_per_order_max	| `=MAX(COUNTIFS(Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE)))`	| 14 |
| products_per_order_median	| `=MEDIAN(COUNTIFS(Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE)))`	| 1 |
| products_per_order_avg	| `=ROUND(AVERAGE(COUNTIFS(Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE))),1)`	| 2 |
| products_per_order_mode	| `=MODE.SNGL(COUNTIFS(Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE)))`	| 1 |

<br>
	
| sales_total_per_order	|	formula	| result |
| - | - | - |
| sales_total_per_order_min	| `=MIN(SUMIFS(Table4[Sales],Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE)))`	 | $0.56 |
| sales_total_per_order_max	| `=MAX(SUMIFS(Table4[Sales],Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE)))` | $23,661.23 |
| sales_total_per_order_median	| `=MEDIAN(SUMIFS(Table4[Sales],Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE)))`	| $151.96 | 
| sales_total_per_order_avg	| `=AVERAGE(SUMIFS(Table4[Sales],Table4[Order ID],UNIQUE(Table4[Order ID],,FALSE)))`	 | $458.61 |

