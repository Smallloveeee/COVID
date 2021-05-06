<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="C:\Users\Люба\Desktop\Portfolio project 1-4.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="150"/><column_width id="3" width="8385"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><current_table name="4,11:mainCovidDeaths"/><default_encoding codec=""/><browse_table_settings><table schema="main" name="CovidDeaths" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="105"/><column index="2" value="108"/><column index="3" value="112"/><column index="4" value="109"/><column index="5" value="134"/><column index="6" value="126"/><column index="7" value="123"/><column index="8" value="235"/><column index="9" value="139"/><column index="10" value="136"/><column index="11" value="248"/><column index="12" value="254"/><column index="13" value="251"/><column index="14" value="300"/><column index="15" value="267"/><column index="16" value="264"/><column index="17" value="300"/><column index="18" value="197"/><column index="19" value="137"/><column index="20" value="265"/><column index="21" value="155"/><column index="22" value="283"/><column index="23" value="251"/><column index="24" value="300"/><column index="25" value="269"/><column index="26" value="300"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="CovidVaccinations" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="105"/><column index="2" value="108"/><column index="3" value="112"/><column index="4" value="109"/><column index="5" value="120"/><column index="6" value="126"/><column index="7" value="123"/><column index="8" value="235"/><column index="9" value="139"/><column index="10" value="136"/><column index="11" value="248"/><column index="12" value="254"/><column index="13" value="251"/><column index="14" value="300"/><column index="15" value="267"/><column index="16" value="264"/><column index="17" value="300"/><column index="18" value="197"/><column index="19" value="137"/><column index="20" value="265"/><column index="21" value="155"/><column index="22" value="283"/><column index="23" value="251"/><column index="24" value="300"/><column index="25" value="269"/><column index="26" value="300"/><column index="27" value="116"/><column index="28" value="119"/><column index="29" value="273"/><column index="30" value="270"/><column index="31" value="228"/><column index="32" value="300"/><column index="33" value="145"/><column index="34" value="165"/><column index="35" value="123"/><column index="36" value="197"/><column index="37" value="203"/><column index="38" value="261"/><column index="39" value="194"/><column index="40" value="300"/><column index="41" value="300"/><column index="42" value="300"/><column index="43" value="300"/><column index="44" value="300"/><column index="45" value="188"/><column index="46" value="207"/><column index="47" value="137"/><column index="48" value="166"/><column index="49" value="166"/><column index="50" value="173"/><column index="51" value="187"/><column index="52" value="245"/><column index="53" value="223"/><column index="54" value="178"/><column index="55" value="158"/><column index="56" value="246"/><column index="57" value="300"/><column index="58" value="173"/><column index="59" value="296"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="PercentagePeopleVaccinated" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="108"/><column index="2" value="104"/><column index="3" value="104"/><column index="4" value="120"/><column index="5" value="194"/><column index="6" value="263"/><column index="7" value="300"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table></browse_table_settings></tab_browse><tab_sql><sql name="SQL 1">-- Выбираем данные, которые будут использоваться в исследовании



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



</sql><current_tab id="0"/></tab_sql></sqlb_project>
