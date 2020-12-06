set serveroutput on;
set echo on;

DROP TABLE Staedte;

CREATE TABLE Staedte(
stadtname VARCHAR(30) PRIMARY KEY,
laengengrad NUMBER,
minutenlaenge NUMBER,
breitengrad NUMBER,
minutenbreite NUMBER
);
COMMIT;
INSERT INTO Staedte VALUES('Aachen', 6, 5, 50, 47);
INSERT INTO Staedte VALUES('Bonn', 7, 6, 50, 44);
INSERT INTO Staedte VALUES('Duesseldorf', 6, 47, 51, 14);
INSERT INTO Staedte VALUES('Duisburg', 6, 46, 51, 27);
INSERT INTO Staedte VALUES('Essen', 7, 1, 51, 27);
INSERT INTO Staedte VALUES('Koeln', 6, 57, 50, 56);
INSERT INTO Staedte VALUES('Krefeld', 6, 34, 51, 20);
INSERT INTO Staedte VALUES('Leverkusen', 6, 59, 51, 2);
INSERT INTO Staedte VALUES('Moenchengladbach', 6, 27, 51, 11);
INSERT INTO Staedte VALUES('Muelheim an der Ruhr', 6, 53, 51, 26);
INSERT INTO Staedte VALUES('Oberhausen', 6, 27, 51, 28);
INSERT INTO Staedte VALUES('Remscheid', 7, 12, 51, 11);
INSERT INTO Staedte VALUES('Solingen', 7, 5, 51, 10);
INSERT INTO Staedte VALUES('Wuppertal', 7, 13, 51, 16);
--d
-- 1)Prozedur die über für eine Stadt über alle anderen Städte iteriert und die abstandfunktion aufruft
-- 2)aufrufen von 1 für alle staedte