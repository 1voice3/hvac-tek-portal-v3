'use server';
import { redirect } from 'next/navigation';
import { supabaseServer } from '@/lib/supabase';
export async function register(formData: FormData) {
  const supabase = await supabaseServer();
  const display_name = String(formData.get('name') || '').trim();
  const email = String(formData.get('email') || '').trim().toLowerCase();
  const password = String(formData.get('password') || '');
  if (password.length < 10) redirect('/register?error=Password%20must%20be%20at%20least%2010%20characters');
  const { error } = await supabase.auth.signUp({ email, password, options: { data: { display_name } } });
  if (error) redirect('/register?error=Registration%20could%20not%20be%20completed');
  redirect('/pending');
}
