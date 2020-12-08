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
		IS TABLE OF FLOAT INDEX BY VARCHAR2(50);
	
  	-- Add a function
  	FUNCTION CALCDISTANCE(lat1 float, lon1 float, lat2 float, lon2 float) RETURN float;
		
  	-- Add a procedure
  	FUNCTION GETDISTANCERECORD (cityName IN VARCHAR) RETURN distancesMaps;
END DISTANCES;
/
--Create a new Package Body

CREATE OR REPLACE PACKAGE BODY DISTANCES AS

  -- Add procedure body
	FUNCTION GETDISTANCERECORD (cityName IN VARCHAR) RETURN distancesMaps
		AS
		latitudeMain STAEDTE.LAENGENGRAD%"TYPE";
		longitudeMain STAEDTE.BREITENGRAD%"TYPE";
		distanceMap distancesMaps;
	BEGIN
	 -- SELECT LAENGENGRAD INTO longitudeMain FROM STAEDTE WHERE STADTNAME = cityName;
	 -- SELECT BREITENGRAD INTO latitudeMain FROM STAEDTE WHERE STADTNAME = cityName;
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

END DISTANCES;
/