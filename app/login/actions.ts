'use server';
import { redirect } from 'next/navigation';
import { supabaseServer } from '@/lib/supabase';
export async function login(formData: FormData) {
  const supabase = await supabaseServer();
  const email = String(formData.get('email') || '').trim();
  const password = String(formData.get('password') || '');
  const { error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) redirect('/login?error=Unable%20to%20sign%20in');
  redirect('/dashboard');
}
