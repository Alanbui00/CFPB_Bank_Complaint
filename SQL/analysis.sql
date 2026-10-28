--1. How has consumer complaint volume changed over the past 2 years?
--2. Which financial products and issues are driving the most complaints?
--3. Are companies responding to consumer complaints on time?

----------------------------------------------------------------
SELECT
    *
FROM cfpb_analysis_clean
LIMIT 5

--1. How has consumer complaint volume changed over the past 2 years?

SELECT
    COUNT(*)
FROM cfpb_analysis_clean
WHERE date_received >= '2023-01-01' AND date_received < '2024-01-01'
-- 14315 records in 2023

SELECT
    COUNT(*)
FROM cfpb_analysis_clean
WHERE date_received >= '2024-01-01' AND date_received < '2025-01-01'
-- 14323 records in 2024

-- In 2023, there were 14,315 complaints received, while in 2024, there were 14,323 complaints received. 
-- This indicates a slight increase in consumer complaint volume over the past two years.


With monthly_complaints AS(
    SELECT
        DATE_TRUNC('month', date_received) AS month,
        COUNT(*) AS complaint_count
    FROM cfpb_analysis_clean
    GROUP BY month
),
monthly_complaints_with_lag AS(
    SELECT
        month,
        complaint_count,
        LAG(complaint_count) OVER (ORDER BY month) AS previous_month_complaint_count
    FROM monthly_complaints
)
SELECT
    month,
    complaint_count,
    previous_month_complaint_count,
    complaint_count - previous_month_complaint_count AS complaint_change,
    ROUND(100 * (complaint_count - previous_month_complaint_count)::NUMERIC / previous_month_complaint_count::NUMERIC, 2) AS complaint_change_percentage
FROM monthly_complaints_with_lag
ORDER BY month
-- Complaint volumn remained statble, increasing only slightly from 2023 to 2024. 
-- July 2023 experiencedf a significant spike of 70% comapred to June. Montly complaint
-- vloumnes fluctated less in 2024, more consistent complain activity.
----------------------------------------------------------------

--2. Which financial products and issues are driving the most complaints?
SELECT
    product,
    COUNT(*) AS product_count
FROM cfpb_analysis_clean
GROUP BY product
ORDER BY product_count DESC
-- Checking or saving accounts have the highest number of complaints, followed by credit cards and Credit reporting.

SELECT
    issue,
    COUNT(*) AS issue_count 
FROM cfpb_analysis_clean
GROUP BY issue
ORDER BY issue_count DESC
-- Most common issue is managing an account followed by incorrect inforamtion on report and Impropr use of your report


SELECT
    product,
    issue,
    COUNT(*) AS total_complaints
FROM cfpb_analysis_clean
WHERE date_received >= DATE '2023-01-01'
  AND date_received < DATE '2025-01-01'
GROUP BY
    product, issue
ORDER BY total_complaints DESC
LIMIT 10;
-- Checking or savings accounts generated the most complaints, with 6,206 related to account management, making it the leading product-issue combination. Credit reporting was another major concern, particularly improper use of consumer reports (1,718 complaints) and incorrect information (1,487 complaints). 
-- These findings suggest that account management and credit reporting should be prioritized for further investigation and potential process improvements.

WITH product_year AS (
    SELECT
        product,
        COUNT(*) FILTER (
            WHERE date_received >= DATE '2023-01-01'
              AND date_received < DATE '2024-01-01'
        ) AS complaints_2023,
        COUNT(*) FILTER (
            WHERE date_received >= DATE '2024-01-01'
              AND date_received < DATE '2025-01-01'
        ) AS complaints_2024
    FROM cfpb_analysis_clean
    WHERE date_received >= DATE '2023-01-01'
      AND date_received < DATE '2025-01-01'
    GROUP BY product
)
SELECT
    product,
    complaints_2023,
    complaints_2024,
    complaints_2024 - complaints_2023
        AS complaint_change,
    ROUND(
        100.0 * (
            complaints_2024 - complaints_2023
        ) / NULLIF(complaints_2023, 0),
        2
    ) AS yoy_growth_pct
FROM product_year
ORDER BY complaint_change DESC;
-- Consumer complaint trends shifted significantly between 2023 and 2024. Credit reporting complaints increased by 271.05%, while credit card complaints increased by 211.33% under their respective categories. 
-- Meanwhile, checking or savings account complaints decreased by 18.51%. 
----------------------------------------------------------------
--3. Are companies responding to consumer complaints on time?

SELECT
    timely_response,
    COUNT(*) AS timely_response_count
FROM cfpb_analysis_clean
GROUP BY timely_response
-- 27879 complaints were responded to in a timely manner, while 777 complaints were not responded to in a timely manner. This indicates that the majority of companies are responding to consumer complaints on time.

