Select *
	From PortfolioProject..covidDeaths
	order by  3,4

	--Select *
	--From PortfolioProject..covidVaccinations
	--order by  3,4


	Select Location, date, total_cases, new_cases, total_deaths, population
	From PortfolioProject..covidDeaths
	order by  1,2


	-- Looking at Total Cases vs Population
	-- Shows what percentage of populatoin got covid

	Select Location, date, total_cases, Population, (total_cases/ Population)*100 as PercentagePopulationInfected
	From PortfolioProject..covidDeaths
	Where location like '%states%'
	order by  1, 2

	-- Looking at countries with highest infection rTE COMPred to population

	Select Location, MAX(total_cases) as HighestInfectuionCount, Population, MAX((total_cases/ Population))*100 as PercentagePopulationInfected
	From PortfolioProject..covidDeaths
	--Where location like '%states%'
	Group by Location, Population
	order by  PercentagePopulationInfected desc

	--Showing Countries w Highest Death Count per population

	Select Location, MAX(cast(total_deaths as bigint)) as HighestDeathount, Population, MAX((total_deaths/ Population))*100 as PercentagePopulationDead
	From PortfolioProject..covidDeaths
	--Where location like '%states%'
	Group by Location, Population
	order by  PercentagePopulationDead desc

	-- Showing continents with the highest death count per population

	Select continent, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
	From PortfolioProject..covidDeaths
	--Where location like '%states%'
	Where continent is not null
	Group by continent
	order by  TotalDeathCount desc

	-- GLOBAL NUMBERS

		Select  SUM(new_cases),SUM(cast(new_deaths as bigint)), SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
	From PortfolioProject..covidDeaths
	--Where location like '%states%'
	where continent is not null
	--Group by date
	order by  1, 2

	Select * 
	From PortfolioProject..covidDeaths dea
	join PortfolioProject..covidVaccinations vac
		On dea.location=vac.location
		and dea.date=vac.date

	-- Looking at Total Population vs Vaccinations

	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollingpeopleVaccinated
	From PortfolioProject..covidDeaths dea
	join PortfolioProject..covidVaccinations vac
		On dea.location=vac.location
		and dea.date=vac.date
	where dea.continent is not null
	order by 2,3

	--USE CTE

	With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
	as
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollingpeopleVaccinated
	From PortfolioProject..covidDeaths dea
	join PortfolioProject..covidVaccinations vac
		On dea.location=vac.location
		and dea.date=vac.date
	where dea.continent is not null
	)
	Select * ,(RollingPeopleVaccinated/Population)*100
	From PopvsVac


	--  TEMP TABLE
	DROP Table if exists #PercentPopulationVaccinated
	Create Table #PercentPopulationVaccinated
	(
	continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	insert into #PercentPopulationVaccinated
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollingpeopleVaccinated
	From PortfolioProject..covidDeaths dea
	join PortfolioProject..covidVaccinations vac
		On dea.location=vac.location
		and dea.date=vac.date
	where dea.continent is not null
	Select * ,(RollingPeopleVaccinated/Population)*100
	From #PercentPopulationVaccinated

	--Creating view to store data for later visualizations

	Create view PercentPopulationVaccinated as
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollingpeopleVaccinated
	From PortfolioProject..covidDeaths dea
	join PortfolioProject..covidVaccinations vac
		On dea.location=vac.location
		and dea.date=vac.date
	where dea.continent is not null

	Select *
	From PercentPopulationVaccinated

	







	

	
