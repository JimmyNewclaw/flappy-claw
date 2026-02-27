-- Run this in Supabase SQL editor for Flappy Claw tournament mode

create table if not exists public.tournament_entries (
  id bigserial primary key,
  name text not null,
  contact text not null,
  score integer not null check (score >= 0),
  created_at timestamptz not null default now()
);

alter table public.tournament_entries enable row level security;

-- public read for leaderboard
create policy if not exists "tournament_entries_select_public"
on public.tournament_entries
for select
using (true);

-- public insert for submissions
create policy if not exists "tournament_entries_insert_public"
on public.tournament_entries
for insert
with check (
  char_length(name) between 1 and 20
  and char_length(contact) between 3 and 60
  and score >= 0 and score <= 9999
);

create index if not exists tournament_entries_score_idx
on public.tournament_entries (score desc, created_at asc);
