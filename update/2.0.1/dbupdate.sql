
CREATE TABLE squareholeunitsprmt (
    ID INT UNSIGNED AUTO_INCREMENT,
    side_length INT UNSIGNED NOT NULL COMMENT '边长',
    GUP_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (GUP_ID) REFERENCES GenericUnitsPrmt(ID)
) COMMENT '方形孔洞单元结构特征参数表';


CREATE TABLE squareholeUnitsFreqResp_NIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareholeUnitsPrmt(ID)
) COMMENT '方形孔洞单元结构频率响应参数表(近红外: 1000 ~ 2500nm)';


CREATE TABLE squareholeUnitsFreqResp_MIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareholeUnitsPrmt(ID)
) COMMENT '方形孔洞单元结构频率响应参数表(中红外: 2500 ~ 5000nm)';


CREATE TABLE squareholeUnitsFreqResp_FIR (
    ID BIGINT UNSIGNED AUTO_INCREMENT,
    Frequency DOUBLE UNSIGNED NOT NULL COMMENT '频率',
    Magnitude DOUBLE NULL COMMENT '幅值',
    Phase_in_degree DOUBLE NULL COMMENT '相位',
    Dispersion DOUBLE COMMENT '色散',
    UP_ID INT UNSIGNED NOT NULL COMMENT '单元结构参数表外键',
    PRIMARY KEY (ID),
    FOREIGN KEY (UP_ID) REFERENCES squareholeUnitsPrmt(ID)
) COMMENT '方形孔洞单元结构频率响应参数表(远红外: 5000 ~ 14000nm)';


CREATE INDEX idx_squareholeunitsprmt_gup_id ON squareholeunitsprmt(GUP_ID);

CREATE INDEX idx_squareholeunitsfreqresp_nir_up_id ON squareholeunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_squareholeunitsfreqresp_mir_up_id ON squareholeunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_squareholeunitsfreqresp_fir_up_id ON squareholeunitsfreqresp_fir(UP_ID);
