<div align="center">
 
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)
 
</div>
 
---

# CFPB_Bank_Complaint

---

## Project Overview

This project analyzes 28,656 Bank of America consumer complaints submitted to the Consumer Financial Protection Bureau (CFPB) between 2023 and 2024.

The objective is to identify consumer complaint trends, determine which financial products and issues generate the most complaints, and evaluate company response performance.

PostgreSQL was used for data cleaning, validation, and analysis, while Power BI was used to develop an interactive dashboard that communicates key findings and supports data-driven decision-making.

---

## Business Questions
1. How has consumer complaint volume changed over the past 2 years?
2. Which financial products and issues are driving the most complaints?
3. Are companies responding to consumer complaints on time?

---

## Dataset

Source: CFPB Consumer Complaint Database

Reporting Period: January 2023 – December 2024.

Total Records: 28,656.

Company: Bank of America.

The dataset contains information about consumer complaints involving financial products and services.

Key columns used in this analysis include:

- complaint_id
- date_received
- product
- issue
- company
- state
- timely_response

---

## Data Cleaning and Preparation

The original dataset was imported into PostgreSQL and assessed for data quality before analysis.

The cleaning and preparation process included:

**Duplicate Detection**: Checked for duplicate complaint IDs to verify record uniqueness.

**Missing Value Analysis**: Identified NULL values, blank strings, and missing-value placeholders.

**Date Validation:** Reviewed complaint dates and restricted the reporting period to 2023–2024.

**Category Validation**: Examined product and issue categories for consistency across reporting years.

**Geographic Classification**: Grouped geographic values into U.S. states, Washington D.C., U.S. territories, military addresses, and missing values.

The original data was preserved while cleaned views were used for SQL analysis and Power BI reporting.

---

## SQL Analysis

PostgreSQL was used to calculate complaint trends, identify recurring consumer issues, and evaluate company response performance.

SQL techniques used:

* Aggregations: COUNT(), SUM(), GROUP BY
* Window Functions: LAG(), OVER()
* Common Table Expressions: WITH
* Conditional Aggregation: FILTER (WHERE ...)
* Data Cleaning: CASE, TRIM(), NULLIF(), COALESCE()
* Date Analysis: DATE_TRUNC(), EXTRACT()

---

## 
