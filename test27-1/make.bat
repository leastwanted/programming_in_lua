@echo off

set GENERATOR=Visual Studio 12

if not defined platform set platform=x64
if "%platform%" EQU "x64" (set GENERATOR=%GENERATOR% Win64)

IF NOT "x%1" == "x" GOTO :%1

GOTO :build

:build
cmake -H. -Bbuild -G"%GENERATOR%"
cmake --build build --config Release
COPY build\Release\lua.exe .
GOTO :end

:clean
IF EXIST build RMDIR /S /Q build
IF EXIST lua.exe DEL /F /Q lua.exe
GOTO :end

:end