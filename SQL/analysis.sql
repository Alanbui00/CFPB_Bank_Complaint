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

-- In 2023, there were 14,315 complaints received, while in 2024, there were 14,323 complaints received. This indicates a slight increase in consumer complaint volume over the past two years.

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
-- Most common issue is managing an accoutn followed by incorrect inforamtion on report and Impropr use of your report

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
-- Checking which products have the most complaints that were not responded to in a timely manner. Checking or savings accounts have the highest number of complaints that were not responded to in a timely manner, followed by credit cards and Credit reporting.


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
