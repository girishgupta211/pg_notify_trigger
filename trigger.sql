CREATE or REPLACE FUNCTION public.colleges_notify_trigger() RETURNS trigger AS $$
DECLARE
BEGIN
PERFORM pg_notify( CAST('update_notification' AS text), row_to_json (NEW) :: text);
RETURN new;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER colleges_update_trigger AFTER UPDATE ON colleges
FOR EACH row WHEN (OLD.name IS DISTINCT FROM NEW.name)
EXECUTE PROCEDURE public.colleges_notify_trigger();

/* WHEN (OLD.name IS DISTINCT FROM NEW.name)*/

DROP TRIGGER colleges_update_trigger on public. colleges;

pg_db=# EXPLAIN ANALYZE UPDATE colleges SET name='CENTRAL UNIVERSITY OF ANDHRA PRADESH2' where id = 93868;
-[ RECORD 1 ]------------------------------------------------------------------------------------------------------------------------------
QUERY PLAN | Update on colleges  (cost=0.29..8.31 rows=1 width=564) (actual time=0.098..0.098 rows=0 loops=1)
-[ RECORD 2 ]------------------------------------------------------------------------------------------------------------------------------
QUERY PLAN |   ->  Index Scan using colleges_pkey on colleges  (cost=0.29..8.31 rows=1 width=564) (actual time=0.024..0.044 rows=1 loops=1)
-[ RECORD 3 ]------------------------------------------------------------------------------------------------------------------------------
QUERY PLAN |         Index Cond: (id = 93868)
-[ RECORD 4 ]------------------------------------------------------------------------------------------------------------------------------
QUERY PLAN | Planning time: 0.133 ms
-[ RECORD 5 ]------------------------------------------------------------------------------------------------------------------------------
QUERY PLAN | Execution time: 0.127 ms

--
-- id             | 93868
-- name           | CENTRAL UNIVERSITY OF ANDHRA PRADESH
-- state_id       | 2
-- university_id  | 3095
-- unique_code    | U-0976
-- created_at     | 2021-03-10 20:52:38.116151
-- updated_at     | 2021-03-10 20:52:38.116151
-- workflow_state | active
