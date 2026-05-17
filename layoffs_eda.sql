/* =========================================================
   SQL EXPLORATORY DATA ANALYSIS PROJECT - LAYOFFS DATASET
   Project Type : Exploratory Data Analysis using MySQL
   Inspired By  : Alex The Analyst
   ========================================================= */


/* =========================================================
   STEP 1: Preview Cleaned Dataset
   ========================================================= */

SELECT *
FROM layoffs_staging2;


/* =========================================================
   STEP 2: Find Maximum Number of Layoffs
   Identifying the highest layoffs recorded in dataset
   ========================================================= */

SELECT MAX(total_laid_off)
FROM layoffs_staging2;


/* =========================================================
   STEP 3: Companies with 100% Layoffs
   Finding companies where all employees were laid off
   ========================================================= */

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


/* =========================================================
   STEP 4: Total Layoffs by Company
   Identifying companies with highest layoffs
   ========================================================= */

SELECT company,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


/* =========================================================
   STEP 5: Find Dataset Date Range
   Checking earliest and latest dates in dataset
   ========================================================= */

SELECT MIN(`date`),
MAX(`date`)
FROM layoffs_staging2;


/* =========================================================
   STEP 6: Total Layoffs by Industry
   Analyzing industries most affected by layoffs
   ========================================================= */

SELECT industry,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


/* =========================================================
   STEP 7: Total Layoffs by Country
   Identifying countries with highest layoffs
   ========================================================= */

SELECT country,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


/* =========================================================
   STEP 8: Total Layoffs by Year
   Analyzing yearly layoffs trends
   ========================================================= */

SELECT YEAR(`date`),
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


/* =========================================================
   STEP 9: Total Layoffs by Company Stage
   Examining layoffs across funding stages
   ========================================================= */

SELECT stage,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


/* =========================================================
   STEP 10: Percentage Layoffs by Company
   Calculating cumulative percentage layoffs
   ========================================================= */

SELECT company,
SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


/* =========================================================
   STEP 11: Monthly Layoffs Trend
   Aggregating layoffs month-wise
   ========================================================= */

SELECT SUBSTRING(`date`, 1, 7) AS `month`,
SUM(total_laid_off)

FROM layoffs_staging2

WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL

GROUP BY `month`

ORDER BY 1 ASC;


/* =========================================================
   STEP 12: Rolling Total of Layoffs
   Calculating cumulative layoffs over time
   ========================================================= */

WITH Rolling_Total AS
(
    SELECT SUBSTRING(`date`, 1, 7) AS `month`,
    SUM(total_laid_off) AS total_off

    FROM layoffs_staging2

    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL

    GROUP BY `month`

    ORDER BY 1 ASC
)

SELECT `month`,
total_off,

SUM(total_off) OVER(ORDER BY `month`) AS rolling_total

FROM Rolling_Total;


/* =========================================================
   STEP 13: Company Layoffs by Year
   Analyzing yearly layoffs for each company
   ========================================================= */

SELECT company,
YEAR(`date`),
SUM(total_laid_off)

FROM layoffs_staging2

GROUP BY company,
YEAR(`date`)

ORDER BY 3 DESC;


/* =========================================================
   STEP 14: Rank Companies by Layoffs Each Year
   Using DENSE_RANK() to rank companies annually
   ========================================================= */

WITH Company_Year (company, years, total_laid_off) AS
(
    SELECT company,
    YEAR(`date`),
    SUM(total_laid_off)

    FROM layoffs_staging2

    GROUP BY company,
    YEAR(`date`)
),

Company_Year_Rank AS
(
    SELECT *,

    DENSE_RANK() OVER (
        PARTITION BY years
        ORDER BY total_laid_off DESC
    ) AS ranking

    FROM Company_Year
)

SELECT *
FROM Company_Year_Rank;