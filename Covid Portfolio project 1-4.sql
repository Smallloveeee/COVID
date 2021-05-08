SELECT location, date, total_cases, new_cases, total_deaths, population

from CovidDeaths

where continent is not null

order by 1, 2



--- Посмотрим, какой процент заразившихся людей умерли в России (округлен до тысячных)





SELECT location, date, total_cases, total_deaths, 

round(((total_deaths / total_cases) * 100), 3) as DeathPercentage

FROM CovidDeaths

WHERE location like 'Russia'

ORDER by 1, 2





-- Посмотрим на процент случаев заражения от населения России (округлен до тысячных)



SELECT location, date, population, total_cases,

round(((total_cases / population) * 100), 3) as CasePercentage

FROM CovidDeaths

WHERE location like 'Russia'

ORDER by 1, 2





-- Посмотрим на самые высокие проценты заражения за все время по странам



SELECT location, population, 

max(total_cases) as HighestInfectionCount,

MAX((total_cases / population) * 100) as MaxCasePercentage

FROM CovidDeaths

where continent is not null

GROUP by location, population

ORDER by MaxCasePercentage DESC





-- Посмотрим на самые высокие проценты смертности по странам



SELECT location, cast(population as int), 

max(CAST(total_deaths as INT)) as HighestDeathCount,

MAX((total_deaths / population) * 100) as MaxDeathPercentage

FROM CovidDeaths

where continent is not null

GROUP by location, population

ORDER by MaxDeathPercentage DESC





--Посмотрим на общее количество смертей по континентам



SELECT continent, max(CAST(total_deaths as INT)) as MaxDeath

FROM CovidDeaths

WHERE continent is not NULL

group by continent

ORDER by MaxDeath DESC





-- Мировые показатели



SELECT 

sum(new_cases) as World_total_cases,

sum(CAST(new_deaths as int)) as World_total_deaths,

((sum(CAST(new_deaths as int))) / sum(new_cases)) * 100 as World_rate_death 

from CovidDeaths

where continent is not NULL





-- CovidDeaths&amp;CovidVaccinations: Общее количество вакцинированных + процент вакцинированных от населения (по дням и странам)



SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,

sum(CAST(new_vaccinations as int)) over (PARTITION by dea.location order by dea.location, dea.date) 

as RollingPeopleVaccinated,

((sum(CAST(new_vaccinations as int)) over (PARTITION by dea.location order by dea.location, dea.date) ) / dea.population) * 100 as PercantageOfVaccinatedPeople

FROM CovidDeaths dea

JOIN CovidVaccinations vac

	On dea.location = vac.location

	AND dea.date = vac.date

where dea.continent is not NULL

ORDER by 2, 3





-- USE CTE: вацинированные люди, процент от населения (по странам за весь период времени)



WITH PopVSVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)

as 

(

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,

sum(CAST(new_vaccinations as int)) over (PARTITION by dea.location order by dea.location, dea.date) 

as RollingPeopleVaccinated

FROM CovidDeaths dea

JOIN CovidVaccinations vac

	On dea.location = vac.location

	AND dea.date = vac.date

where dea.continent is not NULL

)

SELECT continent, location, population, max(RollingPeopleVaccinated) as TotalVaccinatedPeople,

(RollingPeopleVaccinated / population) * 100 as VaccinatedPeopleRate

FROM PopVsVac

GROUP by location





-- Creating view to store data for later visualization



CREATE VIEW PercentagePeopleVaccinated as

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,

sum(CAST(new_vaccinations as int)) over (PARTITION by dea.location order by dea.location, dea.date) 

as RollingPeopleVaccinated,

((sum(CAST(new_vaccinations as int)) over (PARTITION by dea.location order by dea.location, dea.date) ) / dea.population) * 100 as PercantageOfVaccinatedPeople

FROM CovidDeaths dea

JOIN CovidVaccinations vac

	On dea.location = vac.location

	AND dea.date = vac.date

where dea.continent is not NULL


