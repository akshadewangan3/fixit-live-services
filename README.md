# FixIt Live Services

This is a publishable FixIt marketplace website with a Node.js backend API, OTP-verified customer and worker sign-in, worker verification, incoming booking workflow, a separate admin page, UPI booking, Razorpay Checkout support, WhatsApp review links, and AI-style help chat.

## What changed in this security/design update

Sign-in for customers and workers used to be "type any phone number" with no proof of ownership, which meant anyone could view or act on someone else's account just by knowing (or guessing) their number. That's fixed now:

- **OTP sign-in.** Customers and workers verify their phone with a one-time 6-digit code before they can book, register, or manage anything. See "SMS / OTP setup" below.
- **Session tokens.** After verifying, the app gets a bearer token (like a login session) that's required on every sensitive request. The server derives *who you are* from that token — it no longer trusts a phone number typed into a form field.
- **No more spoofing another phone number.** Booking, reviewing, worker registration, worker profile updates, and accepting/completing jobs are all tied to your verified session, not to whatever phone number happens to be in the request body.
- **Rate limiting** on OTP requests/verifications, admin login, and overall traffic per IP.
- **No hardcoded admin secret.** If you don't set `FIXIT_API_KEY`, the server generates a random one at startup and prints it to the console (it changes on every restart, so set it in `.env` for anything real).
- **File upload validation** now checks the actual file bytes (magic numbers), not just the label the browser sent, so a renamed/mislabeled file can't sneak past the PNG/JPG/WEBP/PDF check.
- **Security headers** (CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, HSTS) on every response.
- **Warm, modern visual refresh** — new color palette, softer rounded cards, and a friendlier feel across the customer, worker, and admin screens.

## SMS / OTP setup

By default, with no SMS provider configured, OTP codes are printed to the **server console** and (only outside `NODE_ENV=production`) included in the API response as `devOtp` so you can test locally without paying for SMS. In production with no provider configured, codes are *not* exposed in the response — they only appear in the server log, so set up a provider before you launch:

**Option A — MSG91** (popular for Indian numbers):
```text
MSG91_AUTH_KEY=your-msg91-authkey
MSG91_TEMPLATE_ID=your-template-id   # optional, if your MSG91 OTP flow needs one
```

**Option B — Twilio**:
```text
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your-twilio-auth-token
TWILIO_FROM_NUMBER=+1xxxxxxxxxx
```

Set one of these (not both) in your `.env` file. No extra npm packages are needed — both are called directly over HTTPS.

## Main flows

- Customers verify their phone with an OTP, then search verified workers and book home services.
- Customers get a panel with Home, Profile, Address, App Settings, and Help & Support.
- Workers verify their phone with an OTP, then register with photo and ID proof, and log back in the same way after verification.
- Workers get verification steps, personal details, dashboard stats, and incoming bookings.
- Admin can verify or reject worker applications from `public/admin.html` or `/admin`.
- Only verified workers become visible to customers, and customer search shows anonymous service/price options instead of worker identity.
- Customer location is used to keep booking and worker accept actions inside a 50 km service radius.
- Admin can track customers, bookings, payment status, worker fleet, reviews, help tickets, and application queue.
- When a worker marks a job complete, the app opens a WhatsApp review message link for the customer.
- Customer reviews support 1-5 stars and tags like Good behaviour and Excellent service.

## Run locally

```powershell
npm start
```

Open:

```text
http://localhost:3000
```

If you haven't set `FIXIT_API_KEY`, check the console output for the generated admin key.
If you haven't set an SMS provider, check the console output for OTP codes when you sign in.

## Private admin API

Set a secret key before publishing:

```powershell
$env:FIXIT_API_KEY="your-strong-secret"
npm start
```

Use the same key in the app's Admin screen to view private bookings, add workers, or delete workers.

Admin also uses this key to verify worker applications.

## Optional payment settings

```powershell
$env:FIXIT_UPI_ID="yourupi@bank"
$env:FIXIT_MERCHANT_NAME="FixIt"
```

## Razorpay setup

Create API keys in your Razorpay Dashboard and set them before starting the server:

```powershell
$env:RAZORPAY_KEY_ID="rzp_test_or_live_key"
$env:RAZORPAY_KEY_SECRET="your_razorpay_secret"
npm start
```

Razorpay payments use the standard Checkout flow:

1. The server creates a Razorpay order.
2. The customer pays in Razorpay Checkout.
3. The server verifies the returned signature.
4. The booking is saved only after successful verification.

If Razorpay keys are not configured, the Razorpay button is disabled and UPI/cash booking still works.

## Publish

Upload this folder to a Node host such as Render, Railway, Fly.io, or any VPS.

Required start command:

```text
npm start
```

Required environment variables:

```text
FIXIT_API_KEY=your-strong-secret
NODE_ENV=production
```

Plus one SMS provider (see "SMS / OTP setup" above) — without one, OTPs only reach the server console, not real phones.

Optional environment variables:

```text
FIXIT_UPI_ID=yourupi@bank
FIXIT_MERCHANT_NAME=FixIt
RAZORPAY_KEY_ID=rzp_test_or_live_key
RAZORPAY_KEY_SECRET=your_razorpay_secret
PORT=3000
```

Data is stored in `data/db.json`. For a high-traffic production app, replace this file storage with a managed database.

Uploaded worker photos and ID files are stored in `public/uploads`. In production, use cloud storage for these documents and protect ID files behind admin authentication.

## Important production note

The WhatsApp review message is opened as a WhatsApp link after the worker marks the job complete. To send WhatsApp messages automatically without a click, you need the official WhatsApp Business API and an approved message template.

