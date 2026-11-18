import { redirect } from 'next/navigation';
import { supabaseServer } from '@/lib/supabase';

export async function requireUser() {
  const supabase = await supabaseServer();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect('/login');
  const { data: profile } = await supabase.from('profiles').select('id,email,role,status,display_name').eq('id', user.id).single();
  if (!profile || profile.status !== 'approved') redirect('/pending');
  return { supabase, user, profile };
}

export async function requireAdmin() {
  const ctx = await requireUser();
  if (ctx.profile.role !== 'admin') redirect('/dashboard');
  return ctx;
}
