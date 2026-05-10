/*
what are the optimal skills for data engineer, balancing bot demand and salary

cretae ranking column that combines demand count and median salary to identify
the most valuable skill
focus only on remote data engineer position with spesified annual salaries

why
this approach highlight skill that balance market demand and financial reward
it weught core skills appropriately, rather than letting rare, outlier skill
distort the result
*/

SELECT
    sd.skills,
    COUNT(jpf.*) AS demand_count,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND(LN(COUNT(jpf.*)) * MEDIAN(jpf.salary_year_avg) /1_000_000, 2) AS optimal_scroe
FROM 
    job_postings_fact AS jpf
INNER JOIN 
    skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(sjd.job_id) > 100
ORDER BY
    optimal_scroe DESC
LIMIT 25;

/*
=============================================================================
INSIGHT: OPTIMAL SKILLS FOR DATA ENGINEER — BALANCING DEMAND & SALARY
(LN-weighted scoring, remote positions with specified salary)
=============================================================================

KEY FINDINGS
------------
Unlike the previous two queries that looked at demand and salary separately,
this query finds the sweet spot — skills that score well on BOTH axes
simultaneously. The LN transformation prevents high-demand skills like Python
from completely drowning out high-salary niche skills like Terraform.

TIER BREAKDOWN
--------------
1. TOP TIER — True Optimal Skills (score >= 0.89)
   Terraform (0.97), Python (0.95), SQL (0.91), AWS (0.91), Airflow (0.89)

   Terraform leads despite only 193 postings because its $184k median is
   exceptional — LN(193) * 184,000 still beats LN(1133) * 135,000.
   This is exactly what the scoring is designed to surface: salary premium
   can compensate for lower demand when the gap is large enough.

   Python and SQL are neck-and-neck (0.95 vs 0.91) despite having nearly
   identical demand counts (1133 vs 1128). The $5k salary difference
   between them is what separates the two. In a raw demand ranking, both
   look identical — the LN scoring reveals the nuance.

2. MID TIER — Strong Generalist Skills (score 0.75-0.89)
   Spark, Airflow, Kafka, Snowflake, Kubernetes, Git

   Kafka (0.82) punches above its weight — only 292 postings but $145k
   median. Kubernetes similarly: lowest demand count in this tier (147)
   but $150.5k median keeps it competitive.

   Git (0.75) is the surprise here. It appears because enough companies
   explicitly list it as a required skill and pair it with strong salaries
   — suggesting these are senior or infra-heavy roles.

3. LOWER TIER — Table Stakes Skills (score 0.65-0.75)
   Azure, Java, Scala, Databricks, Redshift, GCP, and others

   Azure (0.79) scores lower than AWS (0.91) despite similar demand —
   the $9k salary gap ($128k vs $137k) is the differentiator. Companies
   paying top dollar tend to run AWS-heavy stacks.

   Scala (0.76) holds its ground with a solid $137k median despite
   relatively niche demand (247 postings). Worth learning if already
   working with Spark.

CROSS-QUERY COMPARISON — THE FULL PICTURE
------------------------------------------
Comparing all three queries reveals a complete strategy:

  Query 1 (demand only)  : SQL, Python, AWS, Azure, Spark...
    → what you NEED to get interviews

  Query 2 (salary only)  : Rust, Terraform, Golang, Spring, Neo4j...
    → what pays the MOST but may limit job options

  Query 3 (this query)   : Terraform, Python, SQL, AWS, Airflow...
    → what gives the BEST RETURN on skill investment

  The overlap between Q1 and Q3 = your core skill stack
  The overlap between Q2 and Q3 = your salary leverage skills

ACTIONABLE SKILL ROADMAP
--------------------------
  Must-have foundation  : Python + SQL (top 2-3 in all three queries)
  Cloud platform        : AWS over Azure (higher salary, strong demand)
  Pipeline tools        : Airflow + Spark (both appear in top 6)
  Salary multiplier     : Terraform (highest ROI per hour of study
                          based on salary premium vs demand tradeoff)
  Stretch goal          : Kafka or Kubernetes (strong salary, growing
                          demand in modern data infrastructure)

METHODOLOGY NOTE
----------------
LN scoring compresses extreme demand values, preventing Python (1133)
from completely dominating Terraform (193). Dividing by 1,000,000 is
cosmetic — it scales scores to a readable 0-1 range without affecting
ranking order. HAVING uses > 100 (not >= 100) so skills with exactly
100 postings are excluded.

=============================================================================
┌────────────┬──────────────┬──────────┬─────────────────┬───────────────┐
│   skills   │ demand_count │  median  │ ln_demand_count │ optimal_scroe │
│  varchar   │    int64     │  double  │     double      │    double     │
├────────────┼──────────────┼──────────┼─────────────────┼───────────────┤
│ terraform  │          193 │ 184000.0 │             5.3 │          0.97 │
│ python     │         1133 │ 135000.0 │             7.0 │          0.95 │
│ sql        │         1128 │ 130000.0 │             7.0 │          0.91 │
│ aws        │          783 │ 137320.0 │             6.7 │          0.91 │
│ airflow    │          386 │ 150000.0 │             6.0 │          0.89 │
│ spark      │          503 │ 140000.0 │             6.2 │          0.87 │
│ snowflake  │          438 │ 135500.0 │             6.1 │          0.82 │
│ kafka      │          292 │ 145000.0 │             5.7 │          0.82 │
│ azure      │          475 │ 128000.0 │             6.2 │          0.79 │
│ java       │          303 │ 135000.0 │             5.7 │          0.77 │
│ scala      │          247 │ 137290.0 │             5.5 │          0.76 │
│ git        │          208 │ 140000.0 │             5.3 │          0.75 │
│ kubernetes │          147 │ 150500.0 │             5.0 │          0.75 │
│ databricks │          266 │ 132750.0 │             5.6 │          0.74 │
│ redshift   │          274 │ 130000.0 │             5.6 │          0.73 │
│ gcp        │          196 │ 136000.0 │             5.3 │          0.72 │
│ nosql      │          193 │ 134415.0 │             5.3 │          0.71 │
│ hadoop     │          198 │ 135000.0 │             5.3 │          0.71 │
│ pyspark    │          152 │ 140000.0 │             5.0 │           0.7 │
│ docker     │          144 │ 135000.0 │             5.0 │          0.67 │
│ mongodb    │          136 │ 135750.0 │             4.9 │          0.67 │
│ go         │          113 │ 140000.0 │             4.7 │          0.66 │
│ r          │          133 │ 134775.0 │             4.9 │          0.66 │
│ github     │          127 │ 135000.0 │             4.8 │          0.65 │
│ bigquery   │          123 │ 135000.0 │             4.8 │          0.65 │
└────────────┴──────────────┴──────────┴─────────────────┴───────────────┘
  25 rows                                                      5 columns
  */