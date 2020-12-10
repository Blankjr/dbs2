set serveroutput on;
set echo on;

DROP TABLE Staedte;

CREATE TABLE Staedte (
latitude_grad NUMBER(2),
latitude_minute NUMBER(2),
longitude_grad NUMBER(3),
longitude_minute NUMBER(2),
stadtname VARCHAR2(30)
);

INSERT INTO Staedte VALUES(50, 47, 6, 5,'Aachen');
INSERT INTO Staedte VALUES(50, 44, 7, 6, 'Bonn');
INSERT INTO Staedte VALUES(51, 14, 6, 47, 'Duesseldorf');
INSERT INTO Staedte VALUES(51, 25, 6, 46, 'Duisburg');
INSERT INTO Staedte VALUES(51, 27, 7, 1, 'Essen');
INSERT INTO Staedte VALUES(50, 56, 6, 57, 'Koeln');
INSERT INTO Staedte VALUES(51, 20, 6, 34, 'Krefeld');
INSERT INTO Staedte VALUES(51, 2, 6, 59, 'Leverkusen');
INSERT INTO Staedte VALUES(51, 11, 6, 27, 'Moenchengladbach');
INSERT INTO Staedte VALUES(51, 26, 6, 53, 'Muelheim an der Ruhr');
INSERT INTO Staedte VALUES(51, 28, 6, 52, 'Oberhausen');
INSERT INTO Staedte VALUES(51, 11, 7, 12, 'Remscheid');
INSERT INTO Staedte VALUES(51, 10, 7, 5, 'Solingen');
INSERT INTO Staedte VALUES(51, 16, 7, 13, 'Wuppertal');

-- c) / d) / e)
-- erstellen eines neuen Package
CREATE OR REPLACE PACKAGE Praktikum_5 AS
    -- erstellen eines TYP
    TYPE Entfernungs_table IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    FUNCTION Abstand(p_stadt_1 Staedte.stadtname%TYPE, p_stadt_2 Staedte.stadtname%TYPE) RETURN NUMBER;
    FUNCTION Entfernungen(p_stadtname Staedte.stadtname%TYPE) RETURN Entfernungs_table;
    PROCEDURE Entfernungs_Tabelle;
END Praktikum_5;
/

