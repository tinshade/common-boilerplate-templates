'use client';

import { useEffect, useState } from 'react';
import api from '@/lib/api';

export default function Home() {
  const [health, setHealth] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    api
      .get('/api/health')
      .then((res) => setHealth(res.data))
      .catch((err) => setError(err.message));
  }, []);

  return (
    <main>
      <h1>Next.js Starter</h1>
      <p>API: {process.env.NEXT_PUBLIC_API_URL}</p>
      {health && <pre>{JSON.stringify(health, null, 2)}</pre>}
      {error && <p className="error">{error}</p>}
    </main>
  );
}
