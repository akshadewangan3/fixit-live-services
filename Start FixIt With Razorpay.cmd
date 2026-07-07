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
set /p FIXIT_API_KEY=Admin password / FIXIT_API_KEY: 

if "%FIXIT_API_KEY%"=="" set FIXIT_API_KEY=12345

echo.
echo Starting FixIt...
echo Open http://localhost:3000 after it starts.
echo.

npm start

pause
