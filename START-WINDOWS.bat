@echo off
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 (
  py -3 -m http.server 8765 --bind 0.0.0.0
) else (
  python -m http.server 8765 --bind 0.0.0.0
)
