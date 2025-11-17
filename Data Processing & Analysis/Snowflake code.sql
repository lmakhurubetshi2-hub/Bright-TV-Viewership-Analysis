
  -- Data Exploration -- Check all columns and datatypes in the data 
  -- Userprofile table 
  SELECT * FROM CASESTUDY2.BRIGHT_TV.USERPROFILES LIMIT 10; 
  -- Viewerships table 
  SELECT * FROM CASESTUDY2.BRIGHT_TV.VIEWERSHIP LIMIT 10;
-------------------------------------------------------------------------------------------------------

    SELECT *
FROM CASESTUDY2.BRIGHT_TV.VIEWERSHIP;

SELECT COUNT(*)
FROM CASESTUDY2.BRIGHT_TV.VIEWERSHIP;


-------------------------------------------------------------------------------------------------------
--Final Code 

WITH Cleaned AS (

SELECT 
       A.userid,
      CONCAT_WS(' ', A.name,A.surname) AS Full_Name,
      IFNULL(A.gender,'None') as gender,
      IFNULL(A.race,'Other') as race, 
      A.age,
      IFNULL(A.province,'None') as province,
      IFNULL(B.channel2,'None') as channel2,
       
      IFNULL(B.recorddate2,'No DateTime') as recorddate2,
       
       
      DATE_TRUNC('minute',TO_TIMESTAMP(recorddate2,'YYYY/MM/DD HH24:MI')) AS converted_datetime,       
       
     DATE_TRUNC('minute',DATEADD(hour, 2, TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI'))) AS sa_time,
     CAST(DATEADD(hour, 2, TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI')) AS TIME) AS sa_time_only,
     DAYNAME(TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI')) AS day_name,
     MONTHNAME(TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI')) AS month_name,
 
      IFNULL(B.duration2,'00:00:00') as duration2,    

     CASE
        WHEN age BETWEEN 12 AND 17 THEN 'Early Teen'
        WHEN age BETWEEN 18 AND 24 THEN 'Young Adult'
        WHEN age BETWEEN 25 AND 34 THEN 'Adult'
        WHEN age BETWEEN 35 AND 44 THEN 'Mature Adult'
        WHEN age BETWEEN 45 AND 55 THEN 'Middle Aged'
        ELSE 'Out of Range' 
     END AS age_classification,
     
    ROW_NUMBER() OVER (PARTITION BY A.userid, B.channel2, B.recorddate2 ORDER BY A.userid) AS row_num,
       
FROM CASESTUDY2.BRIGHT_TV.USERPROFILES A
LEFT JOIN CASESTUDY2.BRIGHT_TV.VIEWERSHIP B ON A.userid = B.userid

     )

    SELECT *
    FROM Cleaned
    WHERE row_num = 1
    ORDER BY userid;   

