SHOW DATABASES;
CREATE DATABASE HEALTH_ANALYSIS;
USE HEALTH_ANALYSIS;

CREATE TABLE HEART_DISEASE (
PATIENT_ID INT AUTO_INCREMENT PRIMARY KEY,
AGE INT,
SEX TINYINT(1),  -- 1=Male, 0=Female
CP INT,  -- chest pain type 0-3
TRESTBPS INT,  -- resting blood pressure
CHOL INT,  -- cholesterol
FBS TINYINT(1),  -- fasting blood sugar >120mg: 1=true
RESTECG INT,  -- resting ECG results
THALACH INT,  -- max heart rate
EXANG TINYINT(1),  -- exercise induced angina
OLDPEAK FLOAT,  -- ST depression
SLOPE INT,  -- slope of peak exercise ST
CA INT,  -- number of major vessels
THAL INT,  -- thalassemia type
CONDITION_ TINYINT(1)  -- 0=No disease, 1=Disease 
);

CREATE TABLE nfhs_districts (
    district_id INT AUTO_INCREMENT PRIMARY KEY,
    district_name VARCHAR(100),
    state_name VARCHAR(100),
    women_bmi_below_normal FLOAT,
    women_overweight FLOAT,
    anaemia_children FLOAT,
    anaemia_women FLOAT,
    women_high_blood_sugar FLOAT,
    men_high_blood_sugar FLOAT,
    women_elevated_bp FLOAT,
    men_elevated_bp FLOAT,
    tobacco_women FLOAT,
    tobacco_men FLOAT
);

-- Count total number of patients in the dataset
SELECT COUNT(*) FROM HEART_DISEASE;

-- How many patients have heart disease vs no heart disease?
SELECT 
    CONDITION_,
    COUNT(*) AS TOTAL,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HEART_DISEASE), 1) AS PERCENTAGE
FROM HEART_DISEASE
GROUP BY CONDITION_;

-- Find all patients who are older than 60
SELECT * 
FROM HEART_DISEASE
WHERE AGE>60;

-- List all unique values of chest pain type (cp)
SELECT DISTINCT CP 
FROM HEART_DISEASE
ORDER BY CP ;

-- Find patients with cholesterol greater than 300
SELECT * 
FROM HEART_DISEASE
WHERE CHOL>300;

-- How many male vs female patients are there?
SELECT 
     CASE
       WHEN SEX = '1' THEN 'MALE'
       WHEN SEX = '0' THEN 'FEMALE'
	END AS GENDER,
    COUNT(*) AS TOATA_PATIENTS,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HEART_DISEASE), 1) ASPERCENTAGE
FROM HEART_DISEASE
GROUP BY SEX;

-- Find the oldest and youngest patient age
SELECT 
    MAX(AGE) AS OLDEST_PATIENT,
    MIN(AGE) AS YOUNG_PATIENT,
    ROUND(AVG(AGE), 1) AS AVERSGE_AGE
FROM HEART_DISEASE;
       
-- List all patients who have fasting blood sugar = 1
SELECT *
FROM HEART_DISEASE
WHERE FBS='1';

-- Find average age, cholesterol and blood pressure grouped by disease status
SELECT 
    CASE 
        WHEN CONDITION_ = 1 THEN 'Has Heart Disease'
        WHEN CONDITION_ = 0 THEN 'No Heart Disease'
    END AS DISEASE_STATUS,
    COUNT(*) AS TOTAL_PATIENTS,
    ROUND(AVG(AGE), 1) AS AVG_AGE,
    ROUND(AVG(CHOL), 1) AS AVG_CHOLESTROL,
    ROUND(AVG(TRESTBPS), 1) AS AVG_BLOOD_PRESSURE,
    ROUND(AVG(THALACH), 1) AS AVG_MAX_HEARTRATE
FROM HEART_DISEASE
GROUP BY CONDITION_;

-- Which chest pain type is most common in heart disease patients?
SELECT CP,
    CASE 
        WHEN CP = 0 THEN 'Typical Angina'
        WHEN CP = 1 THEN 'Atypical Angina'
        WHEN CP = 2 THEN 'Non-Anginal Pain'
        WHEN CP = 3 THEN 'Asymptomatic'
    END AS CHEST_PAIN_TYPE,
    COUNT(*) AS TOTAL_PATIENTS
FROM HEART_DISEASE
WHERE CONDITION_ = 1
GROUP BY CP
ORDER BY TOTAL_PATIENTS DESC;

