-- check for duplicates in the table
SELECT
    Complaint_ID,
    COUNT(*)
FROM cfpb
GROUP BY Complaint_ID
HAVING COUNT(*) > 1
-- no duplicates found

-- check for null values in the table
SELECT
    COUNT(*)
FROM cfpb
WHERE
    Date_received IS NULL OR
    Product IS NULL OR
    Sub_product IS NULL OR
    Issue IS NULL OR
    Sub_issue IS NULL OR
    Consumer_complaint_narrative IS NULL OR
    Company_public_response IS NULL OR
    Company IS NULL OR
    State IS NULL OR
    Zip_code IS NULL OR
    Tags IS NULL OR
    Submitted_via IS NULL OR
    Date_sent_to_company IS NULL OR
    Company_response_to_consumer IS NULL OR
    Timely_response IS NULL OR
    Complaint_ID IS NULL
-- there are 1370 null values

CREATE OR REPLACE VIEW cfpb_analysis AS
SELECT
    complaint_id,
    date_received,
    product,
    issue,
    company,
    timely_response,
    state
FROM cfpb;

-- checking where null values are located in the table
SELECT
    SUM(CASE WHEN date_received IS NULL THEN 1 ELSE 0 END) AS date_received_nulls,
    SUM(CASE WHEN product IS NULL THEN 1 ELSE 0 END) AS product_nulls,
    SUM(CASE WHEN issue IS NULL THEN 1 ELSE 0 END) AS issue_nulls,
    SUM(CASE WHEN company IS NULL THEN 1 ELSE 0 END) AS company_nulls,
    SUM(CASE WHEN timely_response IS NULL THEN 1 ELSE 0 END) AS timely_response_nulls,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM cfpb_analysis
-- consumer_complaint_narrative has the most null values with 13730


SELECT
    *
FROM cfpb_analysis
LIMIT 10

-- Checking for duplicates complaint_id
SELECT
    complaint_id,
    COUNT(*)
FROM cfpb_analysis
GROUP BY complaint_id
HAVING COUNT(*) > 1

-- Date range for data
SELECT
    MIN(date_received) AS min_date,
    MAX(date_received) AS max_date
FROM cfpb_analysis
-- 2 years of data from 2023-01-01 to 2025-01-01

-- product
SELECT
    product,
    COUNT(*) AS product_count
FROM cfpb_analysis
GROUP BY product
ORDER BY product_count 


-- issue
SELECT
    issue,
    COUNT(*) AS issue_count
FROM cfpb_analysis
GROUP BY issue
ORDER BY issue_count 

-- company
SELECT
    company,
    COUNT(*) AS company_count
FROM cfpb_analysis
GROUP BY company
ORDER BY company_count DESC

-- timely response
SELECT
    timely_response,
    COUNT(*) AS timely_response_count
FROM cfpb_analysis
GROUP BY timely_response


-- state
SELECT
    state,
    COUNT(*) AS state_count
FROM cfpb_analysis
GROUP BY state
ORDER BY state_count DESC

SELECT
    COUNT(DISTINCT state) AS distinct_states
FROM cfpb_analysis

