Select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Selecting Some Columns for needed data

Select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2 

--Looking at totals cases vs Total Deaths
--Shows Liklihood of dying if u contract covid in ur country
Select location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
and continent is not null

order by 1,2 

--Looking at Total Cases vs Population
--shows what percentage of population got covid
Select location,date,population,total_cases,(total_cases/population)*100 as PopulationPercentageInfected
from PortfolioProject..CovidDeaths
where continent is not null

--where location like '%states%'
order by 1,2 

--What countries have the highest infection rate compared to populations
Select location,population,MAX(total_cases)as HighestInfectionCount,Max((total_cases/population))*100 as PopulationPercentageInfected
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
Group By location,population
order by PopulationPercentageInfected desc

--showing countries with highest death count per population
Select location, Max(cast(Total_deaths as int))  as TotalDeathCount --case functon is used to convert into integer
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
Group By location
order by TotalDeathCount desc

--LETS BREAK THINGS DOWN BY CONTINENT

Select continent, Max(cast(Total_deaths as int))  as TotalDeathCount --case functon is used to convert into integer
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
Group By continent
order by TotalDeathCount desc

--Showing the continents wit the highest death count per population


Select continent, Max(cast(Total_deaths as int))  as TotalDeathCount --case functon is used to convert into integer
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
Group By continent
order by TotalDeathCount desc



--Global numbers accross the world

Select SUM(new_cases) as totalcases,SUM(cast(new_Deaths as int)) as totaldeaths ,SUM(cast(new_Deaths as int))/Sum((New_cases))*100 as DeathPercentage   --,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2 

--Look at total population vs vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
,SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

With PopvsVac (Continent,Location , Data , Population ,New_Vacconations, RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
,SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select * , (RollingPeopleVaccinated/Population)*100
from PopvsVac


----TEMP TABLE

--Create Table  #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Data datetime,
--Population numeric,
--New_Vaccinations numeric ,
--RollingPeopleVaccinated numeric
--)
--Insert into #PercentPopulationVaccinated
--select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
--,SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated 
----,(RollingPeopleVaccinated/population)*100
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
----order by 2,3
--Select * , (RollingPeopleVaccinated/Population)*100
--from  #PercentPopulationVaccinated