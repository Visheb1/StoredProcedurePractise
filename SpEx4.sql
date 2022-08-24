/*
Создать хранимую процедуру, которая должна выводить и добавлять в таблицу ФИО находящихся на рабочем месте сотрудников, их зарплату и текущее время в формате JSON
*/

CREATE TABLE WorkNow(
id_w SERIAL,
information JSON    
);

CREATE OR REPLACE FUNCTION Public.ActiveWorkers() RETURNS TABLE (id_w INT,
                                                                 information JSON)
    LANGUAGE plpgsql
AS
$$

BEGIN

    INSERT INTO WorkNow(information)
    SELECT row_to_json(emp) FROM (SELECT WorkerSurname, 
                                  WorkerName, 
                                  WorkerMiddlename, 
                                  Salary, 
                                  current_timestamp AS Date 
    FROM Workers
    WHERE StatusWork = 'На работе') AS emp;

    RETURN QUERY SELECT WN.id_w, WN.information FROM WorkNow AS WN;
    
END;
$$;

SELECT ActiveWorkers();

