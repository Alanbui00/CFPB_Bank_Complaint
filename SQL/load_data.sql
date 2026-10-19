-- Create the table to store the data
DROP TABLE IF EXISTS cfpb;

CREATE TABLE cfpb (
    Date_received DATE,
    Product VARCHAR(255),
    Sub_product VARCHAR(255),
    Issue VARCHAR(255),
    Sub_issue VARCHAR(255),
    Consumer_complaint_narrative TEXT,
    Company_public_response TEXT,
    Company VARCHAR(255),
    State VARCHAR(225),
    Zip_code VARCHAR(10),
    Tags VARCHAR(255),
    Submitted_via VARCHAR(255),
    Date_sent_to_company DATE,
    Company_response_to_consumer VARCHAR(255),
    Timely_response BOOLEAN,
    Complaint_ID BIGINT PRIMARY KEY
);


-- count the number of rows in the table

SELECT
    COUNT(*)
FROM cfpb

-- See the first 5 rows of the table
SELECT
    *
FROM cfpb
LIMIT 5