-- Find all patients above age 50 with cholesterol above 250
SELECT 
    PATIENT_ID, AGE, SEX, CHOL, TRESTBPS, CONDITION_
FROM HEART_DISEASE
WHERE AGE > 50 AND CHOL > 250
ORDER BY CHOL DESC;

-- What is the average max heart rate (thalach) for male vs female patients?
SELECT 
    CASE 
        WHEN SEX = 1 THEN 'Male'
        WHEN SEX = 0 THEN 'Female'
    END AS GENDER,
    COUNT(*) AS TOTAL_PATIENTS,
    ROUND(AVG(THALACH), 1) AS AVG_MAX_HEARTRATE,
    ROUND(MIN(THALACH), 1) AS MIN_HEARTRATE,
    ROUND(MAX(THALACH), 1) AS MAX_HEARTRATE
FROM HEART_DISEASE
GROUP BY SEX;

-- Count patients grouped by age group — Under 40, 40–55, Above 55
SELECT 
    CASE 
        WHEN AGE < 40 THEN 'Under 40'
        WHEN AGE BETWEEN 40 AND 55 THEN '40-55'
        ELSE 'Above 55'
    END AS AGE_GROUP,
    COUNT(*) AS TOTAL_PATIENTS,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HEART_DISEASE), 1) AS PERCENTAGE
FROM HEART_DISEASE
GROUP BY AGE_GROUP
ORDER BY TOTAL_PATIENTS DESC;

-- Find top 5 patients with highest cholesterol
SELECT 
    PATIENT_ID,
    AGE,
    CASE WHEN SEX = 1 THEN 'Male' ELSE 'Female' END AS GENDER,
    CHOL AS CHOLESTEROL,
    TRESTBPS AS BLOOD_PRESSURE,
    CASE WHEN CONDITION_ = 1 THEN 'Yes' ELSE 'No' END AS HAS_HEART_DISEASE
FROM HEART_DISEASE
ORDER BY CHOL DESC
LIMIT 5;

-- How many patients have both high blood pressure (trestbps > 140) AND high cholesterol (chol > 240)?
SELECT 
    COUNT(*) AS HIGH_RISK_PATIENTS,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HEART_DISEASE), 1) AS PERCENTAGE_OF_TOTAL,
    ROUND(AVG(AGE), 1) AS AVG_AGE,
    ROUND(AVG(CHOL), 1) AS AVG_CHOLESTEROL,
    ROUND(AVG(TRESTBPS), 1) AS AVG_BLOOD_PRESSURE
FROM HEART_DISEASE
WHERE TRESTBPS > 140 AND CHOL > 240;

-- Rank patients by cholesterol within each age group using window function
SELECT 
    PATIENT_ID,
    AGE,
    CASE 
        WHEN AGE < 40 THEN 'Under 40'
        WHEN AGE BETWEEN 40 AND 55 THEN '40-55'
        ELSE 'Above 55'
    END AS AGE_GROUP,
    CHOL,
    RANK() OVER (
        PARTITION BY 
            CASE 
                WHEN AGE < 40 THEN 'Under 40'
                WHEN AGE BETWEEN 40 AND 55 THEN '40-55'
                ELSE 'Above 55'
            END 
        ORDER BY CHOL DESC
    ) AS CHOLESTEROL_RANK
FROM HEART_DISEASE;

-- Find the percentage of heart disease patients for each chest pain type
SELECT 
    CP,
    CASE 
        WHEN CP = 0 THEN 'Typical Angina'
        WHEN CP = 1 THEN 'Atypical Angina'
        WHEN CP = 2 THEN 'Non-Anginal Pain'
        WHEN CP = 3 THEN 'Asymptomatic'
    END AS CHEST_PAIN_TYPE,
    COUNT(*) AS TOTAL_PATIENTS,
    SUM(CONDITION_) AS DISEASE_PATIENTS,
    ROUND(SUM(CONDITION_) * 100.0 / COUNT(*), 1) AS DISEASE_PERCENTAGE
FROM HEART_DISEASE
GROUP BY CP
ORDER BY DISEASE_PERCENTAGE DESC;

-- Use a CTE to find patients who are above average age AND have heart disease
WITH AVG_AGE_CTE AS (
    SELECT ROUND(AVG(AGE), 1) AS AVG_AGE
    FROM HEART_DISEASE
)
SELECT 
    H.PATIENT_ID,
    H.AGE,
    H.CHOL,
    H.TRESTBPS,
    A.AVG_AGE
