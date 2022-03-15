

---EXPLORING THE COVID DEATHS TABLE -->

select * from project.dbo.['covid deaths']
where continent is not null

-- Select Data that we are going to be starting with



Select Location, date, total_cases, new_cases, total_deaths, population
From project.dbo.['covid deaths']
Where continent is not null 
order by 1,2


---Shows the likelihood of dying if you contract covid in India

select location,date, total_deaths,total_cases,(total_deaths/total_cases)*100 as Death_percentage
from project.dbo.['covid deaths']
where location = 'India' and 
 continent is not null
order by 1,2


-- Looking at Total Cases vs Population
---Shows what percentage of population in India has got Covid:
---(Higher the percentage, less is the covid infection rate and vice-versa)

select location,date, total_deaths,total_cases,population,(total_cases/population)*100 as Covid_cases_percentage
from project.dbo.['covid deaths']
where continent is not null
and location = 'India'
order by 1,2



-- Looking at countries with the highest covid infection rate
select location,population,max(total_cases) as Highest_infection_count,max((total_cases/population))*100 as Covid_cases_percentage
from project.dbo.['covid deaths']
where continent is not null
group by location,population
order by 4 desc;


-- Showing countries with the highest death count per population

select location,population,max(cast(total_deaths as int)) as Total_death_count
from project.dbo.['covid deaths']
where continent is not null
group by location,population
order by 3 desc;

---Let's break things down by continents:

-- Showing contintents with the highest death count per population


select continent,max(cast(total_deaths as int)) as Total_death_count
from project.dbo.['covid deaths']
where continent is not null
group by continent
order by Total_death_count desc


---Global numbers:

---1.
select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as death_percentage
from project.dbo.['covid deaths']
where continent is not null
--group by date
order by 1,2 ;



--EXPLORING THE COVID VACCINATION TABLE -->

select * from project.dbo.['covid-vaccinations'];


---Joining the two tables

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from project.dbo.['covid deaths'] dea
join project.dbo.['covid-vaccinations'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
and dea.location='Greece'
order by 2,3;


-- Using CTE to perform Calculation on Partition By in previous query



With Popsvsvac(continent,location, date, population,new_vaccinations,Rolling_people_vaccinated)
as

(select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from project.dbo.['covid deaths'] dea
join project.dbo.['covid-vaccinations'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null )
--order by 2,3;

select *, (Rolling_people_vaccinated/population)*100 as Percentage_of_population_vaccinated
from Popsvsvac

-- Using Temp Table to perform Calculation on Partition By in previous query


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From project.dbo.['covid deaths'] dea
Join project.dbo.['covid-vaccinations'] vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating Views


create view PercentagePeopleVaccinated as

(select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from project.dbo.['covid deaths'] dea
join project.dbo.['covid-vaccinations'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null )

select * from PercentagePeopleVaccinated

