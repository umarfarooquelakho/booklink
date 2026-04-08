-- Enable the http extension (needed to call external APIs)
create extension if not exists http with schema extensions;

-- Function to send email via Resend when a book request is inserted
create or replace function notify_book_owner()
returns trigger as $$
declare
  owner_email text;
  owner_name text;
  book_title text;
  resend_api_key text := 'YOUR_RESEND_API_KEY'; -- Replace with your Resend API key
  email_body text;
  response extensions.http_response;
begin
  -- Get book details
  select b.owner_email, b.posted_by_name, b.title
  into owner_email, owner_name, book_title
  from books b
  where b.id = NEW.book_id;

  -- Build email body
  email_body := json_build_object(
    'from', 'BookLink <onboarding@resend.dev>',
    'to', owner_email,
    'subject', '📚 New Book Request: ' || book_title,
    'html', '<div style="font-family:sans-serif;max-width:600px;margin:0 auto;padding:20px;">
      <h2 style="color:#323d89;">📚 New Book Request on BookLink</h2>
      <p>Hi <strong>' || coalesce(owner_name, 'there') || '</strong>,</p>
      <p>Someone is interested in your book <strong>"' || book_title || '"</strong>!</p>
      <hr style="border:1px solid #eee;margin:20px 0;">
      <h3 style="color:#323d89;">Requester Details:</h3>
      <p>📧 <strong>Email:</strong> ' || NEW.requester_email || '</p>
      <p>📞 <strong>Phone:</strong> ' || coalesce(NEW.requester_phone, 'Not provided') || '</p>
      ' || case when NEW.message is not null and NEW.message != '' then '<p>💬 <strong>Message:</strong> ' || NEW.message || '</p>' else '' end || '
      <hr style="border:1px solid #eee;margin:20px 0;">
      <p style="color:#666;font-size:14px;">Please reach out to the requester directly to arrange the book handover.</p>
      <p style="color:#323d89;font-weight:bold;">— The BookLink Team 📚</p>
    </div>'
  )::text;

  -- Send email via Resend API
  SELECT * INTO response FROM extensions.http((
    'POST',
    'https://api.resend.com/emails',
    ARRAY[
      extensions.http_header('Authorization', 'Bearer ' || resend_api_key),
      extensions.http_header('Content-Type', 'application/json')
    ],
    'application/json',
    email_body
  )::extensions.http_request);

  return NEW;
end;
$$ language plpgsql security definer;

-- Create trigger on book_requests table
drop trigger if exists on_book_request_created on book_requests;
create trigger on_book_request_created
  after insert on book_requests
  for each row execute function notify_book_owner();
