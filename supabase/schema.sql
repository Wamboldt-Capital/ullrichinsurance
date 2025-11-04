-- Supabase schema bootstrap for Noah's Toolbox
-- Run this in the SQL editor of a fresh Supabase project before deploying the site.

-- USERS TABLE -----------------------------------------------------------------
create table if not exists public.users (
  username text primary key,
  password_hash text not null,
  display_name text,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

-- SESSIONS TABLE --------------------------------------------------------------
create table if not exists public.sessions (
  session_token text primary key,
  username text not null references public.users(username) on delete cascade,
  expires_at timestamptz not null,
  created_at timestamptz not null default now()
);

create index if not exists sessions_username_idx on public.sessions (username);
create index if not exists sessions_expires_at_idx on public.sessions (expires_at);

-- WORK DATA TABLE -------------------------------------------------------------
create table if not exists public.work_data (
  user_id text not null references public.users(username) on delete cascade,
  date date not null,
  names jsonb,
  totals jsonb,
  active jsonb,
  clock_start jsonb,
  clock_total bigint default 0,
  list_titles jsonb,
  list_items jsonb,
  inserted_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, date)
);

create index if not exists work_data_user_date_idx on public.work_data (user_id, date);

create or replace function public.touch_work_data_updated_at()
returns trigger as $$
begin
  new.updated_at := now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists work_data_set_updated_at on public.work_data;
create trigger work_data_set_updated_at
before update on public.work_data
for each row
execute function public.touch_work_data_updated_at();

-- ROW LEVEL SECURITY ----------------------------------------------------------
-- The toolbox uses the Supabase anon key directly, so we grant open access
-- to these tables. If you would prefer tighter control, replace these
-- policies with role-specific rules.
alter table public.users enable row level security;
alter table public.sessions enable row level security;
alter table public.work_data enable row level security;

drop policy if exists "Users full access" on public.users;
create policy "Users full access" on public.users
  for all
  using (true)
  with check (true);

drop policy if exists "Sessions full access" on public.sessions;
create policy "Sessions full access" on public.sessions
  for all
  using (true)
  with check (true);

drop policy if exists "Work data full access" on public.work_data;
create policy "Work data full access" on public.work_data
  for all
  using (true)
  with check (true);

-- SAMPLE ADMIN USER -----------------------------------------------------------
-- Replace the password hash with one generated from the login page if needed.
-- (Password: admin)
insert into public.users (username, password_hash, is_admin, display_name)
values (
  'admin',
  '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
  true,
  'Administrator'
)
on conflict (username) do nothing;
