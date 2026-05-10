/*
what are the highest-paying skills for data engineer?
calculate median salary for each skill required in data engineer position
focus on remote position with spesified salaries
include skill frequency to identify both salary and demand
where thw skill is more than 100 demand

why?
to identify  which skills command the highest compensation
while also showing how common those skill are, providing and more
complete pictures for skills devlopment skills

the median is used instead of the average to reduce the impact of the
outliers salary
*/

SELECT
     sd.skills,
     COUNT(jpf.*) AS count,
     ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median
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
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(sd.skills) > 100
ORDER BY
    median DESC
LIMIT 25;

/*
/*
=============================================================================
INSIGHT: HIGHEST-PAYING SKILLS FOR DATA ENGINEER (REMOTE JOBS)
=============================================================================

KEY FINDINGS
------------
This query shifts perspective from the previous one — instead of asking
"what skills are most in demand?", it asks "which skills pay the most?"
The results reveal a very different skill set at the top.

TIER BREAKDOWN
--------------
1. PREMIUM NICHE (>$180k median): Rust, Terraform, Golang
   These three sit at the very top despite relatively low demand counts.
   - Rust (232 postings, $210k): Highest-paying skill in the entire list.
     Rust signals systems-level programming — performance-critical pipelines,
     low-latency infrastructure. Rare but exceptionally well-compensated.
   - Terraform ($184k) and Golang ($184k): Both tied at #2. Terraform reflects
     Infrastructure-as-Code maturity; Golang powers high-performance backend
     services (Kubernetes itself is written in Go). Companies that need these
     are building serious distributed infrastructure.

2. SPECIALIZED BACKEND ($165k-$175k): Spring, Neo4j, GDPR, GraphQL
   - Spring ($175.5k): Java framework presence here confirms the Java outlier
     from the previous query. Enterprise-grade backend engineering commands
     a significant premium.
   - Neo4j ($170k): Graph database expertise is scarce and highly valued —
     typically used for recommendation systems and fraud detection.
   - GDPR ($169k): Surprisingly high. This reflects compliance engineering
     demand, particularly from US companies with European operations. A
     non-technical skill that commands technical-level pay.
   - GraphQL ($167.5k): Modern API layer increasingly used in data mesh
     architectures, pushing salary above many traditional data tools.

3. INFRASTRUCTURE & DEVOPS ($148k-$155k): Kubernetes, Ansible, VMware,
   Bitbucket, Atlassian
   Kubernetes (4,202 postings, $150.5k) stands out here as the sweet spot —
   high demand AND strong compensation. It's the most "safe bet" skill
   in this list, balancing both axes.

4. THE AIRFLOW PARADOX: 9,996 postings — $150k median
   Airflow was #6 in demand from the previous query, yet here it sits at
   the bottom of the top 25 by salary. This is not a bad thing — it means
   Airflow is a widely expected baseline skill rather than a premium
   differentiator. You need it to get in the door, but it won't make
   you stand out on compensation alone.

DEMAND vs. SALARY TENSION
--------------------------
The key tension in this data: high salary does not equal high demand,
and vice versa. This splits skills into four strategic quadrants:

  HIGH salary + LOW demand  : Rust, Golang, Neo4j, GraphQL
    → Specialist track. Harder to find roles, but premium compensation.

  HIGH salary + HIGH demand : Terraform, Kubernetes
    → Best of both worlds. Strong ROI for skill investment.

  LOW salary + HIGH demand  : SQL, Python, Airflow (from prev query)
    → Table stakes. Required to be employable, not to be well-paid.

  LOW salary + LOW demand   : Everything below this list
    → Avoid prioritizing these for career development.

COUNTERINTUITIVE FINDINGS
--------------------------
- Zoom ($168k, 127 postings): Presence in this list is unusual. Likely
  reflects a specific cluster of high-paying companies using Zoom's API
  for video data pipelines or communication infrastructure.
- Crystal ($154k, 129 postings): An emerging systems language similar to
  Ruby in syntax but compiled like C. Its salary premium reflects extreme
  rarity of practitioners, not wide adoption.
- CSS ($150k, 262 postings): CSS in a Data Engineer salary list is
  unexpected. Likely tied to full-stack data engineers building internal
  tools or dashboards who command a premium for broader versatility.

STRATEGIC RECOMMENDATION
------------------------
If goal = maximize salary ceiling  → Invest in Rust, Golang, Terraform
If goal = maximize job optionality → Invest in Kubernetes, Terraform
If goal = balance both             → Terraform is the single best ROI skill
                                     in this entire dataset (3,248 postings
                                     at $184k median)


┌────────────┬───────┬──────────┐
│   skills   │ count │  median  │
│  varchar   │ int64 │  double  │
├────────────┼───────┼──────────┤
│ rust       │   232 │ 210000.0 │
│ terraform  │  3248 │ 184000.0 │
│ golang     │   912 │ 184000.0 │
│ spring     │   364 │ 175500.0 │
│ neo4j      │   277 │ 170000.0 │
│ gdpr       │   582 │ 169616.0 │
│ zoom       │   127 │ 168438.0 │
│ graphql    │   445 │ 167500.0 │
│ mongo      │   265 │ 162250.0 │
│ fastapi    │   204 │ 157500.0 │
│ bitbucket  │   478 │ 155000.0 │
│ django     │   265 │ 155000.0 │
│ crystal    │   129 │ 154224.0 │
│ c          │   444 │ 151500.0 │
│ atlassian  │   249 │ 151500.0 │
│ typescript │   388 │ 151000.0 │
│ kubernetes │  4202 │ 150500.0 │
│ node       │   179 │ 150000.0 │
│ ruby       │   736 │ 150000.0 │
│ airflow    │  9996 │ 150000.0 │
│ css        │   262 │ 150000.0 │
│ redis      │   605 │ 149000.0 │
│ vmware     │   136 │ 148798.0 │
│ ansible    │   475 │ 148798.0 │
│ jupyter    │   400 │ 147500.0 │
└────────────┴───────┴──────────┘

=============================================================================
*/