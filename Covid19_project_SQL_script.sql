--This is a guided data exploration project by Alex the Data analyst on covid 19 deaths using SQl server, 
--I tried to draw relationships between deaths
--and vaccinations to see the 
--effectiveness of these vaccinations 
--date 9/3/2022 
--project manager: HC
--start with selecting the data we are going to be using 

--SELECT location,
--date,
--total_cases,
--new_cases,
--total_deaths, 
--population  
--FROM data_analyst_project..covid_death_data
--ORDER BY 1,2


SELECT*
FROM data_analyst_project..covid_death_data
WHERE continent IS NOT NULL 
order by 3,4



--SELECT *
--FROM data_analyst_project..covid_vaccinations
--ORDER BY 3,4 


-- Examine total cases vs total death to see percentage of 
--people that died form the disease 
SELECT location,
date,
total_cases,
total_deaths, 
(total_deaths/total_cases)*100 AS death_rate,
population  
FROM data_analyst_project..covid_death_data
WHERE location ='United States'
ORDER BY 1,2
-- The above query looked at the change of death rate in USA
--looks at how likely an individual
--can die from infecting Covid-19



--look at total cases by population 
SELECT population, 
date,
location,
total_cases, 
(total_cases/population)*100 AS percentage_infection -- create a field with percentage infection 
FROM  data_analyst_project..covid_death_data
WHERE location LIKE '%States'
ORDER BY 1,2





--Then we are going to look at 
--countries with hihgest infection rate
SELECT population, 
location,
max(total_cases) as highest_case,
max(total_cases/population)*100 AS percentage_infection
FROM  data_analyst_project..covid_death_data
GROUP BY location,population
ORDER BY percentage_infection desc



----see which country had the most deaths 
--here I am casting the total_death as an interger 
SELECT max(CAST (total_deaths AS int) ) AS highest_death_count, 
location
FROM data_analyst_project..covid_death_data
WHERE continent IS NOT NULL 
GROUP BY location --have to group the column that is not in the aggregate function
order by highest_death_count desc


--see which continent had the most death 

SELECT max(CAST (total_deaths AS int) ) AS highest_death_count, 
location
FROM data_analyst_project..covid_death_data
WHERE continent IS NULL 
GROUP BY location--have to group the column that is not in the aggregate function
order by highest_death_count desc
-- ok, this data set had income level in location columns, 
--which shows this is an uncleaned data set 
--income level should not apprear in the location section
--to get rid of them try using where caluse to filter out this unwanted income 



-- Looking at how totals cases accumlated in the world as 
--time progresses 
SELECT 
date,
SUM(new_cases) as total_Cases,
SUM(CAST(new_deaths AS float)) as total_deaths,
SUM(CAST(new_deaths AS float)) /SUM(new_cases)*100 as death_percentage 
FROM data_analyst_project..covid_death_data
GROUP BY date
HAVING  SUM(new_cases) is not null AND SUM(CAST(new_deaths AS float))  is not null AND SUM(new_cases) !='0'
ORDER BY date asc

--basically I was dividing the total deaths with total cases to 
--get death rate percentage
--having clause adding conditions to eliminate null and avoid 
--dividing by zero 

--want to see total death rate until now  
SELECT 
SUM(new_cases) as total_Cases,
SUM(CAST(new_deaths AS float)) as total_deaths,
SUM(CAST(new_deaths AS float)) /SUM(new_cases)*100 as death_percentage 
FROM data_analyst_project..covid_death_data
HAVING  SUM(new_cases) is not null AND SUM(CAST(new_deaths AS float))  is not null AND SUM(new_cases) !='0'


--joining table to see vaccinations as date progresses
--summing vaccination by location to see how many vaccinations 
--to date , 
--first casting the vaccinations to float data type 
--then using windwo summing vaccination type
--partition by location 
--to see total vaccinations by different countries 

SELECT 
dea.continent,
dea.date,
dea.location,
dea.population,
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER(partition by vac.location ORDER BY dea.location,dea.date) as total_vaccination 
FROM data_analyst_project..covid_death_data as dea
inner join 
data_analyst_project..covid_vaccinations as vac
ON dea.location=vac.location
and dea.date=vac.date
WHERE dea.continent IS NOT NULL and new_vaccinations is not null
ORDER BY 1,2,3

--next look at rolling vaccinations vs population 
--USE CTE


--I would like to use the rolling vaccination count
--versus population ,but I could not directly do calcualtion 
--with the alias 
--so I am creating a CTE a temporary result set to store the 
--results of the inner query. 
--this way I can treat it as a new column in my CTE



WITH  Popvsvac
(continent, 
date,location,
population, 
new_vaccinations, total_vaccination) 
as
(SELECT 
dea.continent,
dea.date,
dea.location,
dea.population,
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER(partition by vac.location ORDER BY dea.location,dea.date) as rolling_vaccination
FROM data_analyst_project..covid_death_data as dea
inner join 
data_analyst_project..covid_vaccinations as vac
ON dea.location=vac.location
and dea.date=vac.date
WHERE dea.continent IS NOT NULL and new_vaccinations is not null)

SELECT *, total_vaccination/population*100 AS vaccination_percentage
FROM Popvsvac

--create view for data visualization later 
CREATE VIEW
percentPopulationVaccinated
AS 
SELECT 
dea.continent,
dea.date,
dea.location,
dea.population,
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER(partition by vac.location ORDER BY dea.location,dea.date) as rolling_vaccination
FROM data_analyst_project..covid_death_data as dea
inner join 
data_analyst_project..covid_vaccinations as vac
ON dea.location=vac.location
and dea.date=vac.date
WHERE dea.continent IS NOT NULL and new_vaccinations is not null




