
CREATE TABLE symmetriccrossunitsprmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    `width` INT UNSIGNED NOT NULL COMMENT '宽度',
    `length` INT UNSIGNED NOT NULL COMMENT '长度',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '对称十字形单元结构特征参数表';


CREATE TABLE symmetriccrossUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES symmetriccrossUnitsPrmt(ID)
) COMMENT '对称十字形单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';


CREATE TABLE symmetriccrossUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES symmetriccrossUnitsPrmt(ID)
) COMMENT '对称十字形单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';


CREATE TABLE symmetriccrossUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES symmetriccrossUnitsPrmt(ID)
) COMMENT '对称十字形单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';


CREATE INDEX idx_symmetriccrossunitsprmt_gup_id ON symmetriccrossunitsprmt(GUP_ID);

CREATE INDEX idx_symmetriccrossunitsfreqresp_nir_up_id ON symmetriccrossunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_symmetriccrossunitsfreqresp_mir_up_id ON symmetriccrossunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_symmetriccrossunitsfreqresp_fir_up_id ON symmetriccrossunitsfreqresp_fir(UP_ID);




CREATE TABLE squareringunitsprmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    inner_length INT UNSIGNED NOT NULL COMMENT '内径边长',
    outer_length INT UNSIGNED NOT NULL COMMENT '外径边长',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '方形环单元结构特征参数表';


CREATE TABLE squareringUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareringUnitsPrmt(ID)
) COMMENT '方形环单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';


CREATE TABLE squareringUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareringUnitsPrmt(ID)
) COMMENT '方形环单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';


CREATE TABLE squareringUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareringUnitsPrmt(ID)
) COMMENT '方形环单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';


CREATE INDEX idx_squareringunitsprmt_gup_id ON squareringunitsprmt(GUP_ID);

CREATE INDEX idx_squareringunitsfreqresp_nir_up_id ON squareringunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_squareringunitsfreqresp_mir_up_id ON squareringunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_squareringunitsfreqresp_fir_up_id ON squareringunitsfreqresp_fir(UP_ID);