/*
Написать хранимую процедуру, которая должна выводить максимальную зарплату по дате, передаваемой в хранимую процедуру
*/

CREATE OR REPLACE FUNCTION Public.MaxSalary(_date json) RETURNS TABLE(Id_work int, 
                                                                      WorkerSurname VARCHAR(30),
                                                                      WorkerName VARCHAR(30),
                                                                      WorkerMiddlename VARCHAR(30),
                                                                      StatusWork VARCHAR(30),
                                                                      Salary NUMERIC)
    LANGUAGE plpgsql
AS
$$
   
BEGIN

    RETURN QUERY WITH cte_sel AS(SELECT x.dt FROM json_to_recordset(_date) AS x(dt DATE)),
                      agg_max AS(SELECT MAX(Workers.Salary) AS MaxSaLary FROM Workers)
    SELECT Workers.Id_work,
           Workers.WorkerSurname,
           Workers.WorkerName,
           Workers.WorkerMiddlename,
           Workers.StatusWork,
           Workers.Salary
    FROM Workers 
    JOIN cte_sel ON cte_sel.dt = Workers.Date
    JOIN agg_max ON agg_max.MaxSalary = Workers.Salary;
    
END;
$$;

SELECT * FROM MaxSalary('[{"dt":"2022-05-01"}]')




  
  