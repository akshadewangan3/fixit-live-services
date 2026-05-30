@echo off
title Start FixIt With Razorpay
cd /d "%~dp0"

echo.
echo FixIt Razorpay Starter
echo -----------------------
echo Paste your Razorpay TEST keys below.
echo.

RAZORPAY_KEY_ID=your_key
RAZORPAY_KEY_SECRET=your_secret
FIXIT_API_KEY=12345

if "%FIXIT_API_KEY%"=="" set FIXIT_API_KEY=12345

echo.
echo Starting FixIt...
echo Open http://localhost:3000 after it starts.
echo.

npm start

pause
