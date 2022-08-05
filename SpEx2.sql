/*
Написать хранимую процедуру, которая будет делать SELECT из таблицы и оборачивать в json
*/

CREATE OR REPLACE FUNCTION Public.JsonExport() RETURNS json
    LANGUAGE plpgsql
AS
$$
DECLARE
    _res json;
BEGIN
    SELECT array_to_json(array_agg(row_to_json(res)))
    INTO _res
    FROM( SELECT ye.man_id,
                 ye.name,
                 ye.surname,
                 ye.middlename
           FROM  EmployeesCLassic as ye ) res;
           
     RETURN json_build_object('result:', _res);
END;
$$;

SELECT JsonExport();
