# E-Commerce Sales & Performance Analytics (MySQL & Power BI)

## 📌 Executive Summary
This repository contains an end-to-end data analytics project focused on evaluating e-commerce performance. Using **MySQL Workbench**, the dataset was structured, cleaned, and queried to perform both foundational aggregations and advanced statistical analytics (such as moving averages, rankings using Window Functions, and null-handling techniques). 

The output from this relational database serves as the foundation for interactive visual dashboards built in **Power BI** to deliver actionable insights on revenue trends, customer lifetime values, and product performance.

---

## 🛠️ Tech Stack & Key Technologies
* **Database Management System:** MySQL Workbench 8.0
* **Querying Language:** Advanced SQL (CTEs, Window Functions, Aggregations, Joins, Null Handling)
* **Visualization Tool:** Microsoft Power BI
* **Version Control:** Git & GitHub

---

## 📂 Project Structure & SQL Implementation

### 1. Database Schema & Data Modeling
* Designed and established normalized relational tables: `Customers`, `Products`, and `Orders`.
* Primary keys and foreign keys were configured to preserve entity integrity and enable efficient multi-table JOIN operations.

### 2. Core SQL Queries & Business Logic
* **Data Aggregation & Joining:** Analyzed total sales per customer and revenue per product category using `INNER JOIN` and `LEFT JOIN` clauses.
* **Window Functions & Ranking:** Executed `ROW_NUMBER()` and `DENSE_RANK()` over ordered partitions to identify top-performing customers and best-selling products.
* **Common Table Expressions (CTEs):** Structured complex logic into readable, reusable subqueries for multi-step analytics.
* **Time-Series Analysis (Moving Averages):** Calculated 3-month moving averages using `AVG() OVER (ORDER BY ... ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)` to smooth out seasonal fluctuations and detect overall sales trends.
* **Data Integrity & Null Handling:** Implemented `COALESCE()` to eliminate `NULL` outputs in aggregation queries, ensuring consistent zero-value reporting for unsold inventory.

---

## 📊 Analytics Highlights & Insights
1. **Sales Trend Smoothing:** Identified underlying quarterly momentum by mitigating short-term monthly revenue spikes via moving average models.
2. **Customer Segmentation:** Ranked top-tier clients based on aggregate spend to support targeted loyalty initiatives.
3. **Product Revenue Contribution:** Evaluated product category yields to highlight underperforming products and high-margin leaders.

---

## 🚀 Future Enhancements & Power BI Integration
* Integration with **Power BI** to build interactive visual charts, measure DAX metrics, and facilitate real-time monitoring.
* Implementation of dynamic date tables for advanced time-intelligence capabilities.
