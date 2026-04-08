-- Allow everyone (including non-logged-in users) to read all books
drop policy if exists "Public read books" on books;
create policy "Public read books" on books for select using (true);

-- Allow everyone to read book requests (needed for profile page)
drop policy if exists "Read own requests" on book_requests;
create policy "Read own requests" on book_requests for select using (true);
