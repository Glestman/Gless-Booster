@echo off
color A
chcp 65001 >nul
title Gless_Batch

::set "params=%*"
::cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

call :VerPrevAdmin
if "%Admin%"=="ops" goto :eof

set "arquivo=C:\Windows\system.ini"
set "GUIPPEPath=%~dp0Tools"
If Not Exist "%GUIPPEPath%" cls & echo. & echo. & echo     Execute o script junto à pasta "Tools". . .& timeout 5 >nul & Exit

setlocal enabledelayedexpansion

:menu
cls
mode 70,22
echo.
echo.
date /t
echo Computador: %computername%        Usuario: %username%

Title Ferramenta de Suporte do Windows by @Glestman

echo  ==================================                   
echo            MENU TAREFAS
echo  ==================================
echo.
echo * 1. Otimizacao do Sistema            
echo * 2. Encerramento mais rapido                            
echo * 3. Reset Spool Impressora           
echo * 4. Renovar IP da maquina           
echo * 5. Desinstalar atualizacoes do Windows Update  
echo * 6. Desativar Windows Update 
echo * 7. Otimizacao Taxa de Transferencia      
echo * 8. Modo  Desempenho Maximo Plano de Energia 
echo * 9. Limpar Arquivos Temporrios
echo.
echo  ==================================
set /p opcao= Escolha uma opcao: 
echo ------------------------------
if %opcao% equ 1 goto opcao1
if %opcao% equ 2 goto opcao2
if %opcao% equ 3 goto opcao3
if %opcao% equ 4 goto opcao4
if %opcao% equ 5 goto opcao5
if %opcao% equ 6 goto opcao6
if %opcao% equ 7 goto opcao7
if %opcao% equ 8 goto opcao8
if %opcao% equ 9 goto opcao9


:opcao1
cls
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 55 /f 
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 60 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 2000 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v ContigFileAllocSize /t REG_DWORD /d 200 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d y /f
wmic os get OSArchitecture | findstr "64 bit" >nul && (

    if "%errorlevel%" neq "0" (
        echo O sistema e de 32 bits.
        (
             echo ; for 16-bit app support
            echo [386Enh]
            echo 32BitDiskAccess=on
            echo 32BitFileAccess=on
            echo DMABufferSize=64
            echo MinSPs=16
            echo PageBuffers=32
            echo ConservativeSwapfileUsage=1
            echo woafont=dosapp.fon
            echo EGA80WOA.FON=EGA80WOA.FON
            echo EGA40WOA.FON=EGA40WOA.FON
            echo CGA80WOA.FON=CGA80WOA.FON
            echo CGA40WOA.FON=CGA40WOA.FON
            echo.
            echo [drivers]
            echo wave=mmdrv.dll
            echo timer=timer.drv
            echo.
            echo [mci]
        ) > "%arquivo%.tmp"
        move /y "%arquivo%.tmp" "%arquivo%"
    ) else (
        echo O sistema e de 64 bits.
        (
            echo ; for 16-bit app support
            echo [386Enh]
            echo 64BitDiskAccess=on
            echo 64BitFileAccess=on
            echo DMABufferSize=128
            echo MinSPs=16
            echo PageBuffers=64
            echo ConservativeSwapFileUsage=1
            echo woafont=dosapp.fon
            echo EGA80WOA.FON=EGA80WOA.FON
            echo EGA40WOA.FON=EGA40WOA.FON
            echo CGA80WOA.FON=CGA80WOA.FON
            echo CGA40WOA.FON=CGA40WOA.FON
            echo.
            echo [drivers]
            echo wave=mmdrv.dll
            echo timer=timer.drv
            echo.
            echo [mci]
        ) > "%arquivo%.tmp"
        move /y "%arquivo%.tmp" "%arquivo%"
    )
)

net stop SysMain
sc config SysMain start=disabled >nul
echo ==============================================
echo * Otimizacao inicializacao realizada com sucesso *
echo ==============================================
pause
goto menu

:opcao2
cls
regedit /s "%GUIPPEPath%\REG_BOOSTER_Update.reg"
echo ==================================
echo *      SpeedBooster realizado com sucesso         *
echo ==================================
pause
goto menu

:opcao3
cls
@echo off

net stop Spooler
del C:\Windows\System32\spool\PRINTERS /s /q
net start Spooler

echo ==================================
echo *      Reiniciado Servico de Impressao           *
echo ==================================
pause
goto menu

