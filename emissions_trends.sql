-- Find the year with the highest and lowest CO2 emissions for each country
SELECT Country, 
       Year, 
       SUM(CO2_Emissions_MMT) AS Total_Emissions
FROM co2_emissions
GROUP BY Country, Year
ORDER BY Total_Emissions DESC
LIMIT 1;

-- Calculate year-over-year CO2 Emissions growth per country
SELECT 
    Year, 
    Country,
    SUM(CO2_Emissions_MMT) AS Yearly_Emissions,
    LAG(SUM(CO2_Emissions_MMT)) OVER (PARTITION BY Country ORDER BY Year) AS Previous_Year_Emissions,
    (SUM(CO2_Emissions_MMT) - LAG(SUM(CO2_Emissions_MMT)) OVER (PARTITION BY Country ORDER BY Year)) / 
        LAG(SUM(CO2_Emissions_MMT)) OVER (PARTITION BY Country ORDER BY Year) * 100 AS Growth_Percentage
FROM co2_emissions
GROUP BY Year, Country
ORDER BY Country, Year;

-- Identify countries that reduced emissions over time
SELECT Country, 
       MIN(Year) AS First_Year, 
       MAX(Year) AS Last_Year, 
       SUM(CASE WHEN Year = (SELECT MIN(Year) FROM co2_emissions) THEN CO2_Emissions_MMT ELSE 0 END) AS Initial_Emissions,
       SUM(CASE WHEN Year = (SELECT MAX(Year) FROM co2_emissions) THEN CO2_Emissions_MMT ELSE 0 END) AS Final_Emissions,
       (SUM(CASE WHEN Year = (SELECT MAX(Year) FROM co2_emissions) THEN CO2_Emissions_MMT ELSE 0 END) - 
        SUM(CASE WHEN Year = (SELECT MIN(Year) FROM co2_emissions) THEN CO2_Emissions_MMT ELSE 0 END)) / 
        SUM(CASE WHEN Year = (SELECT MIN(Year) FROM co2_emissions) THEN CO2_Emissions_MMT ELSE 0 END) * 100 AS Emissions_Change_Percentage
FROM co2_emissions
GROUP BY Country
HAVING Emissions_Change_Percentage < 0
ORDER BY Emissions_Change_Percentage ASC;
