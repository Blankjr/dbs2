set autotrace on;
set echo on;
SELECT * FROM employeesN WHERE first_name = 'Lorien';

CREATE INDEX empindex ON employeesN(first_name);
SELECT first_name FROM employeesN WHERE first_name = 'Lorien';