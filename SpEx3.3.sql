CREATE OR REPLACE FUNCTION Public.WorkersToJson() RETURNS json
    LANGUAGE plpgsql
AS
$$
DECLARE
    _wjson json;
    
BEGIN

    SELECT array_to_json(array_agg(row_to_json(wjson)))
    INTO _wjson
    FROM (SELECT w.Id_work,
                 w.Date,
                 w.WorkerSurname,
                 w.WorkerName,
                 w.WorkerMiddlename,
                 w.StatusWork,
                 w.Salary
          FROM Workers as w) wjson;
          
    RETURN json_build_object('result:', _wjson);          
END;
$$;

SELECT WorkersToJson();
    