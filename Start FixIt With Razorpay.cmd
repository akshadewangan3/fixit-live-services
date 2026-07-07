@echo off
title Start FixIt With Razorpay
cd /d "%~dp0"

echo.
echo FixIt Razorpay Starter
echo -----------------------
echo Paste your Razorpay TEST keys below.
echo.

set /p RAZORPAY_KEY_ID=RAZORPAY_KEY_ID: 
set /p RAZORPAY_KEY_SECRET=RAZORPAY_KEY_SECRET: 
set /p FIXIT_API_KEY=Admin API key (leave blank to auto-generate one, printed on start): 

echo.
echo Starting FixIt...
echo Open http://localhost:3000 after it starts.
if "%FIXIT_API_KEY%"=="" echo No admin key entered - a random one will be generated and printed below.
echo OTP codes for customer/worker sign-in will print here unless you set
echo MSG91_AUTH_KEY or TWILIO_* in a .env file. See .env.example for details.
echo.

npm start

pause
