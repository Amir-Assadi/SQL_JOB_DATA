/* 
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely or UK.
- Focuses on job postings with specified salaries(either salary per year or 
  hourly rate times 48 week 40 hours per week)(remove nulls).
*/
WITH title_location_salary AS(
        SELECT 
            job_title_short AS title,
            job_location AS location,
            salary_year_avg,
            salary_hour_avg,
            salary_rate

        FROM job_postings_fact
        WHERE 
            (job_title_short ILIKE '%Data Analyst%') AND
            (
                (salary_year_avg IS NOT NULL) OR
                ((salary_rate IS NOT NULL) AND (salary_hour_avg IS NOT NULL))
            ) AND
            ((job_location ~* '\mUK\M') OR (job_location ILIKE '%Anywhere%'))
)

SELECT
      title,
      location,
      CASE
          WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
          ELSE salary_hour_avg * 40 * 48
      END AS salary
FROM title_location_salary
--WHERE location ~* '\mUK\M' -- for only uk 
ORDER BY salary DESC 
LIMIT 10  
/*
-- looking at the data only 10% of the data is from UK so we ignore UK jobs for the next sections
   and looking only at the yearly salary to remove the working hour assumption for the hourly paid jobs.