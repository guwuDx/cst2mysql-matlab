@echo off 
chcp 65001 
REM 修改路径为当前脚本所在路径
cd %~dp0Y 

REM 用户输入数据库登录信息 
SET MYSQL_USER=root
SET MYSQL_PASS=Metasurface331.
SET HOST=frp-hen.top
SET PORT=24176

REM 设置要创建的数据库名称 
SET DATABASE_NAME=mcb_test

REM 删除原有数据库 
mysqladmin -u%MYSQL_USER% -p%MYSQL_PASS% -h %HOST% -P %PORT% DROP %DATABASE_NAME%

REM 创建数据库 
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h %HOST% -P %PORT% -e "CREATE DATABASE IF NOT EXISTS %DATABASE_NAME%;"

REM 执行数据库初始化SQL脚本文件 
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h %HOST% -P %PORT% %DATABASE_NAME% < Metasurface_demo_db__TablesCreate.sql

REM 执行索引create脚本文件
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h %HOST% -P %PORT% %DATABASE_NAME% < idxs.sql

REM 执行存储过程SQL脚本文件
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h %HOST% -P %PORT% %DATABASE_NAME% < storedProcedure_hash.sql

echo finished!

:end

pause
