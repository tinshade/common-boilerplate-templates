# Next.js + axios

A Next.js (App Router) project with one shared axios instance that has request
and response interceptors set up.

## You'll need

Node.js 20 or newer inside WSL. If you don't have it:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install 22
```

## Run it

```bash
npm install
cp .env.example .env.local
npm run dev
```

Open http://localhost:3000. The home page calls `GET /api/health` on your
backend and prints the result. If the backend isn't running you'll see an
error message instead, which is expected.

## The axios client

Everything lives in `lib/api.js`. Import it anywhere:

```js
import api from '@/lib/api';

const { data } = await api.get('/api/items');
```

What the interceptors do:

- **Request:** if `access_token` is in localStorage, it's sent as
  `Authorization: Bearer <token>`.
- **Response:** network failures get a readable message, and a 401 clears the
  stored token. There's a commented line for redirecting to a login page when
  you have one.

localStorage only exists in the browser, so the client checks for that. Use it
in client components (`'use client'`).

## Config

`NEXT_PUBLIC_API_URL` in `.env.local` sets the backend address. Restart
`npm run dev` after changing it.

## Layout

```
.
├── app/
│   ├── layout.js
│   ├── page.js
│   └── globals.css
├── lib/
│   └── api.js
├── next.config.mjs
├── jsconfig.json
└── package.json
```