SELECT
    product,
    COUNT(*) AS product_count
FROM cfpb_analysis_clean
WHERE timely_response = 'No'
GROUP BY product
ORDER BY product_count DESC
-- Checking which products have the most complaints that were not responded to in a timely manner. 
-- Checking or savings accounts have the highest number of complaints that were not responded to in a timely manner, followed by credit cards and Credit reporting.


WITH product_issue AS (
    SELECT
        product,
        issue,
        COUNT(*) AS total_complaint_count
    FROM cfpb_analysis_clean
    GROUP BY product, issue
),

timely_response AS (
    SELECT
        product,
        issue,
        timely_response,
        COUNT(*) AS complaint_count
    FROM cfpb_analysis_clean
    GROUP BY product, issue, timely_response
)

SELECT
    pi.product,
    pi.issue,
    total_complaint_count,
    complaint_count,
    ROUND(100 * tr.complaint_count::NUMERIC / pi.total_complaint_count::NUMERIC, 2) AS timely_response_rate
FROM product_issue pi
LEFT JOIN timely_response tr
    ON pi.product = tr.product AND pi.issue = tr.issue
WHERE tr.timely_response = 'No'
ORDER BY total_complaint_count DESC
-- Checking which product and issue combinations have the highest number of complaints that were not responded to in a timely manner. 


SELECT
    product,
    COUNT(*) AS total_complaints,
    COUNT(*) FILTER (WHERE timely_response = 'Yes') AS timely_responses,
    COUNT(*) FILTER (WHERE timely_response = 'No') AS late_responses,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE timely_response = 'No'
        ) / NULLIF(
            COUNT(*) FILTER (
                WHERE timely_response IN ('Yes', 'No')
            ), 0
        ),
        2
    ) AS late_response_rate_pct
FROM cfpb_analysis_clean
WHERE date_received >= DATE '2023-01-01'
  AND date_received < DATE '2025-01-01'
GROUP BY product
ORDER BY late_responses DESC;
--Checking or savings accounts had the highest number of late responses (364), with a late response rate of 3.27%. 
-- Credit reporting and credit card categories also showed notable response delays, with rates reaching 6.57% and 4.93%

----------------------------------------------------------------
-- INSIGHTS

-- 1. How has consumer complaint volume changed over the past two years?

-- Findings:
-- Consumer complaint volume remained relatively stable between 2023 and 2024, increasing from 14,315 to 14,323 complaints, representing a 0.06% year-over-year increase. Despite stable annual totals, monthly activity experienced significant fluctuations, particularly in July 2023, when complaints increased by 70.25% compared with June.
-- Monthly complaint volume showed less extreme fluctuations in 2024, suggesting more consistent complaint activity throughout the year.

-- Recommendations:
-- Investigate the July 2023 spike to identify which financial products and issues contributed to the increase.
-- Implement monthly complaint monitoring to identify unusual increases and emerging trends before they become recurring problems.

-- 2. Which financial products and issues are driving the most complaints?

-- Findings:
-- Checking or savings accounts generated the most complaints, with 6,206 related to managing an account, making it the largest product-issue combination. Other common complaints involved credit reporting, particularly improper use of consumer reports (1,718 complaints) and incorrect information on reports (1,487 complaints).
-- Although checking or savings account complaints decreased by 18.51% between 2023 and 2024, credit reporting and credit card categories appeared to experience substantial increases. However, changes in product classifications between years may partly explain these differences.

-- Recommendations:
-- Prioritize reviews of account-management processes, including account access, transactions, and dispute handling, to identify recurring problems.
-- Investigate credit reporting accuracy and consumer report usage, focusing on the issues generating the most complaints.
-- Standardize product classifications across reporting years before using category-level growth to determine priorities.

-- 3. Are companies responding to consumer complaints on time?

-- Findings:

-- Bank of America responded to 27,879 out of 28,656 complaints on time, achieving a 97.29% timely response rate. However, 777 complaints were marked as late responses.
-- Checking or savings accounts accounted for the most late responses (364), with a 3.27% late response rate. The older credit reporting and combined credit card/prepaid card categories had relatively high late response rates of 6.57% and 4.93%, respectively.
-- These findings suggest that most recorded complaints received timely responses, but certain product categories experienced more delays than others.

-- Recommendations:

-- Investigate operational bottlenecks associated with late responses, particularly checking or savings account complaints.
-- Monitor late response rates by standardized product category to identify persistent performance gaps.
-- Establish internal response monitoring and escalation procedures for complaints at risk of missing response deadlines.

-- 3 Main recommendations:

-- Improve account-management processes by investigating the most frequently reported consumer problems.
-- Strengthen complaint monitoring to identify unusual volume increases and recurring issues.
-- Reduce response delays by reviewing product categories with high late-response counts or rates.