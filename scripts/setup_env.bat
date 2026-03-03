@echo off
:: Переходим в папку, где лежит сам скрипт
cd /d "%~dp0.."

set ENV_NAME=week1_env

echo [1/3] Checking Conda...
:: Используем полный путь к conda.bat, если обычный вызов глючит
call conda --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Conda NOT FOUND. Please run this in 'Anaconda Prompt'.
    pause
    exit /b 1
)

echo [2/3] Preparing environment: %ENV_NAME%...
:: Проверяем существование окружения
call conda env list | findstr /c:"%ENV_NAME%" >nul
if errorlevel 1 (
    echo Creating new environment...
    call conda create -n %ENV_NAME% python=3.10 -y
) else (
    echo Environment %ENV_NAME% already exists.
)

echo [3/3] Installing dependencies and testing...
:: Явно указываем файлы, чтобы conda их точно нашла
call conda run -n %ENV_NAME% python -m pip install -r requirements.txt
call conda run -n %ENV_NAME% python broken_env.py

if errorlevel 1 (
    echo ====================================
    echo [ERROR] SMOKE TEST FAILED!
) else (
    echo ====================================
    echo [OK] EVERYTHING IS READY!
)

pause
