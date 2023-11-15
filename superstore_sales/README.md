# Superstore Sales Trend Analysis

### In 2015, the business stakeholders at an office supply super store want to know how they should plan their resources for the future by examining the previous years sales records.

What times of year had the most sales?
What segment had the most/least growth?
What product category had the most sales?
What was the most profitable category/subcategory of products?
What were the top selling products?


## Data 
The dataset was taken from [kaggle](https://www.kaggle.com/datasets/ishanshrivastava28/superstore-sales) and consists of mock superstore sales transaction records taken from 2011 to 2014.

The data was confirmed to be complete and consistent during [cleaning and preparation]().

## Analysis
### What times of year had the most sales?

**September, November,** and **December** were the *highest* selling months in every year.  **March** was fourth highest in **2011** and **2012**, and then fell behind **October** in **2013** and **2014.**

![monthly_sales](/superstore_sales/images/montly_sales.PNG)

<br>

### What segment had the most/least growth?

Both the **Corporate** and **Home Office** segments had significant growth between **2012** and **2014** after having either no and negative growth from **2011** to **2012.** Similarly, the **Consumer** segment had almost no growth from **2011** to **2012,** but has had steadily increasing sales since **2012.**

![segment_sales](/superstore_sales/images/segment_sales.PNG)

 [⏯️ **Go to Sales Dashboard**](/superstore_sales/.README/#Sales-Dashboard---Years)

<br>

### What product category had the most sales?

#### Consumer
Product category sales varied little over the timeline, and 2014 sales are only slightly above 2011 sales.  
The most significant variations occurred when **technology** sales *increased 20%* from 2012 to 2013 and **office supplies** sales *increased 30%* from 2013 to 2014.

Both corporate and home office sales varied drastically in comparison to consumer sales.

#### Corporate
From 2011 to 2012, **furniture** had little growth while **technology** sales *increase 40%*, and inversely, **office supplies** *dropped 30%*.  
**All category** sales *increased over 50%* into 2013.  
**Office supplies** *increase another 70%* into 2014, **technology** over *15%*, and **furniture** sales *dropped 20%* from 2013.

#### Home Office
**Furniture** and **office supplies** both *increased over 15%* from 2011 to 2012, while **technology** sales *decreased 50%* during this time.  
Going into 2013, sales for **furniture** *decreased 30%*, **office supplies** continued to *grow over 90%*, and **techonolgy** rebounded with *80% growth*.  
**Technology** sales continued to *grow more than 80%* into 2014 along with **furniture** sales that *increased more than 100%*. **Office supplies** *decreased slightly*.

![category_sales](/superstore_sales/images/category_sales.PNG)

 [⏯️ **Go to Sales Dashboard**](/superstore_sales/.README/#Sales-Dashboard---Segment)

<br>

### What was the most profitable category/subcategory of products?

Products in the technology category were the most profitable over the timeline, and copiers were the most profitable sub-category of products within that followed by phones and accessories. This was true with regards to every segment.  
The least profitable products by far were tables in the furniture category with negative profits of almost $20000.

![profits](/superstore_sales/images/profits.PNG)

<br>

### Best Selling Products
The highest selling product from 2011 to 2014 was a Canon brand copier of which all of its sales occurred in 2013 and 2014.

![best_selling](/superstore_sales/images/best_selling.PNG)


## Conclusion





<br>

## Sales Dashboard - Years
![sales_dash_years](/superstore_sales/images/year_sales_dash.gif)

<br>

## Sales Dashboard - Segment
![sales_dash_segment](/superstore_sales/images/segment_sales_dah.gif)
