import Link from 'next/link';
import { supabaseServer } from '@/lib/supabase';
export default async function Home() {
  const supabase = await supabaseServer();
  const { data: { user } } = await supabase.auth.getUser();
  return <main className="landing"><div className="hero"><div className="eyebrow">THE HVAC TECHNICIAN'S WORKSPACE</div><h1>HVAC Tek Portal</h1><p className="subtitle">created &amp; managed by Pienta</p><p className="lead">A central library of HVAC applications, field tools, technical references, and training resources.</p><div className="actions"><Link className="button primary" href={user ? '/dashboard' : '/login'}>{user ? 'Open portal' : 'Member sign in'}</Link><Link className="button secondary" href="/register">Request membership</Link></div></div><footer>Built for the people who keep buildings running.</footer></main>;
}
