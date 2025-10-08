# 📦 Data Warehouse & Analytics Project 🚀  

Welcome to the **Data Warehouse and Analytics Project**!  
This project demonstrates how to design and implement a **modern data warehousing and analytics solution** using **SQL Server**, covering everything from raw data ingestion to actionable business insights.  

It is designed as a **portfolio project** to highlight **industry best practices** in **data engineering, data modeling, ETL, and analytics**.  

---

## 🏗️ Data Architecture  

This project follows the **Medallion Architecture** (Bronze, Silver, Gold):  

- **Bronze Layer** → Raw data ingested from ERP + CRM systems (CSV → SQL Server).  
- **Silver Layer** → Cleansed, standardized, and transformed data.  
- **Gold Layer** → Business-ready data modeled into **star schema** for analytics & reporting.  


---

## 📖 Project Overview  

This project demonstrates:  

- **Data Architecture**: Building a warehouse using Bronze → Silver → Gold layers.  
- **ETL Pipelines**: Loading, cleaning, transforming raw ERP & CRM data.  
- **Data Modeling**: Creating **fact & dimension tables** optimized for reporting.  
- **Analytics & Reporting**: Writing SQL queries for customer, product, and sales insights.  

---

## 🎯 Skills Demonstrated  

✔️ SQL Development (DDL + DML)  
✔️ ETL Design & Implementation  
✔️ Data Warehousing (Star Schema, Dimensional Modeling)  
✔️ Data Integration (ERP + CRM)  
✔️ SQL Analytics & Optimization  
✔️ BI Reporting (SQL + Power BI-ready models)  

---

## 🚀 Project Requirements  

### 🔹 1. Data Engineering (Warehouse)  
**Objective**: Build a SQL Server Data Warehouse for consolidated sales data.  

- **Sources** → ERP + CRM datasets (CSV).  
- **Data Quality** → Handle duplicates, missing values, standardize attributes.  
- **Integration** → Merge multiple sources into one consistent model.  
- **Scope** → Focus on current dataset (no historization).  
- **Deliverables** → Data catalog, ER diagrams, architecture docs.  

### 🔹 2. Analytics & Reporting  
**Objective**: Use SQL queries to answer business questions:  

- **Customer Behavior** → Spend, loyalty, repeat purchases.  
- **Product Performance** → Top sellers, slow movers.  
- **Sales Trends** → Growth, seasonality, revenue insights.  

---

## 📊 Example Analytics Queries  

```sql
-- Top 10 Customers by Spend
SELECT c.CustomerName, SUM(f.ExtendedAmount) AS TotalSpend
FROM fact.Sales f
JOIN dim.Customer c ON f.CustomerSK = c.CustomerSK
GROUP BY c.CustomerName
ORDER BY TotalSpend DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Monthly Sales Trends
SELECT YEAR(f.InvoiceDate) AS Yr, MONTH(f.InvoiceDate) AS Mo,
       SUM(f.ExtendedAmount) AS MonthlySales
FROM fact.Sales f
GROUP BY YEAR(f.InvoiceDate), MONTH(f.InvoiceDate)
ORDER BY Yr, Mo;
```

---

## 🛠️ Tools & Technologies  

- **SQL Server Express** → Database engine  
- **SQL Server Management Studio (SSMS)** → Development & admin  
- **Draw.io / Lucidchart** → Data models & architecture diagrams  
- **Git & GitHub** → Version control & project hosting  
- **Notion** → Planning & documentation  
- **Power BI (optional)** → Visualization & dashboards  

---

## 📂 Project Workflow  

1. Import datasets → `/datasets/` → Bronze layer.  
2. Run SQL scripts → `/scripts/silver/` → Clean & transform.  
3. Run SQL scripts → `/scripts/gold/` → Create **fact/dimension models**.  
4. Execute analytics queries → `/scripts/gold/analytics.sql`.  
5. (Optional) Connect Power BI → Create dashboards.  

---

## 📌 Example Deliverables  

- **Data Model** → Star schema (FactSales + DimCustomer, DimProduct, DimDate).  
- **ETL Scripts** → Automated pipelines for data cleaning & loading.  
- **Analytics Reports** → Customer loyalty, product trends, revenue analysis.  
- **Power BI Dashboards** → Interactive reporting (optional).  

---

## 🛡️ License  

This project is licensed under the **MIT License** – feel free to use and modify with attribution.  
