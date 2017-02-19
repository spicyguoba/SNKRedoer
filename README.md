SNKRedoer
=========
Resigning all DLLs and EXEs without rebuilding projects


What does it do?
-----------------
I created this script to be used for re-signing existing Signature Key (SNK) with another SNK without rebuilding entire solution for all projects.
It uses disassembler (ildasm.exe) in Microsoft SDK, and assembler(ilasm.exe) in Framework to do the job. Make sure you have those, and modify the path in swapsnk.bat if there's a different version you wish to use.
ilasm.exe version is especially important. It's default to be using v2.0 for reassembling it to .NET 3.5 compatible DLLs or EXEs. If you wish to reassemble your DLLs to .NET 4.0 or above, make sure to change the path to use higher version ilasm.exe. It generally in (C:\Windows\Microsoft.NET\Framework\v4.0.30319\ilasm.exe)

How to Use?
-----------------
NOTE: DLLs and Exes in DLLs_input folder to be modified must signed by the same SNK.

1. Copy all DLLs and/or EXEs you wish to modified in DLLs_input folder
2. Modify the swapsnk.bat. Set the DLL name that contains the SNK you wish to replace, it will be read from DLLs_input folder.
3. Copy the SNK you wish to use for signing to top level directory.
4. Rename your SNK file to Key.snk


=========================
David Ferlemann 5.24.2014
=========================
