-- Active: 1747733446084@@localhost@5432@conservation_db@public
CREATE DATABASE conservation_db;

-- Creating the rangers table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(100)
);

-- Creating the species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100),
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

-- Creating the sightings table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id),
    species_id INT REFERENCES species(species_id),
    sighting_time TIMESTAMP,
    location VARCHAR(255),
    notes TEXT
);

-- Inserting rangers data
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

-- Inserting species data
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- Inserting sightings data
INSERT INTO sightings (ranger_id, species_id, sighting_time, location, notes) VALUES
(1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
(2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
(3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
(2, 1, '2024-05-18 18:30:00', 'Snowfall Pass', NULL);

-- SELECT * FROM rangers;
-- SELECT * FROM species;
-- SELECT * FROM sightings;

-- DROP TABLE rangers;
-- DROP TABLE species;
-- DROP TABLE sightings

-- Problem 1
INSERT INTO rangers (name, region) 
VALUES ('Derek Fox', 'Coastal Plains');


-- Problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Problem 3
SELECT * 
FROM sightings
WHERE location LIKE '%Pass%';

-- Problem 4
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.name, r.ranger_id
ORDER BY r.ranger_id;

-- Problem 5
SELECT common_name 
FROM species 
WHERE species_id NOT IN (SELECT species_id FROM sightings);

-- Problem 6
SELECT s.sighting_time, sp.common_name, r.name
FROM sightings s
JOIN species sp ON s.species_id = sp.species_id
JOIN rangers r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Problem 7
UPDATE species 
SET conservation_status = 'Historic' 
WHERE discovery_date < '1800-01-01';

-- Problem 8
SELECT sighting_id, 
       CASE 
           WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sightings;

-- Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings);