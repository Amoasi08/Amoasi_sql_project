-- Selecting some data to work on it 
SELECT continent, 
	location,
    total_cases,
    new_cases, total_deaths,
    population
FROM project_work.covid_data
ORDER BY location, total_cases;

-- Looking at the Total Cases vs Population
-- Shows the percentage of the population that have gotten covid
SELECT continent, 
	location,
    total_cases,
	population,
    (total_cases/population)*100 AS TotalCase_Percentage
FROM project_work.covid_data
WHERE location like 'South Africa'
ORDER BY location, total_cases;


-- Looking at the Total Cases vs Total Deaths
-- This show the likihood that you will die when you extract covid
-- The case study is Ghana
SELECT continent, 
	location,
    total_cases,
	total_deaths,
    (total_deaths/total_cases)*100 AS Death_Percentage
FROM project_work.covid_data
WHERE location like 'Ghana'
ORDER BY location, total_cases;

-- Looking for the country with the highest Total Cases
SELECT location, population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM project_work.covid_data
WHERE continent != ''
GROUP BY location, population
ORDER BY HighestInfectionCount DESC;

-- Grouping covid death cases by continent
SELECT location,
    MAX(CAST(total_deaths as float)) as HighestDeathCount
FROM project_work.covid_data
WHERE continent = '' AND location NOT LIKE 'high income' AND location NOT LIKE 'low income'
GROUP BY location
ORDER BY HighestDeathCount desc;