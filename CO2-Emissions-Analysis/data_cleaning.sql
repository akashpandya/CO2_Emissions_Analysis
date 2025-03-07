-- Remove duplicate entries
DELETE FROM co2_emissions
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM co2_emissions
    GROUP BY Year, Country, Sector, CO2_Emissions_MMT
);

-- Handle NULL values (replace with sector average)
UPDATE co2_emissions
SET CO2_Emissions_MMT = (
    SELECT AVG(CO2_Emissions_MMT)
    FROM co2_emissions AS sub
    WHERE sub.Sector = co2_emissions.Sector
)
WHERE CO2_Emissions_MMT IS NULL;

-- Ensure year values are within expected range (1990–2024)
DELETE FROM co2_emissions WHERE Year < 1990 OR Year > 2024;

-- Convert Year and CO2_Emissions_MMT columns to appropriate data types
ALTER TABLE co2_emissions MODIFY COLUMN Year INT;
ALTER TABLE co2_emissions MODIFY COLUMN CO2_Emissions_MMT FLOAT;
