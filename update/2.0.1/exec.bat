@echo off
chcp 65001 
REM 修改路径为当前脚本所在路径
cd %~dp0Y

REM 预设数据库登录信息
SET MYSQL_USER=root
SET MYSQL_PASS=123456
SET DATABASE_NAME=Metasurface_demo_db

REM 将目录下所有文件夹覆盖复制到根目录
xcopy /s /y /e /q .\* ..\..\

REM 执行当前目录下的*.sql文件
for %%i in (*.sql) do (
    mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DATABASE_NAME% < %%i
)
pause 