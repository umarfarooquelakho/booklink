-- Add loan tracking columns to books table
ALTER TABLE books ADD COLUMN IF NOT EXISTS loan_status text DEFAULT 'available';
-- loan_status: 'available', 'on_loan', 'returned'

ALTER TABLE books ADD COLUMN IF NOT EXISTS loan_due_date timestamptz;
ALTER TABLE books ADD COLUMN IF NOT EXISTS borrower_email text;
ALTER TABLE books ADD COLUMN IF NOT EXISTS borrower_name text;
ALTER TABLE books ADD COLUMN IF NOT EXISTS loan_start_date timestamptz;

-- Add loan_days to book_requests
ALTER TABLE book_requests ADD COLUMN IF NOT EXISTS loan_days integer DEFAULT 14;
ALTER TABLE book_requests ADD COLUMN IF NOT EXISTS due_date timestamptz;
ALTER TABLE book_requests ADD COLUMN IF NOT EXISTS borrower_name text;
