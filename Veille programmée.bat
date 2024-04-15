@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion
color 08

rem Définit la durée avant l'arrêt (en secondes)
set /p "shutdown_time=Entrez le délai avant l'arrêt (en minutes) : "
set /a "shutdown_seconds_initial=%shutdown_time% * 60"
set /a "shutdown_seconds=%shutdown_time% * 60"
set "progress_width=50"

rem Démarre une boucle pour afficher la progression
:progress_loop
cls
echo Progression :
rem Affiche la barre de progression
call :progress_bar !shutdown_seconds! !shutdown_seconds_initial!
echo.
rem Affiche le temps restant
set /a "minutes=!shutdown_seconds! / 60"
set /a "seconds=!shutdown_seconds! %% 60"
echo Temps restant : !minutes! minutes !seconds! secondes
rem Actualise le temps restant
set /a "shutdown_seconds-=1"
rem Vérifie si le temps restant est écoulé
if !shutdown_seconds! gtr 0 (
    rem Attend une seconde
    ping -n 2 127.0.0.1 > nul
    rem Redémarre la boucle
    goto :progress_loop
) else (
    rem Arrête l'ordinateur
    shutdown /s /f /t 1
)

exit /b

:progress_bar
setlocal
set /a "progress_width=(%1 * 100) / %2"
set "progress="
set /a "done_chars=(progress_width * 50) / 100"
set /a "remaining_chars=50 - done_chars"
set "done_bar="
set "remaining_bar="
for /L %%i in (1,1,!done_chars!) do set "done_bar=!done_bar!█"
for /L %%i in (1,1,!remaining_chars!) do set "remaining_bar=!remaining_bar! "
echo [!done_bar!!remaining_bar!]
exit /b
