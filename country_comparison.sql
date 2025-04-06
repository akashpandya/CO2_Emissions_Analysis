-- Total emissions per country (all years combined)
SELECT Country, SUM(CO2_Emissions_MMT) AS Total_Emissions
FROM co2_emissions
GROUP BY Country
ORDER BY Total_Emissions DESC;

-- Compare emissions between developed vs developing countries
SELECT 
    CASE 
        WHEN Country IN ('USA', 'Canada', 'Germany', 'UK', 'France', 'Japan', 'Australia') THEN 'Developed'
        ELSE 'Developing'
    END AS Country_Type,
    SUM(CO2_Emissions_MMT) AS Total_Emissions
FROM co2_emissions
GROUP BY Country_Type
ORDER BY Total_Emissions DESC;

-- Find the top 5 and bottom 5 emitting countries
(SELECT Country, SUM(CO2_Emissions_MMT) AS Total_Emissions
 FROM co2_emissions
 GROUP BY Country
 ORDER BY Total_Emissions DESC
 LIMIT 5)
 
UNION ALL

(SELECT Country, SUM(CO2_Emissions_MMT) AS Total_Emissions
 FROM co2_emissions
 GROUP BY Country
 ORDER BY Total_Emissions ASC
 LIMIT 5);
