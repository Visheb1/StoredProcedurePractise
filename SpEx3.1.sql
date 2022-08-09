/*
Создать таблицу с полями:
ИД сотрудника кластерный ПК - обязательное поле
Дата кластерный ПК - обязательное поле
Фамилия сотрудника - обязательное поле
Имя сотрудника - обязательное поле
Отчество сотрудника - необязательное поле
Статус работы - обязательное поле
Зарплата - обязательное поле.
Создать хранимую процедуру, которая на входе будет получать следующий JSON, раскрывать его и значения записывать в созданную таблицу:
'[{
"emp_id":14,
"dt":"2022-05-01",
"surname":"Кузнецов",
"name":" Никита",
"middlename":"Вазгенович",
"status":"На работе",
"salary": 1250.8
},{
"emp_id":14,
"dt":"2022-05-01",
"surname":"Белый",
"name":" Александр",
"middlename":"Иванович",
"status":"На работе",
"salary": 2250.8
}]'
Хранимая процедура должна возвращать void
*/

CREATE TABLE Workers(
Id_work INT NOT NULL,
Date DATE NOT NULL,
WorkerSurname VARCHAR(30) NOT NULL,
WorkerName VARCHAR(30) NOT NULL,
WorkerMiddlename VARCHAR(30),
StatusWork VARCHAR(30) NOT NULL,
Salary NUMERIC NOT NULL,
CONSTRAINT PK_Id_Date PRIMARY KEY(Id_work, Date));

CREATE OR REPLACE FUNCTION Public.ReturnsVoidProcedure(_sp3 json) RETURNS void
    LANGUAGE plpgsql
AS
$$
BEGIN

    WITH cte_sel AS (
        SELECT x.emp_id,
               x.dt,
               x.surname,
               x.name,
               x.middlename,
               x.status,
               x.salary,  
               ROW_NUMBER() OVER(PARTITION BY x.emp_id, x.dt ORDER BY x.emp_id, x.dt) AS RN
        FROM json_to_recordset(_sp3) as x(emp_id INT, 
                                     dt DATE, 
                                     surname VARCHAR(30),
                                     name VARCHAR(30),
                                     middlename VARCHAR(30),
                                     status VARCHAR(30),
                                     salary NUMERIC))
    INSERT INTO Workers(Id_work,
                        Date,
                        WorkerSurname,
                        WorkerName,
                        WorkerMiddlename,
                        StatusWork,
                        Salary)
    SELECT c.emp_id,
           c.dt,
           c.surname,
           c.name,
           c.middlename,
           c.status,
           c.salary
    FROM cte_sel AS c
    WHERE c.RN = 1
    ON CONFLICT ON CONSTRAINT PK_Id_Date
    DO UPDATE SET WorkerSurname = excluded.WorkerSurname,
                  WorkerName = excluded.WorkerName,
                  WorkerMiddlename = excluded.WorkerMiddlename,
                  StatusWork = excluded.StatusWork,
                  Salary = excluded.Salary
    WHERE excluded.Date >= Workers.Date;
    
END;
$$;

SELECT ReturnsVoidProcedure('[{
"emp_id":14,
"dt":"2022-05-01",
"surname":"Кузнецов",
"name":" Никита",
"middlename":"Вазгенович",
"status":"На работе",
"salary": 1250.8
},{
"emp_id":14,
"dt":"2022-05-01",
"surname":"Белый",
"name":" Александр",
"middlename":"Иванович",
"status":"На работе",
"salary": 2250.8
}]');



   







