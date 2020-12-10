set serveroutput on;
set echo on;

declare
   result number;
   TYPE distancesMaps 
		IS TABLE OF FLOAT INDEX BY VARCHAR2(20); -- this is still != the same name and definition in package of type distanceMaps
    map1 distancesMaps;
begin
   -- Call the function
  -- result := DISTANCES.GETDISTANCERECORD(CITYNAME  => P_ /*IN VARCHAR2*/)
   map1 := DISTANCES.GETDISTANCERECORD(CITYNAME  => 'Aachen' /*IN VARCHAR2*/);
  -- dbms_output.put_line(result||' km'); 

end;


/*
--dbms_output.put_line('Mitarbeiter Nr.: ' || 1);
exec dbms_output.put_line(distances.calcdistance(1,1,1,1));
declare
   result number;
begin
   -- Call the function
   result := DISTANCES.CALCDISTANCE (7,50,5,50);
   dbms_output.put_line(result||' km'); 

end;
*/