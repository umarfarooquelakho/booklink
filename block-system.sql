-- Add blocked_users table
CREATE TABLE IF NOT EXISTS blocked_users (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  blocked_user_email text NOT NULL,
  blocked_by_user_id uuid REFERENCES auth.users(id),
  reason text DEFAULT 'Book not returned on time',
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE blocked_users ENABLE ROW LEVEL SECURITY;

-- Owner can manage their blocks
CREATE POLICY "Owner manage blocks" ON blocked_users FOR ALL USING (auth.uid() = blocked_by_user_id);

-- Anyone can check if they are blocked
CREATE POLICY "Check own block" ON blocked_users FOR SELECT USING (true);

-- Add return_requested column to book_requests
ALTER TABLE book_requests ADD COLUMN IF NOT EXISTS return_requested boolean DEFAULT false;
ALTER TABLE book_requests ADD COLUMN IF NOT EXISTS return_requested_at timestamptz;
