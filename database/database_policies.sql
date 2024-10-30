CREATE POLICY "authenticated users only can insert events" on "public"."event"
AS PERMISSIVE FOR INSERT
TO authenticated

WITH CHECK (true);

CREATE POLICY "Enable users to delete their own data only" on "public"."event"
AS PERMISSIVE FOR DELETE
TO authenticated
USING ((( SELECT auth.uid() AS uid) = user_id));

CREATE POLICY "Enable users to update their own data only" on "public"."event"
AS PERMISSIVE FOR UPDATE
TO authenticated
USING ((( SELECT auth.uid() AS uid) = user_id))
WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));

CREATE POLICY "Enable users to view their own data only" on "public"."event"
AS PERMISSIVE FOR SELECT
TO authenticated
USING ((( SELECT auth.uid() AS uid) = user_id));