-- c)
CREATE OR REPLACE PACKAGE BODY Praktikum_5 AS
    FUNCTION Abstand(p_stadt_1 Staedte.stadtname%TYPE, p_stadt_2 Staedte.stadtname%TYPE) RETURN NUMBER IS
    -- Zusammengesetzter Datentyp für Koordinaten für beide Städte
    TYPE Koordinaten IS RECORD (
        latitude NUMBER(6),
        longitude NUMBER(6),
        latitude_grad staedte.latitude_grad%TYPE,
        latitude_minute staedte.latitude_minute%TYPE,
        longitude_grad staedte.longitude_grad%TYPE,
        longitude_minute staedte.longitude_minute%TYPE
    );
    v_koordinaten_1 Koordinaten;
    v_koordinaten_2 Koordinaten;
    v_abstand NUMBER;
    BEGIN
        SELECT latitude_grad, latitude_minute, longitude_grad, longitude_minute
        INTO v_koordinaten_1.latitude_grad, v_koordinaten_1.latitude_minute, v_koordinaten_1.longitude_grad, v_koordinaten_1.longitude_minute
        FROM Staedte
        WHERE stadtname = p_stadt_1;
        SELECT latitude_grad, latitude_minute, longitude_grad, longitude_minute
        INTO v_koordinaten_2.latitude_grad, v_koordinaten_2.latitude_minute, v_koordinaten_2.longitude_grad, v_koordinaten_2.longitude_minute
        FROM Staedte
        WHERE stadtname = p_stadt_2;
        -- Umwandlung in Minuten und direkt in Kilometer
        -- Stadt 1
        -- Latitude
        v_koordinaten_1.latitude := (v_koordinaten_1.latitude_grad * 60 + v_koordinaten_1.latitude_minute) * 1.85;
        -- Longitude
        v_koordinaten_1.longitude := (v_koordinaten_1.longitude_grad * 60 + v_koordinaten_1.longitude_minute) * 1.19;

        -- Stadt 2
        -- Latitude
        v_koordinaten_2.latitude := (v_koordinaten_2.latitude_grad * 60 + v_koordinaten_2.latitude_minute) * 1.85;
        -- Longitude
        v_koordinaten_2.longitude := (v_koordinaten_2.longitude_grad * 60 + v_koordinaten_2.longitude_minute) * 1.19;
        -- Berechnung des Abstands
        v_abstand := ROUND(SQRT(POWER(v_koordinaten_2.latitude - v_koordinaten_1.latitude, 2) + POWER(v_koordinaten_2.longitude - v_koordinaten_1.longitude, 2)));
        RETURN v_abstand;
    END Abstand;

    -- d)
    FUNCTION Entfernungen(p_stadtname Staedte.stadtname%TYPE) RETURN Entfernungs_table IS
    v_entfernungen Entfernungs_table;
        i NUMBER := 1;
    BEGIN
        FOR stadt IN (SELECT stadtname FROM Staedte ORDER BY stadtname) LOOP
        v_entfernungen(i) := Abstand(p_stadtname, stadt.stadtname);
        i := i + 1;
        END LOOP;
        RETURN v_entfernungen;
    END Entfernungen;

    -- e)
    PROCEDURE Entfernungs_Tabelle IS
        v_entfernungen Entfernungs_table;
        i NUMBER;
    BEGIN
        --Oberste Zeile mit Abgekürzten Stadtnamen mithilfe von Substring
        DBMS_OUTPUT.PUT('von ... nach -> [KM]' || CHR(9) || CHR(9));
        FOR stadt IN (SELECT stadtname FROM Staedte ORDER BY stadtname) LOOP
            DBMS_OUTPUT.PUT(SUBSTR(stadt.stadtname, 1, 2) || CHR(9) || CHR(9));
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
        -- Abschluss der Obersten Zeile

        FOR stadt IN (SELECT stadtname FROM Staedte ORDER BY stadtname) LOOP
            -- Aus einrückungs/Formatierungsgründen alle Stadtnamen gleichlang
            DBMS_OUTPUT.PUT(SUBSTR(stadt.stadtname, 1, 2) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9));
            -- Ermitteln der Abstände von Ort x zu allen anderen
            v_entfernungen := Entfernungen(stadt.stadtname);
            -- die erste Enfernung ermitteln
            i := v_entfernungen.FIRST;
            WHILE i IS NOT NULL LOOP
                -- Ausgabe der Enfernung
                DBMS_OUTPUT.PUT(v_entfernungen(i) || CHR(9) || CHR(9));
                -- zum nächsten Eintrag
                i := v_entfernungen.NEXT(i);
            END LOOP;
            -- Nachdem alle Einträge der Enfernung zwischen Ort x und allen anderen durchlaufen wurde "Zeile" abschließen
            DBMS_OUTPUT.NEW_LINE;
            -- So lange bis alle Orte durchlaufen wurden
        END LOOP;
    END Entfernungs_Tabelle;
END;
/

-- c
EXEC DBMS_OUTPUT.PUT_LINE(Praktikum_5.Abstand('Duesseldorf', 'Koeln'));

-- d
DECLARE
    abstaende praktikum_5.entfernungs_table;
    i NUMBER;
BEGIN
    abstaende := Praktikum_5.entfernungen('Duesseldorf');
    i := abstaende.FIRST;
    WHILE i IS NOT NULL LOOP
    DBMS_OUTPUT.PUT(abstaende(i) || CHR(9));
    i := abstaende.NEXT(i);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
END;
/
-- e)
EXEC Praktikum_5.Entfernungs_Tabelle;