:opcao4
cls
ipconfig /release
ipconfig /flushdns
ipconfig /renew
ipconfig /registerdns
echo ==================================
echo *      Renovado o IP da maquina        *
echo ==================================
pause
goto menu

:opcao5
cls
@Echo off
mode 70,5
net stop wuauserv >nul
sc config wuauserv start=disabled >nul
color 1E
chcp 1252 >nul

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
echo         Desinstalar atualizacoes do Windows by @DuanyDias
echo.
echo         ====================================================
echo.
echo         Escolha a atualizacao que deseja desinstalar. . .
echo.
for /l %%x in (1,1,!count!) do (
  echo             [%%x]  Update KB!up_kb[%%x]!
)
echo.
echo             [A]  Desinstalar todos os updates acima.
echo.
echo         ====================================================
echo.
set /p sel_kb=^>       Digite a opcao correspondente e pressione "enter": 
if not defined sel_kb cls&echo.&echo   Foi pressionado "enter" sem digitar uma opcao.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
set "SelErrorKB="&for /f "delims=0123456789Aa" %%i in ("%sel_kb%") do set SelErrorKB=%%i
if defined SelErrorKB cls&echo.&echo   Voce digitou "%sel_kb%". Esse caractere e invalido.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [0] cls&echo.&echo   Voce digitou "%sel_kb%". Olhe com mais atencao a lista de opcoes.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [Aa] cls&echo.&echo   Voce digitou "%sel_kb%". Olhe com mais atencao a lista de opcoes.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [aA] cls&echo.&echo   Voce digitou "%sel_kb%". Olhe com mais atencao a lista de opcoes.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [A] goto UninstAllKB
if [%sel_kb%] equ [a] goto UninstAllKB
if [%sel_kb%] Leq [!count!] set "UninstOneKB=!up_kb[%sel_kb%]!"&goto UninstOneKB
if not [%sel_kb%] Leq [!count!] cls&echo.&echo   Voce digitou "%sel_kb%". Olhe com mais atencao a lista de opcoes.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist

:UninstOneKB
cls
mode 70,5
echo.
echo.
echo    Desinstalando Update KB%UninstOneKB%. . .
start /w "" wusa  /uninstall /kb:%UninstOneKB% /norestart
timeout 3 >nul
cls
echo.
echo.
echo    A operacao foi concluida com exito.
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
  start /w "" wusa  /uninstall /kb:!up_kb[%%x]! /norestart
  timeout 3 >nul
)
cls
echo.
echo.
echo    As operacoes foram concluidas com exito.
del /Q /F "%temp%\kbuplist.txt" >nul 2>&1
timeout 3 >nul
goto menu

:opcao6
cls
net stop wuauserv >nul
sc config wuauserv start=disabled >nul
echo ==================================
echo *      Removido Atualizacao automatica do Windows Update        *
echo ==================================
pause
goto menu


:opcao7
cls
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\05DCA431" /v MaximumTransferLength /t REG_DWORD /d 2097120 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\054C00C1" /v MaximumTransferLength /t REG_DWORD /d 2097120 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\058F6362" /v MaximumTransferLength /t REG_DWORD /d 2097120 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\05AC12xx" /v MaximumTransferLength /t REG_DWORD /d 2097120 /f 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\05AC13xx" /v MaximumTransferLength /t REG_DWORD /d 2097120 /f 

echo ==================================
echo *     Otimizado W/R dos IOs        *
echo ==================================
pause
goto menu

:opcao8
cls
mode 90,6
for /f "tokens=1,2 delims=:()" %%i in ('powercfg -list ^| find "(Desempenho Máximo)"') do set GUIDPlan=%%j
if "%GUIDPlan%"=="" goto ImportUPEnergy
set GUIDPlan=%GUIDPlan: =%
powercfg -setactive %GUIDPlan%
goto SkipUPEnergy

:ImportUPEnergy
powercfg -import "%GUIPPEPath%\UltimatePerformance.pow"
timeout 2 >nul
for /f "tokens=1,2 delims=:()" %%i in ('powercfg -list ^| find "(Desempenho Máximo)"') do set NewGUIDPlan=%%j
set NewGUIDPlan=%NewGUIDPlan: =%
powercfg -setactive %NewGUIDPlan%

:SkipUPEnergy
echo ==================================
echo *     Ativado Modo Alto Desempenho Bateria        *
echo ==================================
pause
goto menu

:opcao9
cls
del  %temp%  /f /s /q 
echo ==================================
echo *     Removido Arquivos Temporarios        *
echo ==================================
pause
goto menu
