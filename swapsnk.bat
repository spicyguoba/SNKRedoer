@echo off
REM == NOTE : Rename your SNK file to "Key.snk" for the script to work
REM == NOTE : Set the DLL that contains the SNK you wish to replace, it will be read from DLLs_input folder
			:: DLLs and Exes in DLLs_input folder to be modified must signed by the same SNK.
set RefDLL=Example.dll

REM == Add date to log file
set _logfile=log.txt
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/ " %%a in ('time /t') do (set mytime=%%a%%b)
set _datetime=%mydate% %mytime%
echo ====================================================================== >>%_logfile%
echo %_datetime% >>%_logfile%
echo ====================================================================== >>%_logfile%

REM == Get public key token from SNK file
call "C:\Program Files\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86
echo "STEP 1 ------ Extracting public key token from SNK... " >> %_logfile%
sn -p Key.snk PublicKey.snk
for /f "tokens=5" %%a in ('sn -t PublicKey.snk') do set publickeystring=%%a
call :UpCase publickeystring
call :AddTokenSpaces
set newpublickey=%publickeystring%
echo "Public Key to be applied is %newpublickey%" >> %_logfile%

REM == Get public key token from input DLLs
echo "STEP 2 ------ Extracting public key token from DLLs... " >> %_logfile%
for /f "delims=" %%a in ('sn -T ./DLLs_input/%RefDLL%') do set publickeystring=%%a
set publickeystring=%publickeystring:~-16%
call :UpCase publickeystring
call :AddTokenSpaces
set oldpublickey=%publickeystring%
echo "Public Key to be replaced is %oldpublickey%" >> %_logfile%

REM == For every DLL or EXE, replace all old public key tokens with new ones
echo "STEP 3 ------ Disassemble, and replace all old public key tokens with new ones... " >> %_logfile%

cd DLLs_input
for %%i in (*.dll) do ("C:\Program Files\Microsoft SDKs\Windows\v7.0A\bin\NETFX 4.0 Tools\ildasm.exe" /out:..\temp\%%~ni.il %%i)
cd ..

cd temp
for %%i in (*.il) do ("../repl.exe" "%oldpublickey%" "%newpublickey%" %%i)
cd ..

REM == Reassemble all DLLs with the new key
echo "STEP 4 ------ Reassemble all DLLs with the new key... " >> %_logfile%

cd temp
for %%i in (*.il) do ("C:\Windows\Microsoft.NET\Framework\v2.0.50727\ilasm.exe" %%i /dll /key=..\Key.snk /output=..\DLLs_output\%%~ni.dll)
REM for %%i in (*) do (del %%i)
cd ..

REM == Do the same for EXE files
echo "STEP 6 ------ DO the same for the exe files... " >> %_logfile%
cd DLLs_input
for %%i in (*.exe) do ("C:\Program Files\Microsoft SDKs\Windows\v7.0A\bin\NETFX 4.0 Tools\ildasm.exe" /out:..\temp\%%~ni.ie %%i)
cd ../temp
for %%i in (*.ie) do ("../repl.exe" "%oldpublickey%" "%newpublickey%" %%i)
for %%i in (*.ie) do ("C:\Windows\Microsoft.NET\Framework\v2.0.50727\ilasm.exe" %%i /exe /key=..\Key.snk /output=..\DLLs_output\%%~ni.exe)
REM for %%i in (*) do (del %%i)
cd ..

:: FINISHED
GOTO:EOF

REM ===================== Utility Functions
:UpCase
:: Subroutine to convert a variable VALUE to all UPPER CASE.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF

:AddTokenSpaces
:: Subroutine to add spaces for token
:: 16 chars 0011223344556677 will be converted to 00 11 22 33 44 55 66 77
set tok77=%publickeystring:~-2%
set tok66=%publickeystring:~12,-2%
set tok55=%publickeystring:~10,-4%
set tok44=%publickeystring:~8,-6%
set tok33=%publickeystring:~6,-8%
set tok22=%publickeystring:~4,-10%
set tok11=%publickeystring:~2,-12%
set tok00=%publickeystring:~0,2%
set publickeystring=%tok00% %tok11% %tok22% %tok33% %tok44% %tok55% %tok66% %tok77%
GOTO:EOF