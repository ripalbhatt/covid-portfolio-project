select*from [PortFolio Project]..[covid Deaths]
where continent is not null
order by 3,4;
--select*
--from [PortFolio Project]..[covid vaccination]
--order by 3,4;

--select data that we are going to be used 
select location,date,total_cases,new_cases,total_deaths,population
from [PortFolio Project]..[covid Deaths]
order by 1,2

--looking at total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from [PortFolio Project]..[covid Deaths]
where location like '%states%'
order by 1,2
--looking at total cases vs population 

select location,date,Population,total_cases,(total_deaths/population)*100 as deathpercentage
from [PortFolio Project]..[covid Deaths]
--where location like '%states%'
order by 1,2

--looking at countries highest infection rate compared to population 
select location,Population,max(total_cases) as highestinfectioncount,max((total_deaths/population))*100 as percentagepopulationinfected
from [PortFolio Project]..[covid Deaths]
--where location like '%states%'
group by location,population
order by percentagepopulationinfected desc

-- showing countries hightest death count per population
select location,max(cast(total_deaths as int)) as totaldeathcount
from [PortFolio Project]..[covid Deaths]
--where location like '%states%'
where continent is not null
group by location
order by totaldeathcount desc

--LETS'S BREAK THINGS BY CONTINENT

select Location ,max(cast(total_deaths as int)) as totaldeathcount
from [PortFolio Project]..[covid Deaths]
--where location like '%states%'
where continent is null
group by location
order by totaldeathcount desc

--showing the continents with the highest deathcounts per popuation

select continent,max(cast(total_deaths as int)) as totaldeathcount
from [PortFolio Project]..[covid Deaths]
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc


-- GLOBAL NUMBERS
SELECT  sum(new_cases) as total_cases,sum( cast( new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_Cases)* 100 as deathpercentage 
from [PortFolio Project]..[covid Deaths]
--where location like '%state%'
where continent is not  null 
--group by date 
 order by 1,2
 -- looking at total population vs vaccinated

 select dea.continent, dea. location,dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
 from [PortFolio Project]..[covid Deaths] dea 
 join [PortFolio Project]..[covid vaccination] vac
  on dea.location= vac.location
  and dea.date=vac.date
  where dea.continent is not  null
  order by 1,2,3

  --temp table 
  drop table if exists  #percentagepopulationvaccianted
  create table #percentagepopulationvaccinated
  (
  continent varchar (255),
  Location nvarchar(255),
  Date datetime,
  poplutiaon numeric ,
  new_vacciantions numeric,
  rollingpeoplevaccinated numeric,
  )

  Insert into #percentpoplutionvaccianted
 select dea.continent, dea. location,dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
 from [PortFolio Project]..[covid Deaths] dea 
 join [PortFolio Project]..[covid vaccination] vac
  on dea.location= vac.location
  and dea.date=vac.date
  where dea.continent is not  null
-- order by 2,3

  select*,(rollingpeoplevaccianted/population)*100
  from #percentpopolationvaccianted

--  creating view to store data for later visulizations

create view percentagepopulationvaccianted as
select dea.continent, dea. location,dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
 from [PortFolio Project]..[covid Deaths] dea 
 join [PortFolio Project]..[covid vaccination] vac
  on dea.location= vac.location
  and dea.date=vac.date
  where dea.continent is not  null
-- order by 2,3

select*
from percentagepopulationvaccianted