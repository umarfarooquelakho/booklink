-- Delete only dummy/seeded books (those with no real user_id)
-- Your 2 real posted books have a user_id so they are safe
DELETE FROM books WHERE user_id IS NULL;
