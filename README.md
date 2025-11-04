# Ullrich Insurance Toolbox

This repo hosts the static assets for the Ullrich Insurance productivity toolbox.

## Supabase setup

1. Create a new Supabase project and run the SQL in [`supabase/schema.sql`](supabase/schema.sql).
   * This script provisions the `users`, `sessions`, and `work_data` tables, adds open access
     policies for the anon key, and inserts a sample `admin` account (`admin` / `admin`).
2. Copy your project's URL and anon key into [`supabase-config.js`](supabase-config.js).
3. Deploy the updated site (for GitHub Pages, commit the changes to `main` and push).

Once deployed, visit `index.html` to log in with the admin account and create additional users.

### Troubleshooting saves

If timers or task entries are not sticking after refreshes:

1. Open the `work_data` table in Supabase and confirm the columns were created with the schema above (`names`, `totals`, `active`, `clock_start`, `list_titles`, and `list_items` should all be `jsonb`).
2. Add or update a task from the toolbox, then refresh the `work_data` table view—there should be a row for your username and the current date with the `names` column containing a JSON object that includes a `taskItems` array.
3. If no row appears, verify that you are logged in with a user that exists in the `users` table (the toolbox writes `work_data.user_id` using the username from the session).
4. If a row appears but JSON fields stay `null`, re-run [`supabase/schema.sql`](supabase/schema.sql) to ensure the column types are correct, then try again.
