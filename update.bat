@echo off
chcp 65001 
cd .\update\

REM 搜索最新的update文件夹
for /f "delims=" %%i in ('dir /b /ad /o-d') do set latest=%%i & goto :next
:next

REM 确认是否更新
echo 请确认是否更新程序, 更新版本为 %latest%? 是否继续？(Y/N)
set /p confirm=
if /i "%confirm%" neq "Y" goto end

REM 执行update文件夹下的exec.bat
cd %latest%
call exec.bat

REM 修改根目录文件夹名为cst2mysql_%latest%
cd ..\..\
del exec.bat
del *.sql
cd ..
ren .\cst2mysql_* cst2mysql_%latest%

:end
echo Done!
pause