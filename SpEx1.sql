/*
Написать хранимую процедуру и создать таблицу к ней. Процедура на входе должна получать json, раскрывать его и значения записывать в таблицу.
Пример json'а
'[{
"man_id":14,
"name":" Никита",
"surname":"Кузнецов",
"midlename":"Вазгенович"
},{
"man_id":16,
"name":"Олег",
"surname":"Ничопоренко",
"midlename":"Лохович"
}]'
*/

CREATE TABLE EmployeesClassic
(man_id INTEGER,
 name VARCHAR(30),
 surname VARCHAR(30),
 middlename VARCHAR(30)
);

CREATE OR REPLACE FUNCTION Public.JsonImport(_x json) RETURNS TABLE(man_id int, 
                                                                    name VARCHAR(30), 
                                                                    surname VARCHAR(30), 
                                                                    middlename VARCHAR(30))
    LANGUAGE plpgsql
AS
$$
BEGIN

    WITH cte_sel AS (
        SELECT x.man_id,
               x.name,
               x.surname,
               x.middlename
        FROM json_to_recordset(_x) as x(man_id int, 
                                     name VARCHAR(30), 
                                     surname VARCHAR(30), 
                                     middlename VARCHAR(30)))
                                 
    INSERT INTO EmployeesCLassic(man_id, 
                                 name,
                                 surname,
                                 middlename)
    SELECT c.man_id,
           c.name,
           c.surname,
           c.middlename
    FROM cte_sel as c;     
                                 
END;
$$;

SELECT Public.JsonImport('[{
"man_id":14,
"name":" Никита",
"surname":"Кузнецов",
"middlename":"Вазгенович"
},{
"man_id":16,
"name":"Олег",
"surname":"Ничопоренко",
"middlename":"Лохович"
}]');