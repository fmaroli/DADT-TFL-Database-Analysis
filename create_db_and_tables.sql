CREATE DATABASE bus_data;
CREATE TABLE bus_data.location(
    Borough VARCHAR(200) PRIMARY KEY
);
CREATE TABLE bus_data.vehicle(
    Route INT(10) PRIMARY KEY,
    Bus_garage VARCHAR(200),
    Operator VARCHAR(200),
    Borough VARCHAR(200),
    FOREIGN KEY(Borough) REFERENCES bus_data.location(Borough)
);
CREATE TABLE bus_data.victim(
    Accident_ID INT(10) PRIMARY KEY AUTO_INCREMENT,
    Injury_Result VARCHAR(200),
    Injury_Type VARCHAR(200),
    Victim_Category VARCHAR(200),
    Victim_Age INT(10),
    Victim_Gender VARCHAR(200)
);
CREATE TABLE bus_data.carries(
    Year INT(10),
    Date_of_incident DATE,
    PRIMARY KEY(Year, Date_of_incident)
);