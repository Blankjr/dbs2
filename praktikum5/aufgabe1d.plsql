
CREATE Or REPLACE TYPE distanceBetween IS RECORD
(
    mCity    VARCHAR(30),
    cCity01  VARCHAR(30),
    cCity02  VARCHAR(30),
    cCity03  VARCHAR(30),
    cCity03  VARCHAR(30),
    cCity04  VARCHAR(30),
    cCity05  VARCHAR(30),
    cCity06  VARCHAR(30),
    cCity07  VARCHAR(30),
    cCity08  VARCHAR(30),
    cCity09  VARCHAR(30),
    cCity10  VARCHAR(30),
    cCity11  VARCHAR(30),
    cCity12  VARCHAR(30),
    cCity13  VARCHAR(30),
    cCity14  VARCHAR(30),
);
CREATE OR REPLACE TYPE citydata IS OBJECT 
create or replace function distanceBetween(cityName varchar(20))return Varray(n)
    AS

--create custom record in d
-- create table with created records from d in e



