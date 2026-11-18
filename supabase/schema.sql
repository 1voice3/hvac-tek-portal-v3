-- Run this entire file in Supabase SQL Editor before deploying.
create type public.member_status as enum ('pending','approved','suspended','banned');
create type public.member_role as enum ('member','admin');
create table public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 email text,
 display_name text,
 role public.member_role not null default 'member',
 status public.member_status not null default 'pending',
 created_at timestamptz not null default now()
);
create table public.apps (
 id uuid primary key default gen_random_uuid(),
 name text not null,
 description text,
 category text default 'HVAC Tools',
 launch_url text not null,
 icon_emoji text default '⚙️',
 published boolean not null default false,
 sort_order integer not null default 0,
 created_at timestamptz not null default now()
);
create table public.app_permissions (
 user_id uuid not null references public.profiles(id) on delete cascade,
 app_id uuid not null references public.apps(id) on delete cascade,
 primary key(user_id,app_id)
);
create table public.portal_settings (
 id integer primary key check (id=1),
 access_mode text not null default 'all' check(access_mode in ('all','individual')),
 banner_url text,
 banner_height integer not null default 230,
 updated_at timestamptz not null default now()
);
insert into public.portal_settings(id) values(1) on conflict do nothing;

create function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.profiles(id,email,display_name,status)
 values(new.id,new.email,coalesce(new.raw_user_meta_data->>'display_name',''), 'pending');
 return new;
end; $$;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

create function public.is_approved_member() returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.profiles where id=auth.uid() and status='approved'); $$;
create function public.is_portal_admin() returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.profiles where id=auth.uid() and role='admin' and status='approved'); $$;

alter table public.profiles enable row level security;
alter table public.apps enable row level security;
alter table public.app_permissions enable row level security;
alter table public.portal_settings enable row level security;
create policy "members read own profile" on public.profiles for select to authenticated using(id=auth.uid() or public.is_portal_admin());
create policy "admins update profiles" on public.profiles for update to authenticated using(public.is_portal_admin()) with check(role <> 'admin' or public.is_portal_admin());
create policy "approved members read published apps" on public.apps for select to authenticated using(public.is_approved_member() and published);
create policy "admins manage apps" on public.apps for all to authenticated using(public.is_portal_admin()) with check(public.is_portal_admin());
create policy "members read own grants" on public.app_permissions for select to authenticated using(user_id=auth.uid() or public.is_portal_admin());
create policy "admins manage grants" on public.app_permissions for all to authenticated using(public.is_portal_admin()) with check(public.is_portal_admin());
create policy "approved members read portal settings" on public.portal_settings for select to authenticated using(public.is_approved_member());
create policy "admins update portal settings" on public.portal_settings for update to authenticated using(public.is_portal_admin()) with check(public.is_portal_admin());

-- First admin bootstrap: after the first account is registered, replace the UUID below
-- with that user's auth.users id and run this once in SQL Editor.
-- update public.profiles set role='admin', status='approved' where id='YOUR-USER-UUID';
