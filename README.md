# HVAC Tek Portal — starter build

A responsive Next.js + Supabase foundation for the HVAC Tek Portal, branded **created & managed by Pienta**.

## Included in this first build
- Public landing page and member sign-in/registration
- New registrations default to `pending`; only approved accounts can enter the portal
- Admin dashboard and member approval/suspend/ban/reinstate controls
- Published application directory
- Global `ALL APPLICATIONS` vs `INDIVIDUAL APP PERMISSIONS` policy switch
- Mobile-responsive layout
- Supabase database schema and row-level security policies

## Not yet included
GitHub repository scanning/import, ZIP ingestion and asset hosting, banner upload/reordering controls, per-member grant editor, audit/activity reporting and Excel export, Stripe billing, and automated deployment. The UI explicitly identifies these as follow-on work rather than pretending they are active.

## Setup
1. Create a Supabase project.
2. In Supabase SQL Editor, run `supabase/schema.sql`.
3. In Authentication → URL Configuration, set the Site URL to your eventual Vercel domain and add its auth redirect URLs.
4. Copy `.env.example` to `.env.local` and fill in the Supabase project URL and anon/publishable key. Never put a service-role key in browser code or commit secrets.
5. Run `npm install`, then `npm run dev`.
6. Register your own account. In Supabase → Table Editor → `profiles`, copy your profile UUID and run the one-time admin bootstrap SQL shown at the bottom of `supabase/schema.sql`. This prevents public self-assignment of admin rights.
7. Deploy the repository to Vercel and add the same public environment variables in Project Settings → Environment Variables.

## Security / hosting notes
- Keep app source repositories public only when you intend the source to be public. A login wall around client-side HTML does not prevent copying; protected source or server-side logic must stay server-side.
- Add only applications and manuals you have rights to distribute.
- The first version stores launch URLs rather than copying repository contents. This avoids breaking relative assets, service workers, local storage, and app routing during an unreviewed import.
- Apps should be hosted on a trusted origin and launched separately. Do not embed arbitrary user-supplied URLs in a privileged portal iframe.
- Supabase RLS is part of the security boundary. Review policies before real member onboarding.

## Suggested next build milestones
1. Secure GitHub repository picker and read-only scan/import queue with admin approval and version rollback.
2. Storage-backed portal banner controls and per-member app grant editor.
3. Audit log for registrations, approvals, logins, and app launches, plus XLSX export.
4. Paid tiers and Stripe billing after free membership flow is tested.
