# Database Design (Simple, Practical)
## Create Database
CREATE DATABASE cybersecurity_analysis;
USE cybersecurity_analysis;

SELECT * FROM web_traffic;
## Clean
## Executable
## MySQL-friendly

# Data Cleaning
## Remove Duplicates
DESCRIBE web_traffic;

ALTER TABLE web_traffic
ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

DELETE t1
FROM web_traffic t1
JOIN web_traffic t2
ON t1.src_ip = t2.src_ip
AND t1.creation_time = t2.creation_time
AND t1.id > t2.id;

SELECT COUNT(*) FROM web_traffic;

# Standardize Country Codes
UPDATE web_traffic
SET
creation_time = STR_TO_DATE(
    REPLACE(REPLACE(creation_time, 'T', ' '), 'Z', ''),
    '%Y-%m-%d %H:%i:%s'
),
end_time = STR_TO_DATE(
    REPLACE(REPLACE(end_time, 'T', ' '), 'Z', ''),
    '%Y-%m-%d %H:%i:%s'
);

## What this does:
## Removes T
## Removes Z
## Converts text → proper DATETIME
UPDATE web_traffic
SET session_duration = TIMESTAMPDIFF(SECOND, creation_time, end_time);

SELECT creation_time, end_time, session_duration
FROM web_traffic
LIMIT 5;

# Exploratory Data Analysis (EDA)
## Traffic Volume Overview
SELECT 
    COUNT(*) AS total_sessions,
    AVG(bytes_in) AS avg_bytes_in,
    AVG(bytes_out) AS avg_bytes_out
FROM web_traffic;

## Country-Wise Threat Analysis
SELECT 
    src_ip_country_code,
    COUNT(*) AS threat_count
FROM web_traffic
GROUP BY src_ip_country_code
ORDER BY threat_count DESC;

## Port Misuse Detection
SELECT 
    dst_port,
    COUNT(*) AS access_count
FROM web_traffic
GROUP BY dst_port
ORDER BY access_count DESC;

## Suspicious Traffic Ratio
SELECT 
    detection_types,
    COUNT(*) AS count
FROM web_traffic
GROUP BY detection_types;

# Advanced SQL Analysis 
## High-Risk Sessions
SELECT *
FROM web_traffic
WHERE bytes_in > 20000
AND bytes_out < 5000;

# Long Duration Sessions
SELECT *
FROM web_traffic
WHERE session_duration > 600;

# Business Insights
## Traffic anomalies are not random
## Certain countries repeatedly trigger security rules
## HTTPS alone does not guarantee safety
## Session behavior matters more than raw volume
## This is exactly how analysts think in the real world.

# Final Conclusion
## This project demonstrates how SQL alone can uncover cybersecurity threats without relying on black-box models.
## The analysis is transparent, auditable, and production-ready.
## For an intern-level project, this shows:
## Strong SQL fundamentals
## Real-world analytical thinking
## Clean execution
## No overengineering. No fake accuracy numbers. Just solid work.