@ECHO OFF
REM https://steve-jansen.github.io/guides/windows-batch-scripting/part-2-variables.html
REM https://stackoverflow.com/questions/2541767/what-is-the-proper-way-to-test-if-a-parameter-is-empty-in-a-batch-file
REM The %1 variable is the first command-line argument passed to this script.
REM Valid values are dev, stage or prod.

ECHO %1
SET TARGET_FOLDER=C:\Users\bunny\OneDrive\OneDrive_AddOn\github\ce5-group5-capstone\pred-main\overlays\
cd %TARGET_FOLDER%\%1

PAUSE

REM GOTO:%~1 2>NUL
REM IF ERRORLEVEL 1 (
REM 	ECHO Invalid argument: %1
REM 	ECHO.
REM 	ECHO Usage:  %~n0  number
REM 	ECHO.
REM 	ECHO Where:  number may be 1, 2 or 3 only
REM 	GOTO:EOF
REM )

:dev
:stage
:prod

REM IF "%1"=="" GOTO BAD
REM IF "%~1"=="" GOTO BAD
REM IF [%1]==[] GOTO BAD
REM IF NOT DEFINED %1 GOTO BAD

:1
:GOOD

SET TARGET_FOLDER=C:\Users\bunny\OneDrive\OneDrive_AddOn\github\ce5-group5-capstone\pred-main\overlays\
cd %TARGET_FOLDER%\%1

REM PAUSE

TITLE "Creating resources in $1 environment..."

REM This command will generate the manifest files for the selected environment and create the
REM resources in the default Kubernetes cluster.
kustomize build . | kubectl apply -f -

GOTO EOF

:BAD
REM ECHO Valid values for the first argument is dev, stage or prod. For example: build dev

:EOF