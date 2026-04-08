-- Run this in Supabase → SQL Editor

-- Books table
create table books (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  author text not null,
  year text,
  genre text,
  isbn text,
  rating text,
  review text,
  cover_url text,
  posted_by_name text,
  user_id uuid references auth.users(id),
  owner_email text,
  owner_phone text,
  owner_location text,
  landed boolean default false,
  created_at timestamptz default now()
);

-- Book requests table
create table book_requests (
  id uuid default gen_random_uuid() primary key,
  book_id uuid references books(id) on delete cascade,
  requester_email text,
  requester_phone text,
  message text,
  status text default 'pending',
  created_at timestamptz default now()
);

-- Bookmarks table
create table bookmarks (
  user_id uuid references auth.users(id),
  book_id uuid references books(id) on delete cascade,
  primary key (user_id, book_id)
);

-- Enable Row Level Security
alter table books enable row level security;
alter table book_requests enable row level security;
alter table bookmarks enable row level security;

-- RLS Policies: anyone can read books
create policy "Public read books" on books for select using (true);
-- Only authenticated users can insert books
create policy "Auth insert books" on books for insert with check (auth.uid() = user_id);
-- Only owner can update/delete
create policy "Owner update books" on books for update using (auth.uid() = user_id);
create policy "Owner delete books" on books for delete using (auth.uid() = user_id);

-- Book requests: anyone authenticated can insert
create policy "Auth insert requests" on book_requests for insert with check (auth.role() = 'authenticated');
-- Book owner can read requests for their books
create policy "Read own requests" on book_requests for select using (
  exists (select 1 from books where books.id = book_requests.book_id and books.user_id = auth.uid())
);
create policy "Owner manage requests" on book_requests for update using (
  exists (select 1 from books where books.id = book_requests.book_id and books.user_id = auth.uid())
);
create policy "Owner delete requests" on book_requests for delete using (
  exists (select 1 from books where books.id = book_requests.book_id and books.user_id = auth.uid())
);

-- Bookmarks: users manage their own
create policy "Own bookmarks" on bookmarks for all using (auth.uid() = user_id);
