# Vite + axios

Plain JavaScript on Vite, no framework. One shared axios instance with request
and response interceptors. Handy for small tools, or as a base if you want to
add a framework of your own later.

## You'll need

Node.js 20.19 or newer inside WSL. If you don't have it:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install 22
```

## Run it

```bash
npm install
cp .env.example .env
npm run dev
```

Open http://localhost:5173. The page calls `GET /api/health` on your backend
and shows the result, or an error if the backend isn't up yet.

## The axios client

It's in `src/api/client.js`:

```js
import api from './api/client';

const { data } = await api.get('/api/items');
```

What the interceptors do:

- **Request:** if `access_token` is in localStorage, it's sent as
  `Authorization: Bearer <token>`.
- **Response:** network failures get a readable message, and a 401 clears the
  stored token. There's a commented line for redirecting to a login page.

## Config

`VITE_API_URL` in `.env` sets the backend address. Restart `npm run dev` after
changing it.

## Layout

```
.
├── src/
│   ├── api/client.js
│   ├── main.js
│   └── style.css
├── index.html
└── package.json
```

## Build

```bash
npm run build      # output goes to dist/
npm run preview    # serve the build locally
```
