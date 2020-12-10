CREATE OR REPLACE PACKAGE AF_CONTRACT AS  -- spec
   -- PROCEDURE my_rpcedure (emp_id NUMBER);
   TYPE DTO_GRID IS RECORD
   (
     ROWKEY    NVARCHAR2(200),
     COLUMNKEY NVARCHAR2(200),
     CELLVALUE NVARCHAR2(200),
     OLDVALUE  NVARCHAR2(200),
     TAG       NVARCHAR2(200)
   );
END AF_CONTRACT;
/


--Create a new Package

CREATE OR REPLACE PACKAGE DISTANCES AS

	TYPE distancesMaps 
		IS TABLE OF FLOAT INDEX BY VARCHAR2(20);
	
	zeile STAEDTE%rowtype;
	
  	-- Add a function
  	FUNCTION CALCDISTANCE(lat1 float, lon1 float, lat2 float, lon2 float) RETURN float;
		
  	FUNCTION GETDISTANCERECORD (cityName IN STAEDTE.STADTNAME%"TYPE") RETURN distancesMaps;

	PROCEDURE CREATEDISTANCETABLE(ist IN NUMBER);
	
	
END DISTANCES;
/
--Create a new Package Body

CREATE OR REPLACE PACKAGE BODY DISTANCES AS

  -- Add procedure body
	FUNCTION GETDISTANCERECORD (cityName IN STAEDTE.STADTNAME%"TYPE") RETURN distancesMaps
		AS
		latitudeMain STAEDTE.LAENGENGRAD%"TYPE";
		longitudeMain STAEDTE.BREITENGRAD%"TYPE";
		distanceMap distancesMaps;
		totalRows NUMBER(3);
		rowCounter NUMBER(3) := 0;
		rowName STAEDTE.STADTNAME%"TYPE";
		--cursor cursor_cities IS 
		--SELECT * 
		--FROM staedte;
    	
	BEGIN
	  	SELECT LAENGENGRAD INTO longitudeMain FROM STAEDTE WHERE STADTNAME = cityName;
	  	SELECT BREITENGRAD INTO latitudeMain FROM STAEDTE WHERE STADTNAME = cityName;
		--SELECT STADTNAME INTO rowName FROM STAEDTE WHERE rownum = 1;
		/*
		--Open CURSOR
		IF (NOT cursor_cities%ISOPEN ) THEN
        	open cursor_cities;
		END IF;
		-- OPENING/CLOSING THE CURSOR AUTOFAIL THE BODY EVEN WITHOUT DOING ANYTHING ELSE
		LOOP
			FETCH cursor_cities INTO zeile;
        		distanceMap(zeile.stadtname) := CALCDISTANCE(latitudeMain ,longitudeMain, zeile.LAENGENGRAD, zeile.BREITENGRAD)
        	EXIT WHEN cursor_cities%notfound;
		END LOOP;
		close cursor_cities
		*/
		/*SELECT LAG(word) OVER ( ORDER BY ID ) AS PreviousWord ,
       word ,
       LEAD(word) OVER ( ORDER BY ID ) AS NextWord
FROM   words;*/
	
		-- Rowcount and loop with row_number
		--SELECT stadtname FROM STAEDTE;
		--totalRows := SQL%Rowcount;
		totalRows := 14;
		LOOP
			rowCounter := rowCounter + 1;
			SELECT * INTO ZEILE FROM STAEDTE WHERE rownum = rowCounter;
			--SELECT STADTNAME INTO rowName FROM STAEDTE WHERE rownum = rowCounter;
			
			EXIT WHEN totalRows = rowCounter;
			distanceMap(zeile.stadtname) := CALCDISTANCE(latitudeMain ,longitudeMain, zeile.LAENGENGRAD, zeile.BREITENGRAD);
		END LOOP;
		
		
	 	RETURN distanceMap;
	END;

  -- Add function body
  FUNCTION CALCDISTANCE(lat1 float, lon1 float, lat2 float, lon2 float) RETURN float
		AS 
			radlat1 float;
			radlat2 float ;
			theta float ;
            radtheta float;
			dist float ;
            pi float := 3.141592653589793238462643383279502884197169399375;
		BEGIN
			IF ((lat1 = lat2) AND (lon1 = lon2)) THEN
                dist := 0;
			ELSE
				radlat1 := PI * lat1/180;
				radlat2 := PI * lat2/180;
				theta := lon1-lon2;
				radtheta := PI * theta/180;
				dist := SIN(radlat1) * SIN(radlat2) + COS(radlat1) * COS(radlat2) * COS(radtheta);
				dist := ACOS(dist);
				dist := dist * 180/PI;
				dist := dist * 60 * 1.1515;
				dist := dist * 1.609344;  -- for kilometers

			END IF;
            RETURN dist;
		END;

		PROCEDURE CREATEDISTANCETABLE(ist IN NUMBER)
			AS
			map1 distancesMaps;
			BEGIN
			--dbms_output.put_line(distances.calcdistance(1,1,1,1));
			--map1 := GETDISTANCERECORD('Aachen');
			--INSERT INTO AbstaendeVonStaedten (von,Aa) VALUES ('Aachen',map1('Aachen')); -- FEHLER NO DATA FOUND
			INSERT INTO AbstaendeVonStaedten (von,Aa) VALUES ('Aachen',1);
			COMMIT;
		END;
END DISTANCES;
/
DECLARE
	stadt float;
BEGIN
	DISTANCES.CREATEDISTANCETABLE(1);
END;
/*DROP TABLE abstaendeST;
CREATE TABLE abstaendeST
			(
				von VARCHAR(10),
				Aa FLOAT,
				Bo FLOAT,
				Du FLOAT,
				Due FLOAT,
				Es FLOAT,
				Koe FLOAT,
				Kr FLOAT,
				distance08 FLOAT,
				distance09 FLOAT,
				distance10 FLOAT,
				distance11 FLOAT,
				distance12 FLOAT,
				distance13 FLOAT,
				distance14 FLOAT
			);
COMMIT;*/
		