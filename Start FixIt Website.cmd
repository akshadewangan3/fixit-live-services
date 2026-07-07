@echo off
cd /d "%~dp0"
echo Starting FixIt at http://localhost:3000
echo.
echo If FIXIT_API_KEY is not set in a .env file, a random admin key will be
echo generated and printed in this window each time the server starts.
echo OTP codes (for customer/worker sign-in) will also print here unless
echo you set MSG91_AUTH_KEY or TWILIO_* in .env. See .env.example for details.
echo.
start "" "http://localhost:3000"
npm start