FROM HEART_DISEASE H
JOIN AVG_AGE_CTE A ON H.AGE > A.AVG_AGE
WHERE H.CONDITION_ = 1
ORDER BY H.AGE DESC;

-- Find running total of patients ordered by age using window function
SELECT 
    PATIENT_ID,
    AGE,
    CHOL,
    CONDITION_,
    COUNT(*) OVER (
        ORDER BY AGE
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RUNNING_TOTAL
FROM HEART_DISEASE
ORDER BY AGE;

-- Use CTE to identify high risk patients — age > 55, cholesterol > 250, blood pressure > 140
WITH HIGH_RISK AS (
    SELECT 
        PATIENT_ID,
        AGE,
        CHOL,
        TRESTBPS,
        CASE WHEN SEX = 1 THEN 'Male' ELSE 'Female' END AS GENDER,
        CONDITION_
    FROM HEART_DISEASE
    WHERE AGE > 55 
      AND CHOL > 250 
      AND TRESTBPS > 140
)
SELECT 
    *,
    COUNT(*) OVER() AS TOTAL_HIGH_RISK_PATIENTS
FROM HIGH_RISK
ORDER BY AGE DESC;

-- Find which age group has the highest heart disease rate (%)
SELECT 
    CASE 
        WHEN AGE < 40 THEN 'Under 40'
        WHEN AGE BETWEEN 40 AND 55 THEN '40-55'
        ELSE 'Above 55'
    END AS AGE_GROUP,
    COUNT(*) AS TOTAL_PATIENTS,
    SUM(CONDITION_) AS DISEASE_COUNT,
    ROUND(SUM(CONDITION_) * 100.0 / COUNT(*), 1) AS DISEASE_RATE
FROM HEART_DISEASE
GROUP BY AGE_GROUP
ORDER BY DISEASE_RATE DESC;

-- Compare average cholesterol between patients with and without exercise induced angina (exang)
SELECT 
    CASE 
        WHEN EXANG = 1 THEN 'With Angina'
        WHEN EXANG = 0 THEN 'Without Angina'
    END AS ANGINA_STATUS,
    COUNT(*) AS TOTAL_PATIENTS,
    ROUND(AVG(CHOL), 1) AS AVG_CHOLESTEROL,
    ROUND(AVG(TRESTBPS), 1) AS AVG_BLOOD_PRESSURE,
    ROUND(AVG(AGE), 1) AS AVG_AGE
FROM HEART_DISEASE
GROUP BY EXANG;

-- Find patients whose max heart rate is below average for their gender
WITH GENDER_AVG AS (
    SELECT 
        SEX,
        ROUND(AVG(THALACH), 1) AS AVG_HEARTRATE
    FROM HEART_DISEASE
    GROUP BY SEX
)
SELECT 
    H.PATIENT_ID,
    H.AGE,
    CASE WHEN H.SEX = 1 THEN 'Male' ELSE 'Female' END AS GENDER,
    H.THALACH AS MAX_HEARTRATE,
    G.AVG_HEARTRATE AS GENDER_AVG_HEARTRATE,
    H.CONDITION_
FROM HEART_DISEASE H
JOIN GENDER_AVG G ON H.SEX = G.SEX
WHERE H.THALACH < G.AVG_HEARTRATE
ORDER BY H.THALACH ASC;

-- Create a risk score for each patient:
-- 1. +1 if age > 55
-- 2. +1 if cholesterol > 240
-- 3. +1 if trestbps > 140
-- 4. +1 if fbs = 1
-- 5. Show patients with risk score ≥ 3
SELECT 
    PATIENT_ID,
    AGE,
    CASE WHEN SEX = 1 THEN 'Male' ELSE 'Female' END AS GENDER,
    CHOL,
    TRESTBPS,
    CONDITION_,
    (
        CASE WHEN AGE > 55 THEN 1 ELSE 0 END +
        CASE WHEN CHOL > 240 THEN 1 ELSE 0 END +
        CASE WHEN TRESTBPS > 140 THEN 1 ELSE 0 END +
        CASE WHEN FBS = 1 THEN 1 ELSE 0 END
    ) AS RISK_SCORE
FROM HEART_DISEASE
HAVING RISK_SCORE >= 3
ORDER BY RISK_SCORE DESC;
