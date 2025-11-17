SELECT *
FROM layoffs;

-- 1. Remove Duplicates

-- 2. Standardize the Data

-- 3. Look at the Null and Blank Values

-- 4. Remove Any Columns or Rows that are not Necessary 

CREATE TABLE layoffs_staging
	SELECT * 
    FROM layoffs;
;

SELECT * 
FROM layoffs_staging; 

-- REMOVE DUPLICATES --

WITH organized_layoffs AS
(
SELECT  *, ROW_NUMBER() OVER(
PARTITION BY company, 
location, total_laid_off, 
`date`, percentage_laid_off, 
industry, `source`, stage, funds_raised,
country, date_added) AS row_num
FROM layoffs_staging
)
SELECT *
FROM organized_layoffs
WHERE row_num >= 2;

-- Standardizing Data -- 

SELECT company, TRIM(company)
FROM layoffs_staging; 

UPDATE layoffs_staging
SET company = TRIM(company); 

SELECT *
FROM layoffs_staging; 

SELECT DISTINCT(industry)
FROM layoffs_staging;

SELECT *
FROM layoffs_staging 
WHERE industry LIKE '%crypto%'
; 

UPDATE layoffs_staging 
SET industry = 'Crypto' 
WHERE industry LIKE '%crypto%'
;

SELECT DISTINCT(location)
FROM layoffs_staging
ORDER BY 1;

UPDATE layoffs_staging 
SET location = REPLACE(location, ',Non-U.S.','');

UPDATE layoffs_staging 
SET country = 'United Arab Emirates'
WHERE country = 'UAE';

SELECT DISTINCT(country)
FROM layoffs_staging
ORDER BY 1;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging;

UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT *
FROM layoffs_staging; 

ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;

-- Working with Null and Blank Values -- 

SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

SELECT *
FROM layoffs_staging
WHERE industry IS NULL
OR industry = '';

SELECT * 
FROM layoffs_staging 
WHERE company = 'Appsmith';

SELECT *
FROM layoffs_staging AS t1
JOIN layoffs_staging AS t2
	ON t1.company = t2.company 
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging AS t1
JOIN layoffs_staging AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging; 

SELECT funds_raised
FROM layoffs_staging;

ALTER TABLE layoffs_staging
DROP COLUMN `source`;

ALTER TABLE layoffs_staging
DROP COLUMN date_added;

SELECT funds_raised, SUBSTRING(funds_raised, 2)
FROM layoffs_staging; 

UPDATE layoffs_staging
SET funds_raised = SUBSTRING(funds_raised, 2);

UPDATE layoffs_staging
SET funds_raised = NULL
WHERE funds_raised = '';

ALTER TABLE layoffs_staging
MODIFY COLUMN funds_raised INT;


