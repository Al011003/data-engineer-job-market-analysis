/*
what is the most in-demand skills for teh data engineer?
    identified the top 10 in-demand skills for data engineer
    focus on remote job posting
why?
    retrivies the top 10 skills with highest demand in remote 
    job market, providing insight into the most valuable skills for
    data engineers seeking remote work
*/
SELECT
    sd.skills,
    COUNT(jpf.*) AS count
FROM 
    job_postings_fact AS jpf
INNER JOIN 
    skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN 
    skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY 
    sd.skills
ORDER BY 
    count DESC
LIMIT 10;




/*
┌────────────┬───────┐
│   skills   │ count │
│  varchar   │ int64 │
├────────────┼───────┤
│ sql        │ 29221 │
│ python     │ 28776 │
│ aws        │ 17823 │
│ azure      │ 14143 │
│ spark      │ 12799 │
│ airflow    │  9996 │
│ snowflake  │  8639 │
│ databricks │  8183 │
│ java       │  7267 │
│ gcp        │  6446 │
└────────────┴───────┘
  10 rows  2 columns

=============================================================================
INSIGHT: TOP 10 IN-DEMAND SKILLS FOR DATA ENGINEER (REMOTE JOBS)
=============================================================================

KEY FINDINGS
------------
SQL (29,221) and Python (28,776) dominate with an extremely narrow gap
(~1.5%), indicating that both are ABSOLUTE requirements in almost every
remote Data Engineer job posting. These are not "nice-to-haves" —
they are the minimum baseline.

PATTERNS IDENTIFIED
--------------------
1. FOUNDATION (SQL + Python): ~29k postings
   Both skills appear in nearly every job posting. Candidates lacking
   either are practically uncompetitive in the remote market.

2. CLOUD DOMINANCE (AWS > Azure > GCP): 17,823 | 14,143 | 6,446
   AWS is sought nearly 3x more than GCP and still leads Azure by ~25%.
   This mirrors global cloud market share. Notably, all three appear
   separately — companies typically commit to one ecosystem, meaning
   cloud skills tend to be platform-specific.

3. PROCESSING ENGINES (Spark + Airflow): 12,799 | 9,996
   Spark confirms that large-scale data processing remains highly relevant
   in remote roles. Airflow almost always pairs with Spark — one handles
   the processing engine, the other handles pipeline orchestration.
   They complement each other in production environments.

4. MODERN DATA PLATFORMS (Snowflake + Databricks): 8,639 | 8,183
   The presence of both platforms signals an industry shift toward cloud
   data warehouses and lakehouse architectures. Databricks (Spark-based)
   and Snowflake (SQL-first) compete directly, yet both appear with nearly
   identical demand counts — a sign the market has not picked a winner yet.

5. JAVA (7,267): The Interesting Outlier
   The only programming language besides Python to crack the top 10.
   This is no accident — Java is the backbone of many distributed systems
   (Kafka, Hadoop, Flink). Its presence suggests many remote roles require
   engineers who can operate at a lower system level beyond just scripting.

SKILL-BUILDING STRATEGY BASED ON THE DATA
------------------------------------------
For candidates aiming to maximize employability in the remote market:

  Priority 1 (must-have)  : SQL + Python — applications fail without these
  Priority 2 (pick one)   : AWS or Azure — AWS for broader coverage,
                            Azure for enterprise/Microsoft ecosystems
  Priority 3 (pick one)   : Airflow or Spark — Airflow is more accessible
                            for mid-level roles; Spark for big data scale
  Priority 4 (optional)   : Snowflake or Databricks — depends on career
                            direction (cloud DWH vs. lakehouse)

METHODOLOGY NOTE
----------------
The count reflects job postings, not unique companies. A single company
may post multiple positions. Therefore, these numbers represent demand
volume, not breadth of adoption. For job hunting purposes, however,
demand volume is the most actionable metric.

=============================================================================
*/