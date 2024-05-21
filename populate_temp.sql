DROP TABLE bus_data.temp;
CREATE TABLE bus_data.temp(
    ID INT,
    Year INT(10),
    Date_of_incident DATE,
    Route INT(10),
    Operator VARCHAR(200),
    GroupName VARCHAR(200),
    Bus_garage VARCHAR(200),
    Borough VARCHAR(200),
    Victim_ID VARCHAR(200),
    Injury_Result VARCHAR(200),
    Injury_Type VARCHAR(200),
    Victim_Category VARCHAR(200),
    Victim_Gender VARCHAR(200),
    Victim_Age VARCHAR(200)
);
LOAD DATA LOCAL INFILE 'Datasetbus.csv'
INTO TABLE bus_data.temp
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(ID, Year, @Date_of_incident, Route, Operator, GroupName, Bus_garage, Borough, Victim_ID, Injury_Result, Injury_Type, Victim_Category, Victim_Gender, Victim_Age)
SET Date_of_incident = STR_TO_DATE(@Date_of_incident, '%d/%m/%Y');

INSERT INTO victim(Victim_ID, Victim_Sex, Victim_Age, Victim_Category) SELECT Victim_ID, Victim_Gender, Victim_Age, Victim_Category FROM temp;
SELECT * FROM victim;

INSERT INTO routes(Bus_Garage, Operator, Route_Code)
SELECT DISTINCT Bus_Garage, Operator, Route FROM temp


ALTER DATABASE bus_data CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
ALTER TABLE accident CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
ALTER TABLE routes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
ALTER TABLE temp CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
ALTER TABLE victim CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE 'Datasetbus.csv'
INTO TABLE bus_data.temp
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(ID, Year, @Date_of_incident, Route, Operator, GroupName, Bus_garage, Borough, Victim_ID, Injury_Result, Injury_Type, Victim_Category, Victim_Gender, Victim_Age)
SET Date_of_incident = STR_TO_DATE(@Date_of_incident, '%d/%m/%Y');


DELETE FROM routes WHERE 1=1;
SELECT * FROM bus_data.routes;
ALTER TABLE routes AUTO_INCREMENT = 1;


--
START TRANSACTION;
INSERT INTO accident(Injury_Result, Injury_Type, Year, Date_of_incident, Route_ID, Victim_ID)
SELECT Injury_Result, Injury_Type, Year, Date_Of_Incident, r.Route_ID, t.Victim_ID
FROM temp t INNER JOIN routes r ON t.Bus_Garage = r.Bus_Garage AND t.Operator = r.Operator AND t.Route = r.Route_Code
INNER JOIN victim v ON t.Victim_ID = v.Victim_ID;
--

SELECT Injury_Result, COUNT(Route_ID) FROM accident GROUP BY Injury_Result;


SELECT * FROM accident;
SELECT r.Route_Code, COUNT(Victim_ID) FROM accident a
INNER JOIN routes r ON a.Route_ID = r.Route_ID
GROUP BY Route_Code;

SELECT a.Injury_Type, r.Route_Code, COUNT(Victim_ID) AS TOTAL FROM accident a
INNER JOIN routes r ON a.Route_ID = r.Route_ID
GROUP BY Route_Code, a.Injury_Type
ORDER BY COUNT(Victim_ID) DESC;

SELECT a.Injury_Result, r.Route_Code, COUNT(Victim_ID) AS TOTAL FROM accident a
INNER JOIN routes r ON a.Route_ID = r.Route_ID
WHERE a.Injury_Result = 'Fatal'
GROUP BY Route_Code, a.Injury_Result
ORDER BY COUNT(Victim_ID) DESC;