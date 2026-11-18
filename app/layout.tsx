import './globals.css';
import type { Metadata } from 'next';
export const metadata: Metadata = { title: 'HVAC Tek Portal', description: 'HVAC tools, technical references, and learning resources. Created & managed by Pienta.' };
export default function RootLayout({ children }: Readonly<{children: React.ReactNode}>) {
  return <html lang="en"><body>{children}</body></html>;
}
