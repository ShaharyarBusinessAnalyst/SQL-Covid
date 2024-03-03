Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PorfolioProject.. covid_deaths$
where location like '%states%'
order by 1,2

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject.. covid_deaths$
Group by location, Population
order by 1,2

--countries with highest death count per pop
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PorfolioProject.. covid_deaths$
where continent is not null
Group by location
order by 2 desc

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PorfolioProject.. covid_deaths$
where location like '%states%'
order by 1,2


-- CTE
With PopvsVac(Continent,Location, Date, Population, New_Vaccinations, RolllingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date)
as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From PorfolioProject..covid_deaths$ dea
Join PorfolioProject..covid_vaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

SELECT *, (RolllingPeopleVaccinated/Population)*100 as PercentagePeopleVaccinated
From PopvsVac


