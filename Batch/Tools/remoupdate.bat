@echo off
chcp 1252 >nul

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
cls
:menu
cls
mode 70,15
color A

date /t

echo Computador: %computername%        Usuario: %username%
cls
@Echo off
mode 70,5
net stop wuauserv >nul
sc config wuauserv start=disabled >nul
color 1E
chcp 1252 >nul


setlocal enabledelayedexpansion

:startgenlist
cls
set "kpuplist="
set "count="
set "up_kb[!count!]="
set "sel_kb="
set "UninstOneKB="
echo.
echo.
echo    Listando updates, aguarde. . .
timeout 3 >nul
wmic qfe get HotFixID >"%temp%\kbuplist.txt"
set count=0
for /f "skip=1 delims=KB " %%# in ('TYPE "%temp%\kbuplist.txt"') do (
  set /a count=count+1
  set up_kb[!count!]=%%#
  )
)
set /a wlines=!count!+13
mode 70,%wlines%
cls
echo         Desinstalar atualizações do Windows
echo.
echo         ====================================================
echo.
echo         Escolha a atualização que deseja desinstalar. . .
echo.
for /l %%x in (1,1,!count!) do (
  echo             [%%x]  Update KB!up_kb[%%x]!
)
echo.
echo             [A]  Desinstalar todos os updates acima.
echo.
echo         ====================================================
echo.
set /p sel_kb=^>       Digite a opção correspondente e pressione "enter": 
if not defined sel_kb cls&echo.&echo   Foi pressionado "enter" sem digitar uma opção.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
set "SelErrorKB="&for /f "delims=0123456789Aa" %%i in ("%sel_kb%") do set SelErrorKB=%%i
if defined SelErrorKB cls&echo.&echo   Você digitou "%sel_kb%". Esse caractere é inválido.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [0] cls&echo.&echo   Você digitou "%sel_kb%". Olhe com mais atenção a lista de opções.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [Aa] cls&echo.&echo   Você digitou "%sel_kb%". Olhe com mais atenção a lista de opções.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [aA] cls&echo.&echo   Você digitou "%sel_kb%". Olhe com mais atenção a lista de opções.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [A] goto UninstAllKB
if [%sel_kb%] equ [a] goto UninstAllKB
if [%sel_kb%] Leq [!count!] set "UninstOneKB=!up_kb[%sel_kb%]!"&goto UninstOneKB
if not [%sel_kb%] Leq [!count!] cls&echo.&echo   Você digitou "%sel_kb%". Olhe com mais atenção a lista de opções.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist

:UninstOneKB
cls
mode 70,5
echo.
echo.
echo    Desinstalando Update KB%UninstOneKB%. . .
start /w "" wusa  /uninstall /kb: %UninstOneKB% 
timeout 3 >nul
cls
echo.
echo.
echo    A operação foi concluída com êxito.
del /Q /F "%temp%\kbuplist.txt" >nul 2>&1
timeout 3 >nul
goto menu

:UninstAllKB
cls
mode 70,5
for /l %%x in (1,1,!count!) do (
  cls
  echo.
  echo.
  echo    Desinstalando Update KB!up_kb[%%x]!. . .
  start /w "" wusa  /uninstall /kb:!up_kb[%%x]! 
  timeout 3 >nul
)
cls
echo.
echo.
echo    As operações foram concluídas com êxito.
del /Q /F "%temp%\kbuplist.txt" >nul 2>&1
timeout 3 >nul
goto menu

:opcao6
cls
net stop wuauserv >nul
sc config wuauserv start=disabled >nul
echo ==================================
echo *      Removido Atualizacao automática do Windows Update        *
echo ==================================
pause
goto menu