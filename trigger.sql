-- The code you provided is for creating a PostgreSQL trigger and a trigger function to notify clients of updates to the `colleges` table using the `pg_notify` function. This is often used for implementing real-time updates or change notifications in a database-driven application.

-- **1. Trigger Function (`colleges_notify_trigger`):**

-- This is a PostgreSQL trigger function written in PL/pgSQL, which is a procedural language used for writing database functions and triggers.

-- - The `CREATE OR REPLACE FUNCTION` statement creates or replaces the function named `colleges_notify_trigger()`.
-- - Inside the function, the `BEGIN` and `END` blocks enclose the code logic.
-- - The `PERFORM pg_notify(...)` line triggers a PostgreSQL notification using the `pg_notify` function. It sends the `NEW` row (the updated row) as a JSON-formatted string to the specified channel, which is `'update_notification'` in this case.
-- - The `RETURN new;` line indicates that the original operation (in this case, an update) should proceed normally.

-- **2. Trigger Creation (`colleges_update_trigger`):**

-- This creates a trigger that fires the `colleges_notify_trigger` function when specific conditions are met:

-- - The trigger is named `colleges_update_trigger`.
-- - It is defined to execute `AFTER UPDATE` on the `colleges` table.
-- - The `FOR EACH row` clause specifies that the trigger is fired for each row that is updated.
-- - The condition `WHEN (OLD.name IS DISTINCT FROM NEW.name)` indicates that the trigger should fire only when the `name` column is updated and its old and new values are different.
-- - The `EXECUTE PROCEDURE public.colleges_notify_trigger();` line specifies that the `colleges_notify_trigger` function should be executed when the trigger conditions are met.

-- **3. Trigger Removal (`DROP TRIGGER`):

-- This is used to remove the previously created trigger:

-- - The `DROP TRIGGER` statement removes the `colleges_update_trigger` trigger from the `public.colleges` table.

-- In summary, the provided code creates a trigger function that sends notifications when updates occur on the `colleges` table, specifically when the `name` column changes. This can be useful for building real-time applications that need to respond to changes in the database. The trigger function uses the `pg_notify` function to send notifications, and the trigger is activated when specific conditions are met during an `UPDATE` operation.

  
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



