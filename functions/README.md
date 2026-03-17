# Gemini Proxy (Firebase Functions)

This folder contains a Firebase Functions template that exposes a single POST endpoint `/generate`.
The function accepts a JSON body `{ "prompt": "..." }` and returns `{ "reply": "..." }` by calling Google's Generative Language API (Gemini) from the server.

Security
- Do NOT commit your API key. Use a `.env` file locally and set the environment variable in Cloud Functions with `gcloud functions deploy` or via the Firebase console.

Setup (local testing)
1. cd functions
2. cp .env.example .env and set `GEN_API_KEY`
3. npm install
4. Run locally with the Firebase emulator or `node index.js` using a small wrapper (this template is structured for Firebase Functions).

Deploy (Firebase Functions)
1. Install Firebase CLI and login: `npm i -g firebase-tools` then `firebase login`
2. Initialize functions if not already: `firebase init functions` (choose existing project)
3. Deploy:

```
cd functions
npm install
firebase deploy --only functions:api
```

After deployment you'll get a URL like `https://<region>-<project>.cloudfunctions.net/api/generate`.

Flutter
- Point `AiAssistantScreen`'s `_backendUrl` to the deployed URL.

Notes
- For production prefer using service account authentication (not API key) and restrict/rotate keys.
- Consider adding rate-limiting and input validation.
