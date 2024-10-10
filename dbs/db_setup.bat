@echo off
chcp 65001 
REM 修改路径为当前脚本所在路径
cd %~dp0Y

REM 用户确认初始化 
echo 请确认是否初始化数据库，初始化将删除原有数据库并创建新的数据库!
echo 如果数据库“Metasurface_demo_db”中有重要数据应当在此之前备份! 是否继续？(Y/N)
set /p confirm=
if /i "%confirm%" neq "Y" goto end

REM 用户输入数据库登录信息 
SET /P MYSQL_USER=请输入数据库用户名: 
SET /P MYSQL_PASS=请输入数据库密码: 

REM 设置要创建的数据库名称 
SET DATABASE_NAME=Metasurface_demo_db

REM 删除原有数据库 
mysqladmin -u%MYSQL_USER% -p%MYSQL_PASS% DROP %DATABASE_NAME%

REM 创建数据库 
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -e "CREATE DATABASE IF NOT EXISTS %DATABASE_NAME%;"

REM 执行数据库初始化SQL脚本文件 
mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DATABASE_NAME% < Metasurface_demo_db__TablesCreate.sql

REM 执行索引create脚本文件
mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DATABASE_NAME% < idxs.sql

REM 执行存储过程SQL脚本文件
mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DATABASE_NAME% < storedProcedure_hash.sql

echo finished!

:end

pause
