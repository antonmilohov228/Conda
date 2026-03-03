@echo off
chcp 65001 > nul
set ENV_NAME=week1_env
set PYTHON_VERSION=3.10

echo [1/4] Проверка наличия Conda...
call conda --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Conda не найдена. Убедитесь, что Anaconda/Miniconda установлена и добавлена в PATH.
    exit /b 1
)

echo [2/4] Проверка окружения %ENV_NAME%...
call conda info --envs | findstr /b /c:"%ENV_NAME% " >nul
if errorlevel 1 (
    echo Окружение не найдено. Создаем %ENV_NAME% с Python %PYTHON_VERSION%...
    call conda create -n %ENV_NAME% python=%PYTHON_VERSION% -y
) else (
    echo Окружение %ENV_NAME% уже существует. Пропускаем создание.
)

echo [3/4] Установка зависимостей...
call conda run -n %ENV_NAME% python -m pip install -r requirements.txt

echo [4/4] Запуск smoke test (broken_env.py)...
call conda run -n %ENV_NAME% python broken_env.py

if errorlevel 1 (
    echo ====================================
    echo [ERROR] Smoke test провален! (exit code 1)
    exit /b 1
) else (
    echo ====================================
    echo [OK] Окружение готово и работает! (exit code 0)
)
pause
exit /b 0
