-- The first part defines a trigger function named colleges_notify_trigger. This function is responsible for determining the type of operation (insert, update, delete) and sending notifications accordingly. It uses the TG_OP variable to identify the operation type and the pg_notify function to send notifications with operation details and affected data.

-- Define a trigger function that sends notifications for insert, update, or delete events

CREATE OR REPLACE FUNCTION public.colleges_notify_trigger() RETURNS trigger AS $$
DECLARE
    operation text;
BEGIN
    -- Determine the type of operation (insert, update, delete)
    IF TG_OP = 'INSERT' THEN
        operation := 'insert';
    ELSIF TG_OP = 'UPDATE' THEN
        operation := 'update';
    ELSIF TG_OP = 'DELETE' THEN
        operation := 'delete';
    END IF;

    -- Send a notification with the operation type and affected data
    PERFORM pg_notify(CAST('update_notification' AS text), json_build_object(
        'operation', operation,
        'data', CASE WHEN operation = 'delete' THEN OLD ELSE NEW END
    )::text);

    -- Continue with the original operation (insert, update, delete)
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- The second part creates a trigger named colleges_notify_trigger_combined. This trigger is set to activate after any insert, update, or delete event on the colleges table. It calls the colleges_notify_trigger function, which handles the notifications.
-- Create a combined trigger that activates the trigger function for all events (insert, update, delete)
CREATE TRIGGER colleges_notify_trigger_combined
AFTER INSERT OR UPDATE OR DELETE ON colleges
FOR EACH ROW
EXECUTE PROCEDURE public.colleges_notify_trigger();
  
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



