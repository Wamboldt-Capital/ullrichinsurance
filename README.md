# Ullrich Insurance Toolbox

This repo hosts the static assets for the Ullrich Insurance productivity toolbox.

## Supabase setup

1. Create a new Supabase project and run the SQL in [`supabase/schema.sql`](supabase/schema.sql).
   * This script provisions the `users`, `sessions`, and `work_data` tables, adds open access
     policies for the anon key, and inserts a sample `admin` account (`admin` / `admin`).
2. Copy your project's URL and anon key into [`supabase-config.js`](supabase-config.js).
3. Deploy the updated site (for GitHub Pages, commit the changes to `main` and push).

Once deployed, visit `index.html` to log in with the admin account and create additional users.
