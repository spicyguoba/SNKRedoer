@echo off

cd DLLs_input
FOR %%a IN (*) DO del %%a

cd ../DLLs_output
FOR %%a IN (*) DO del %%a

cd ../temp
FOR %%a IN (*) DO del %%a


cd ..
del log.txt
echo SNK Swapper Log File >log.txt