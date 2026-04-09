-- Drop all existing book_requests policies
drop policy if exists "Auth insert requests" on book_requests;
drop policy if exists "Owner read requests" on book_requests;
drop policy if exists "Owner update requests" on book_requests;
drop policy if exists "Owner delete requests" on book_requests;
drop policy if exists "Read own requests" on book_requests;

-- Allow ANY visitor (even not logged in) to insert a request
create policy "Anyone can insert requests" on book_requests
  for insert with check (true);

-- Book owner can read requests for their books
create policy "Owner read requests" on book_requests
  for select using (
    exists (
      select 1 from books
      where books.id = book_requests.book_id
      and books.user_id = auth.uid()
    )
  );

-- Book owner can update (approve/reject)
create policy "Owner update requests" on book_requests
  for update using (
    exists (
      select 1 from books
      where books.id = book_requests.book_id
      and books.user_id = auth.uid()
    )
  );

-- Book owner can delete requests
create policy "Owner delete requests" on book_requests
  for delete using (
    exists (
      select 1 from books
      where books.id = book_requests.book_id
      and books.user_id = auth.uid()
    )
  );
