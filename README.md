# Sentinel — compact source

This is the complete, condensed application: the existing design, logos, manual globe controls, date-line correction, password gate, shared reports, log uploads, automatic field population, source/target routes, analyst location review, and rule-based pattern analysis.

## Upload to your shared GitHub repository

1. Extract the ZIP and open its `sentinel` folder.
2. In your repository choose **Add file → Upload files**.
3. Drag all of this folder's contents into the upload area. There are only 12 files. Include `.gitignore` (Windows may hide it).
4. Commit the changes. Give your partners repository access so they can edit the same source.

Do not upload the ZIP itself as a substitute for the individual files. Your existing hosted Sentinel site continues to run unchanged. GitHub edits do not automatically update that site.

## Where to make changes

- `app.jsx`: all interface components, icons, parsing preview, analysis presentation, globe rendering, synthetic demo, and embedded logos. Section comments identify the original components. Search for `function Sentinel`, `ReportForm`, `Globe`, or `ThreatPanel`.
- `styles.css`: the exact compiled stylesheet used by the existing design, including responsive layouts.
- `worker.js`: password/session checking, API routes, log normalization, detection rules, source enrichment, and persistence. Original module section comments remain. No production password is included.
- Map geometry and logos are embedded in `app.jsx`; geographic attribution is also served by `worker.js`.
- `0001_initial.sql`: database schema.
- `wrangler.jsonc`: hosting and storage bindings.
- `verify.mjs`: isolated server/parser/rule/geometry workflow checks.

The two code files are consolidated readable JavaScript, not encrypted or minified. Shared parsing and geography helpers are intentionally present in both frontend and server so the server independently validates uploaded evidence. Third-party icon license is in NOTICE.txt.

## Run or deploy from this repository

This compact export uses Vite for the React interface and Cloudflare Workers, D1, and R2 for the backend. It replaces the larger Sites/Vinext build scaffolding; it is **not** a drop-in replacement for the existing Sites repository. The app features and API contract are retained. Hosting credentials and storage must be configured separately.

Install Node.js 24 or newer, then open a terminal in this folder:

```
npm install
npm test
npm run build
```

For local use, create an untracked `.dev.vars` file containing `SITE_PASSWORD="your-local-test-password"`. Run `npm run db:local` once, then `npm run dev`. Open the localhost URL Wrangler prints. Local databases and logs are separate from the live site.

For a new Cloudflare deployment:

1. Authenticate using `npx wrangler login`.
2. Create a database using `npx wrangler d1 create sentinel-db`. Replace the placeholder `database_id` in `wrangler.jsonc` with the returned ID.
3. Create file storage using `npx wrangler r2 bucket create sentinel-logs`. R2 must be available for your account. If choosing another bucket name, update the configuration.
4. Run `npm run db:remote` to create the tables in the new database.
5. Set the production password using `npx wrangler secret put SITE_PASSWORD` and enter it at the prompt. Never commit the value.
6. Run `npm run deploy` and open the returned website URL.

The placeholder database ID is for local development only. Do not apply the initial migration to an existing Sentinel database: this schema is intended for a new database. To move existing saved reports and logs, perform a separate data migration. Deploying this export does not transfer live data, sessions, or secrets.

## Evidence semantics

Same thresholds and limits as the hosted MVP: up to 500 KB and 1,500 normalized events per upload, analysis of the latest 5,000 events, up to 100 signals, and up to 100 plotted routes. Country locations are approximate. Unknown sources remain unplotted until an analyst supplies geography. Pattern findings require review and do not establish attacker identity. No external IP geolocation or AI API is called.

The exported password gate remains server-side. Original logs are stored in R2, shared records and opaque expiring sessions in D1. Runtime database contents, uploaded logs, passwords, local environments, build outputs, dependencies, and Git history are excluded.
