# Data Catalog – Gold Layer

## Overview
The **Gold Layer** represents business-ready, curated data designed for analytics and reporting.  
It follows a **star schema** approach and consists of **dimension tables** and **fact tables** aligned to business metrics.

---

## 1. gold.dim_customers
**Purpose:**  
Stores customer master data enriched with demographic and geographic attributes for analysis.

### Columns

| Column Name     | Data Type    | Description |
|-----------------|--------------|-------------|
| customer_key    | INT          | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id     | INT          | Business identifier assigned to the customer in the source system. |
| customer_number | NVARCHAR(50) | Alphanumeric customer reference used for tracking and reporting. |
| first_name      | NVARCHAR(50) | Customer’s first name. |
| last_name       | NVARCHAR(50) | Customer’s last name or family name. |
| country         | NVARCHAR(50) | Country of residence (e.g., Australia). |
| marital_status  | NVARCHAR(50) | Marital status of the customer (e.g., Married, Single). |
| gender          | NVARCHAR(50) | Gender of the customer (e.g., Male, Female, n/a). |
| birthdate       | DATE         | Date of birth in YYYY-MM-DD format. |
| create_date     | DATE         | Date when the customer record was created in the system. |

---

## 2. gold.dim_products
**Purpose:**  
Contains product master data with classification and lifecycle attributes.

### Columns

| Column Name           | Data Type    | Description |
|-----------------------|--------------|-------------|
| product_key           | INT          | Surrogate key uniquely identifying each product record. |
| product_id            | INT          | Business identifier assigned to the product in the source system. |
| product_number        | NVARCHAR(50) | Alphanumeric product code used for inventory and categorization. |
| product_name          | NVARCHAR(50) | Descriptive product name including key attributes. |
| category_id           | NVARCHAR(50) | Identifier representing the product category. |
| category              | NVARCHAR(50) | High-level product classification (e.g., Bikes, Components). |
| subcategory           | NVARCHAR(50) | Detailed product classification within the category. |
| maintenance_required  | NVARCHAR(50) | Indicates whether the product requires maintenance (Yes/No). |
| cost                  | INT          | Base cost of the product. |
| product_line          | NVARCHAR(50) | Product line or series (e.g., Road, Mountain). |
| start_date            | DATE         | Date when the product became available for sale or use. |

---

## 3. gold.fact_sales
**Purpose:**  
Stores transactional sales data at the order-line level for performance and revenue analysis.

### Grain
One row per **product per sales order**.

### Columns

| Column Name     | Data Type    | Description |
|-----------------|--------------|-------------|
| order_number    | NVARCHAR(50) | Unique identifier for the sales order (e.g., SO54496). |
| product_key     | INT          | Surrogate key referencing gold.dim_products. |
| customer_key    | INT          | Surrogate key referencing gold.dim_customers. |
| order_date      | DATE         | Date when the order was placed. |
| shipping_date   | DATE         | Date when the order was shipped. |
| due_date        | DATE         | Date when payment for the order was due. |
| sales_amount    | INT          | Total sales value for the line item. |
| quantity        | INT          | Number of units sold for the line item. |
| price           | INT          | Unit price of the product at the time of sale. |
