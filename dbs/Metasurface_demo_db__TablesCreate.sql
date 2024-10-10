-- -----------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------
-- START OF CREATIVE


-- -----------------------------------------------------------------------------------------------------
-- 数据库建立和调用
-- CREATE DATABASE Metasurface_demo_db;
-- USE Metasurface_demo_db;


-- -----------------------------------------------------------------------------------------------------
-- 材料定义表建表初始化

CREATE TABLE MaterialDef (
    ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    `name` VARCHAR(20) NOT NULL COMMENT '材料名称',
    `comment` VARCHAR(100) NULL COMMENT '材料描述'
) COMMENT '材料定义表';

INSERT INTO MaterialDef (`name`, `comment`) VALUES
    ('Silicon', 'Si 硅'),
    ('Germanium', 'Ge 锗'),
    ('Titanium dioxide', 'TiO2 二氧化钛'),
    ('Silicon dioxide', 'SiO2');


-- -----------------------------------------------------------------------------------------------------
-- 定义形状信息


-- -----------------------------------------------------------------------------------------------------
-- S-parameter表建表初始化

CREATE TABLE SParameter (
    ID SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    `S_Param` VARCHAR(20) NOT NULL UNIQUE COMMENT 'S参数',
    `comment` VARCHAR(100) NULL COMMENT 'S参数描述'
) COMMENT 'S参数表';

INSERT INTO SParameter (`S_Param`, `comment`) VALUES
    ('Zmin(2),Zmax(2)', 'cmt'),
    ('Zmax(1),Zmin(1)', 'cmt'),
    ('Zmin(1),Zmax(2)', 'cmt'),
    ('Zmax(2),Zmax(2)', 'cmt'),
    ('Zmax(1),Zmax(2)', 'cmt'),
    ('Zmin(2),Zmax(1)', 'cmt'),
    ('Zmin(1),Zmax(1)', 'cmt'),
    ('Zmax(2),Zmax(1)', 'cmt'),
    ('Zmax(1),Zmin(2)', 'cmt'),
    ('Zmax(2),Zmin(1)', 'cmt'),
    ('Zmax(2),Zmin(2)', 'cmt'),
    ('Zmax(1),Zmax(1)', 'cmt'),
    ('Zmin(1),Zmin(1)', 'cmt'),
    ('Zmin(1),Zmin(2)', 'cmt'),
    ('Zmin(2),Zmin(1)', 'cmt'),
    ('Zmin(2),Zmin(2)', 'cmt');


-- -----------------------------------------------------------------------------------------------------
-- 所有形状单元结构基本参数（一级）表建表

CREATE TABLE GenericUnitsPrmt (
    ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    `baseMaterial_id` INT UNSIGNED NOT NULL COMMENT '基底材料ID',
    `cellMaterial_id` INT UNSIGNED NOT NULL COMMENT '单元材料ID',
    `S_Param_id` SMALLINT UNSIGNED NOT NULL COMMENT 'S参数ID',
    `height` INT UNSIGNED NOT NULL COMMENT '单元结构高度',
    `period` INT UNSIGNED NOT NULL COMMENT '单元结构排布周期',
    `thickness` INT UNSIGNED NOT NULL COMMENT '单元结构基底厚度',
    `E_theta` DOUBLE NOT NULL COMMENT '入射角',
    `hash` CHAR(32) NULL COMMENT '基本参数哈希值',
    FOREIGN KEY (`baseMaterial_id`) REFERENCES MaterialDef(ID),
    FOREIGN KEY (`cellMaterial_id`) REFERENCES MaterialDef(ID),
    FOREIGN KEY (`S_Param_id`) REFERENCES SParameter(ID)
) COMMENT '单元结构基本参数表';


-- -----------------------------------------------------------------------------------------------------
-- 各形状特殊（二级）单元结构参数表建表

CREATE TABLE CuboidUnitsPrmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    `length` INT UNSIGNED NOT NULL COMMENT '长',
    width INT UNSIGNED NOT NULL COMMENT '宽',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '矩形截面方体单元结构特征参数表';

CREATE TABLE SquareCuboidUnitsPrmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    side_length INT UNSIGNED NOT NULL COMMENT '边长',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '正方形截面方体单元结构特征参数表';

CREATE TABLE CylinderUnitsPrmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    radius INT UNSIGNED NOT NULL COMMENT '半径',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '圆柱体单元结构特征参数表';

CREATE TABLE CrossUnitsPrmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    long_length INT UNSIGNED NOT NULL COMMENT '长边，长',
    long_width INT UNSIGNED NOT NULL COMMENT '长边，短',
    short_length INT UNSIGNED NOT NULL COMMENT '宽边，长',
    short_width INT UNSIGNED NOT NULL COMMENT '宽边，短',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '十字形单元结构特征参数表';

CREATE TABLE squareholeunitsprmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    side_length INT UNSIGNED NOT NULL COMMENT '边长',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '方形孔洞单元结构特征参数表';

CREATE TABLE symmetriccrossunitsprmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    `width` INT UNSIGNED NOT NULL COMMENT '宽度',
    `length` INT UNSIGNED NOT NULL COMMENT '长度',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '对称十字形单元结构特征参数表';

