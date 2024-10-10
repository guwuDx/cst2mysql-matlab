@echo off
set SCRIPT_PATH=".\dev\cst2mysql_v2.m"

matlab -r "run('%SCRIPT_PATH%');"

rem 或者使用 -r 参数并指定脚本名称（不需要 .m 扩展名）
rem %MATLAB_PATH%\matlab.exe -r "run('%SCRIPT_PATH%');exit;"
