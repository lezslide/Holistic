create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  email text not null unique,
  role text not null default 'student' check (role in ('student', 'admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  class_id text not null,
  created_at timestamptz not null default now(),
  unique (user_id, class_id)
);

alter table public.profiles enable row level security;
alter table public.bookings enable row level security;

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'
  );
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name, email, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)),
    new.email,
    'student'
  )
  on conflict (id) do update
  set
    name = excluded.name,
    email = excluded.email;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

drop policy if exists "Profiles are visible to owner or admin" on public.profiles;
create policy "Profiles are visible to owner or admin"
on public.profiles
for select
to authenticated
using (id = auth.uid() or public.is_admin());

drop policy if exists "Profiles can be inserted by owner" on public.profiles;
create policy "Profiles can be inserted by owner"
on public.profiles
for insert
to authenticated
with check (id = auth.uid());

drop policy if exists "Profiles can be updated by owner or admin" on public.profiles;
create policy "Profiles can be updated by owner or admin"
on public.profiles
for update
to authenticated
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

drop policy if exists "Bookings are visible to owner or admin" on public.bookings;
create policy "Bookings are visible to owner or admin"
on public.bookings
for select
to authenticated
using (user_id = auth.uid() or public.is_admin());

drop policy if exists "Students can create their own bookings" on public.bookings;
create policy "Students can create their own bookings"
on public.bookings
for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists "Bookings can be deleted by owner or admin" on public.bookings;
create policy "Bookings can be deleted by owner or admin"
on public.bookings
for delete
to authenticated
using (user_id = auth.uid() or public.is_admin());

-- Despues de crear la cuenta de Denise desde la web, cambia su rol con:
-- update public.profiles set role = 'admin' where email = 'EMAIL_DE_DENISE';