CREATE TABLE squareringunitsprmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    inner_length INT UNSIGNED NOT NULL COMMENT '内径边长',
    outer_length INT UNSIGNED NOT NULL COMMENT '外径边长',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '方形环单元结构特征参数表';


-- -----------------------------------------------------------------------------------------------------
-- 各具体形状单元结构频率响应参数表建表（近红外（高频）：1000 ~ 2500nm）

CREATE TABLE CuboidUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CuboidUnitsPrmt(ID)
) COMMENT '矩形截面方体单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';

CREATE TABLE SquareCuboidUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE UNSIGNED COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES SquareCuboidUnitsPrmt(ID)
) COMMENT '正方形截面方体单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';

CREATE TABLE CylinderUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE UNSIGNED COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CylinderUnitsPrmt(ID)
) COMMENT '圆柱体单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';

CREATE TABLE CrossUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CrossUnitsPrmt(ID)
) COMMENT '十字形单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';

CREATE TABLE squareholeUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareholeunitsprmt(ID)
) COMMENT '方形孔洞单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';

CREATE TABLE symmetriccrossUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES symmetriccrossunitsprmt(ID)
) COMMENT '对称十字形单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';

CREATE TABLE squareringUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareringunitsprmt(ID)
) COMMENT '方形环单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';


-- -----------------------------------------------------------------------------------------------------
-- 各具体形状单元结构频率响应参数表建表（中红外（中频）：2500 ~ 5000nm）

CREATE TABLE CuboidUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CuboidUnitsPrmt(ID)
) COMMENT '矩形截面方体单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';

CREATE TABLE SquareCuboidUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES SquareCuboidUnitsPrmt(ID)
) COMMENT '正方形截面方体单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';

CREATE TABLE CylinderUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CylinderUnitsPrmt(ID)
) COMMENT '圆柱体单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';

CREATE TABLE CrossUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CrossUnitsPrmt(ID)
) COMMENT '十字形单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';

CREATE TABLE squareholeUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareholeunitsprmt(ID)
) COMMENT '方形孔洞单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';

CREATE TABLE symmetriccrossUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES symmetriccrossunitsprmt(ID)
) COMMENT '对称十字形单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';

CREATE TABLE squareringUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareringunitsprmt(ID)
) COMMENT '方形环单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';


-- -----------------------------------------------------------------------------------------------------
-- 各具体形状单元结构频率响应参数表建表（远红外（低频）：5000 ~ 14000nm）

CREATE TABLE CuboidUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CuboidUnitsPrmt(ID)
) COMMENT '矩形截面方体单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';

CREATE TABLE SquareCuboidUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES SquareCuboidUnitsPrmt(ID)
) COMMENT '正方形截面方体单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';

CREATE TABLE CylinderUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CylinderUnitsPrmt(ID)
) COMMENT '圆柱体单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';

CREATE TABLE CrossUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES CrossUnitsPrmt(ID)
) COMMENT '十字形单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';

CREATE TABLE squareholeUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareholeunitsprmt(ID)
) COMMENT '方形孔洞单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';

CREATE TABLE symmetriccrossUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES symmetriccrossunitsprmt(ID)
) COMMENT '对称十字形单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';

CREATE TABLE squareringUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareringunitsprmt(ID)
) COMMENT '方形环单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';


-- -----------------------------------------------------------------------------------------------------
-- 操作定义表建表

CREATE TABLE OptionDef (
    ID SMALLINT UNSIGNED AUTO_INCREMENT COMMENT '主键',
    `name` VARCHAR(20) NOT NULL COMMENT '操作名称',
    PRIMARY KEY (ID)
) COMMENT '操作定义表';

INSERT INTO OptionDef (`name`) VALUES
 ('INS'), ('IMP'), ('DEL'), ('FAIL'), ('BACKUP'), ('UPD');



-- -----------------------------------------------------------------------------------------------------
-- 用户表建表

CREATE TABLE users (
    ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    `name` VARCHAR(20) NOT NULL COMMENT '用户名',
    first_join TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '首次加入时间',
    last_login TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后登录时间'
) COMMENT '用户表';



-- -----------------------------------------------------------------------------------------------------
-- 日志表建表

CREATE TABLE `log` (
    ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
    `user_id` INT UNSIGNED NOT NULL COMMENT '用户ID',
    option_id SMALLINT UNSIGNED NOT NULL COMMENT '操作ID',
    target_table VARCHAR(50) NOT NULL COMMENT '操作表',
    start_id INT UNSIGNED NOT NULL COMMENT '操作起始ID',
    `length` INT UNSIGNED NOT NULL COMMENT '操作长度',
    detail VARCHAR(80) NULL COMMENT '操作细节',
    FOREIGN KEY (option_id) REFERENCES OptionDef(ID),
    FOREIGN KEY (`user_id`) REFERENCES users(ID)
) COMMENT '日志表';



-- END OF CREATIVE
-- -----------------------------------------------------------------------------------------------------