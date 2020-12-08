--Create a new Package

CREATE PACKAGE ABSTANDSTAEDTE IS

  -- Add a procedure
  PROCEDURE PROCEDURE1 (
    PARAM1 IN NUMBER);

  -- Add a function
  FUNCTION FUNCTION1 (
    PARAM1 IN NUMBER) RETURN NUMBER;

  FUNCTION DISTANCE(lat1 float, lon1 float, lat2 float, lon2 float)RETURN float
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


END PACKAGE1;
/