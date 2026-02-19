@echo off
color A
chcp 65001 >nul
title Gless_Batch

:: Verifica Privilégios de Administrador
call :VerPrevAdmin
if "%Admin%"=="ops" goto :eof

set "arquivo=C:\Windows\system.ini"
set "GUIPPEPath=%~dp0Tools"

:: Verifica se a pasta Tools existe
If Not Exist "%GUIPPEPath%" (
    cls
    echo.
    echo      Execute o script junto a pasta "Tools". . .
    timeout 5 >nul
    Exit
)

setlocal enabledelayedexpansion

:menu
cls
mode 70,25
echo.
echo =====================================================
echo  Computador: %computername%        Usuario: %username%
echo  Data: %date%
echo =====================================================
echo                MENU TAREFAS - Suporte Windows
echo =====================================================
echo.
echo  1. Otimizacao do Sistema
echo  2. Encerramento mais rapido
echo  3. Reset Spool Impressora
echo  4. Renovar IP da maquina
echo  5. Desinstalar atualizacoes do Windows Update
echo  6. Desativar Windows Update
echo  7. Otimizacao Taxa de Transferencia
echo  8. Modo Desempenho Maximo (Plano de Energia)
echo  9. Limpar Arquivos Temporarios
echo  10. Corrigir Sites Confiaveis e Desbloquear PDFs
echo 11. Corrigir Anydesk
echo.
echo =====================================================
set /p opcao= Escolha uma opcao: 
echo -----------------------------------------------------

if "%opcao%"=="1" goto opcao1
if "%opcao%"=="2" goto opcao2
if "%opcao%"=="3" goto opcao3
if "%opcao%"=="4" goto opcao4
if "%opcao%"=="5" goto opcao5
if "%opcao%"=="6" goto opcao6
if "%opcao%"=="7" goto opcao7
if "%opcao%"=="8" goto opcao8
if "%opcao%"=="9" goto opcao9
if "%opcao%"=="10" goto opcao10
if "%opcao%"=="11" goto opcao11
goto menu

:opcao1
cls
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 55 /f 
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 60 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 2000 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v ContigFileAllocSize /t REG_DWORD /d 200 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d y /f
wmic os get OSArchitecture | findstr "64-bit" >nul
if %errorlevel% neq 0 (
    echo Sistema 32-bit detectado.
    (echo [386Enh] & echo 32BitDiskAccess=on & echo 32BitFileAccess=on) > "%arquivo%.tmp"
) else (
    echo Sistema 64-bit detectado.
    (echo [386Enh] & echo 64BitDiskAccess=on & echo 64BitFileAccess=on) > "%arquivo%.tmp"
)
move /y "%arquivo%.tmp" "%arquivo%" >nul
net stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul
echo Otimizacao concluida!
pause
goto menu

:opcao2
cls
if exist "%GUIPPEPath%\REG_BOOSTER_Update.reg" (
    regedit /s "%GUIPPEPath%\REG_BOOSTER_Update.reg"
    echo SpeedBooster aplicado!
) else (
    echo Arquivo REG_BOOSTER_Update.reg nao encontrado em Tools.
)
pause
goto menu

:opcao3
cls
net stop Spooler >nul 2>&1
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*" >nul 2>&1
net start Spooler >nul
echo Servico de impressao reiniciado!
pause
goto menu

:opcao4
cls
ipconfig /release & ipconfig /flushdns & ipconfig /renew & ipconfig /registerdns
echo Rede renovada com sucesso!
pause
goto menu

:opcao5
cls
echo Listando updates, aguarde...
wmic qfe get HotFixID >"%temp%\kbuplist.txt"
set count=0
for /f "skip=1 delims=KB " %%# in ('type "%temp%\kbuplist.txt"') do (
    set /a count+=1
    set up_kb[!count!]=%%#
)
for /l %%x in (1,1,!count!) do echo [%%x] Update KB!up_kb[%%x]!
set /p sel_kb= Digite o numero da opcao: 
if defined up_kb[%sel_kb%] (
    echo Desinstalando KB!up_kb[%sel_kb%]!...
    wusa /uninstall /kb:!up_kb[%sel_kb%]! /norestart
)
pause
goto menu

:opcao6
cls
net stop wuauserv >nul 2>&1
sc config wuauserv start=disabled >nul
echo Windows Update Desativado.
pause
goto menu

:opcao7
cls
echo Otimizando transferencia USB...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\05DCA431" /v MaximumTransferLength /t REG_DWORD /d 2097120 /f >nul
echo Concluido!
pause
goto menu

:opcao8
cls
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
echo Plano de Desempenho Maximo Ativado!
pause
goto menu

:opcao9
cls
del /f /s /q %temp%\*.* >nul 2>&1
echo Arquivos temporarios removidos.
pause
goto menu

:opcao10
cls
echo ==================================
echo   CONFIGURANDO SITES E PDFS
echo ==================================

:: 1. Desmarca "Exigir verificação do servidor (https:)" para Sites Confiáveis
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "Flags" /t REG_DWORD /d 67 /f >nul

:: 2. Adiciona o nome do servidor (protocolo file)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\servidor" /v "file" /t REG_DWORD /d 2 /f >nul

:: 3. Adiciona o IP 192.168.3.2 aos Sites Confiáveis (Todos os protocolos)
:: O "*" define que vale para qualquer protocolo (http, https, ftp, etc)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range1" /v ":Range" /t REG_SZ /d "192.168.1.2" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range1" /v "*" /t REG_DWORD /d 2 /f >nul

:: 4. Adiciona o IP 192.168.3.2 aos Sites Confiáveis (Todos os protocolos)
:: O "*" define que vale para qualquer protocolo (http, https, ftp, etc)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range1" /v ":Range" /t REG_SZ /d "192.168.1.3" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range1" /v "*" /t REG_DWORD /d 2 /f >nul

:: 5. Desbloqueia PDFs com caminho relativo ao usuário logado
echo Desbloqueando arquivos do usuario %username%...
powershell -Command "Get-ChildItem '%USERPROFILE%\*.pdf', '%USERPROFILE%\Desktop\*.pdf', '%USERPROFILE%\Downloads\*.pdf' -ErrorAction SilentlyContinue | Unblock-File"

echo.
echo ==================================
echo * Processo concluido com sucesso! *
echo ==================================
pause
goto menu

:opcao11
cls
RD /s /q "%appdata%\AnyDesk" 
RD /s /q "C:\Program Files (x86)\AnyDesk"
 
echo ==================================
echo *      Removido Cache e temps do Anydesk *
echo ==================================
pause
goto menu

:: --- FUNÇÕES DE SISTEMA ---

:VerPrevAdmin
fsutil dirty query %systemdrive% >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando privilegios de administrador...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    set "Admin=ops"
    exit /b
)
goto :eof