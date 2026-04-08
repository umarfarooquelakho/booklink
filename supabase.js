// ============================================================
// BOOKLINK - Supabase Configuration
// Replace these values with your actual Supabase project details
// Settings → API in your Supabase dashboard
// ============================================================
const SUPABASE_URL = 'https://xvsqquxofhltowomjjgo.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2c3FxdXhvZmhsdG93b21qamdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2MjEzODUsImV4cCI6MjA5MTE5NzM4NX0.L7ijViJI4SNmFYvVujwPYlROp-cRSZ2MY7YylbvhQlQ';

const { createClient } = supabase;
const sb = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
