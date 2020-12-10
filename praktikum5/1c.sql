CREATE OR REPLACE PACKAGE DISTANCES AS

	TYPE distancesMaps 
		IS TABLE OF FLOAT INDEX BY STAEDTE.STADTNAME%TYPE;
	

	
  	-- Add a function
  	FUNCTION CALCDISTANCE(lat1 float, lon1 float, lat2 float, lon2 float) RETURN float;
		
  	FUNCTION GETDISTANCERECORD (cityName IN STAEDTE.STADTNAME%"TYPE") RETURN distancesMaps;

	PROCEDURE CREATEDISTANCETABLE(ist IN NUMBER);
	
	
END DISTANCES;
/


CREATE OR REPLACE PACKAGE BODY DISTANCES AS


	FUNCTION GETDISTANCERECORD (cityName IN STAEDTE.STADTNAME%"TYPE") RETURN distancesMaps
		AS
		latitudeMain STAEDTE.LAENGENGRAD%"TYPE";
		longitudeMain STAEDTE.BREITENGRAD%"TYPE";
        zeile STAEDTE%rowtype;
		distanceMap distancesMaps;
		totalRows NUMBER(3);
		rowCounter NUMBER(3) := 0;
		rowName STAEDTE.STADTNAME%"TYPE";
    	
	BEGIN
	  	SELECT LAENGENGRAD INTO longitudeMain FROM STAEDTE WHERE STADTNAME = cityName;
	  	SELECT BREITENGRAD INTO latitudeMain FROM STAEDTE WHERE STADTNAME = cityName;

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
            zeile STAEDTE%rowtype;	
			map1 distancesMaps;
			BEGIN
			--dbms_output.put_line(distances.calcdistance(1,1,1,1));
			map1 := GETDISTANCERECORD('Aachen');
			--INSERT INTO AbstaendeVonStaedten (von,Aa) VALUES ('Aachen',map1('Aachen')); -- FEHLER NO DATA FOUND
			INSERT INTO AbstaendeVonStaedten (von,Aa) VALUES ('Aachen',1);
			COMMIT;
		END;
END DISTANCES;
/
DECLARE
    stadt STAEDTE.STADTNAME%TYPE;
    stadtchar VARCHAR2(50);
    distanceMap distances.distancesMaps;
BEGIN
    SELECT STADTNAME INTO STADT
    FROM STAEDTE
    WHERE STADTNAME = 'Duesseldorf';
    
    distanceMap := DISTANCES.GETDISTANCERECORD(stadt);
    
    stadtchar := distanceMap.FIRST;
        
    WHILE stadtchar is not null loop
        dbms_output.put_line('von ' || stadt || ' ist die Distanz ' ||  distanceMap(stadtchar) || ' zu ' || stadtchar);
        stadtchar := distanceMap.NEXT(stadtchar);
    END LOOP;
    
END;
/
