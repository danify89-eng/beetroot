@echo off
REM Twice-daily auto-loop: refresh positions/stops, regenerate dashboard, push to GitHub.
REM cPanel's hourly cron then pulls it to the live site.
set PY="C:\Users\TAN ZHI HUI\AppData\Local\Python\pythoncore-3.14-64\python.exe"
set LOG=C:\wamp64\www\beetroot\paper-trader\logs\auto.log

echo ===== %DATE% %TIME% ===== >> %LOG%
cd /d C:\wamp64\www\beetroot\paper-trader
%PY% main.py --once >> %LOG% 2>&1
%PY% -m src.technicals >> %LOG% 2>&1
%PY% dashboard.py >> %LOG% 2>&1

cd /d C:\wamp64\www\beetroot
copy /Y paper-trader\public\dashboard.html index.html >> %LOG% 2>&1
git add index.html >> %LOG% 2>&1
git commit -m "Auto dashboard update %DATE% %TIME%" >> %LOG% 2>&1
git push origin main >> %LOG% 2>&1
echo ----- done ----- >> %LOG%
