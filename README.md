# E-Commerce Sales & Performance Analytics

## Project Overview
This project delivers an end-to-end sales performance analysis for an E-Commerce business using MySQL and Power BI. The goal is to transform raw transactional data into actionable business insights, evaluate customer purchasing patterns, and track key revenue drivers through standard analytics queries and interactive dashboards.

## Architecture & Database Schema
The project uses a normalized relational database schema in MySQL consisting of three core entities:
* **Customers:** Demographic and contact details.
* **Products:** Product items and pricing structures.
* **Orders:** Transactional sales records linking customers to purchased items.

## Analytics & Technical Implementation
* **Data Cleaning & Validation:** Handled null values, verified data types, and maintained referential integrity across foreign keys.
* **Complex Joins & Aggregations:** Multi-table relational queries calculating overall revenue, item quantities, and average transaction values.
* **Common Table Expressions (CTEs):** Structured modular queries to prepare data summaries for reporting layers.
* **Advanced Window Functions:** Applied `DENSE_RANK()` for customer spend rankings and `LAG()` for evaluating order history trends.
* **Conditional Logic:** Utilized `CASE` statements for customer segmentation.

## Repository Structure
* `SQL_Queries.sql`: Base queries, joins, views, and aggregations.
* `Advanced_Analytics.sql`: CTEs, Window Functions (`DENSE_RANK`, `LAG`), and complex logic.
* `01_View_Tables.sql`: Table displays and schema inspection.
* `cleaned_sales_data.csv`: Source dataset used for analytics.

## Status
**In Progress** — SQL analytics layers completed; Power BI data modeling, DAX measure creation, and dashboard design underway.
