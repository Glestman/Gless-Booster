param([switch]$Elevated)

function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}



 Write-Host Ferramenta de Suporte do Windows by @Glestman
                   
 Write-Host           "MENU TAREFAS"
 Write-Host ==================================
 Write-Host * 1. Otimizacao do Sistema          
 Write-Host * 2. Encerramento mais rapido                                 
 Write-Host * 3. Reset Spool Impressora           
 Write-Host * 4. Renovar IP da m�quina           
 Write-Host * 5. Desinstalar atualiza��es do Windows Update           

 Write-Host  ==================================

$opcao = Read-Host "Escolha uma opcao:"


switch ($opcao) {
    

1{

	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 55 /f 
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 60 /f
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 2000 /f
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v ContigFileAllocSize /t REG_DWORD /d 200 /f
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d y /f
	Stop-Service -Force -Name "SysMain"; Set-Service -Name "SysMain" -StartupType Disabled

	Write-Output ==============================================
	Write-Output * Otimiza��o inicializacao realizada com sucesso *
	Write-Output ==============================================
	r
	
	}
2{
Clear-Host
Start-Process -filepath "C:\windows\regedit.exe" -argumentlist "/s D:\Scripts\REG_BOOSTER_Update.reg"

Write-Output ==================================
Write-Output *      SpeedBooster realizado com sucesso         *
Write-Output ==================================
return $opcao
}

3{
Clear-Host

net stop Spooler
Remove-Item �path C:\Windows\System32\spool\PRINTERS\ �recurse

net start Spooler

Write-Output ==================================
Write-Output *      Reiniciado Servi�o de Impress�o           *
Write-Output ==================================
pause
}

4{
Clear-Host
ipconfig /release
ipconfig /flushdns
ipconfig /renew
ipconfig /registerdns
Write-Output ==================================
Write-Output *      Renovado o IP da m�quina        *
Write-Output ==================================
pause
}

<#  5{
Clear-Host
mode 70,5
net stop wuauserv >nul
sc config wuauserv start=disabled >nul


setlocal enabledelayedexpansion

:startgenlist
Clear-Host
set "kpuplist="
set "count="
set "up_kb[!count!]="
set "sel_kb="
set "UninstOneKB="
Write-Output.
Write-Output.
Write-Output    Listando updates, aguarde. . .
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
Clear-Host
Write-Output         Desinstalar atualiza��es do Windows by @DuanyDias
Write-Output.
Write-Output         ====================================================
Write-Output.
Write-Output         Escolha a atualiza��o que deseja desinstalar. . .
Write-Output.
for /l %%x in (1,1,!count!) do (
  Write-Output             [%%x]  Update KB!up_kb[%%x]!
)
Write-Output.
Write-Output             [A]  Desinstalar todos os updates acima.
Write-Output.
Write-Output         ====================================================
Write-Output.
$sel_kb=^ = Read-Host "Digite a op��o correspondente e pressione "enter": "
if not defined sel_kb cls&echo.&echo   Foi pressionado "enter" sem digitar uma op��o.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
set "SelErrorKB="&for /f "delims=0123456789Aa" %%i in ("%sel_kb%") do set SelErrorKB=%%i
if defined SelErrorKB cls&echo.&echo   Voc� digitou "%sel_kb%". Esse caractere � inv�lido.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [0] cls&echo.&echo   Voc� digitou "%sel_kb%". Olhe com mais aten��o a lista de op��es.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [Aa] cls&echo.&echo   Voc� digitou "%sel_kb%". Olhe com mais aten��o a lista de op��es.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [aA] cls&echo.&echo   Voc� digitou "%sel_kb%". Olhe com mais aten��o a lista de op��es.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist
if [%sel_kb%] equ [A] goto UninstAllKB
if [%sel_kb%] equ [a] goto UninstAllKB
if [%sel_kb%] Leq [!count!] set "UninstOneKB=!up_kb[%sel_kb%]!"&goto UninstOneKB
if not [%sel_kb%] Leq [!count!] cls&echo.&echo   Voc� digitou "%sel_kb%". Olhe com mais aten��o a lista de op��es.&echo.&echo   Pressione qualquer tecla para tentar novamente. . .&pause >nul&goto startgenlist

:UninstOneKB
Clear-Host
mode 70,5
Write-Output.
Write-Output.
Write-Output    Desinstalando Update KB%UninstOneKB%. . .
start /w "" wusa  /uninstall /kb:%UninstOneKB% /norestart
timeout 3 >nul
Clear-Host
Write-Output.
Write-Output.
Write-Output    A opera��o foi conclu�da com �xito.
del /Q /F "%temp%\kbuplist.txt" >nul 2>&1
timeout 3 >nul


:UninstAllKB
Clear-Host
mode 70,5
for /l %%x in (1,1,!count!) do (
  Clear-Host
  Write-Output.
  Write-Output.
  Write-Output    Desinstalando Update KB!up_kb[%%x]!. . .
  start /w "" wusa  /uninstall /kb:!up_kb[%%x]! /norestart
  timeout 3 >nul
)
Clear-Host
Write-Output.
Write-Output.
Write-Output    As opera��es foram conclu�das com �xito.
del /Q /F "%temp%\kbuplist.txt" >nul 2>&1
timeout 3 >nul
		
}  #>
}
