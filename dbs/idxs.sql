CREATE INDEX idx_height_period ON GenericUnitsPrmt(height, `period`);
CREATE INDEX idx_hash ON GenericUnitsPrmt(hash);



CREATE INDEX idx_crossunitsprmt_gup_id ON crossunitsprmt(GUP_ID);
CREATE INDEX idx_squarecuboidunitsprmt_gup_id ON squarecuboidunitsprmt(GUP_ID);
CREATE INDEX idx_cuboidunitsprmt_gup_id ON cuboidunitsprmt(GUP_ID);
CREATE INDEX idx_cylinderunitsprmt_gup_id ON cylinderunitsprmt(GUP_ID);
CREATE INDEX idx_squareholeunitsprmt_gup_id ON squareholeunitsprmt(GUP_ID);
CREATE INDEX idx_symmetriccrossunitsprmt_gup_id ON symmetriccrossunitsprmt(GUP_ID);
CREATE INDEX idx_squareringunitsprmt_gup_id ON squareringunitsprmt(GUP_ID);



CREATE INDEX idx_crossunitsfreqresp_nir_up_id ON crossunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_crossunitsfreqresp_mir_up_id ON crossunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_crossunitsfreqresp_fir_up_id ON crossunitsfreqresp_fir(UP_ID);

CREATE INDEX idx_squarecuboid_nir_up_id ON squarecuboidunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_squarecuboid_mir_up_id ON squarecuboidunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_squarecuboid_fir_up_id ON squarecuboidunitsfreqresp_fir(UP_ID);

CREATE INDEX idx_cuboidunitsfreqresp_nir_up_id ON cuboidunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_cuboidunitsfreqresp_mir_up_id ON cuboidunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_cuboidunitsfreqresp_fir_up_id ON cuboidunitsfreqresp_fir(UP_ID);

CREATE INDEX idx_cylinderunitsfreqresp_nir_up_id ON cylinderunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_cylinderunitsfreqresp_mir_up_id ON cylinderunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_cylinderunitsfreqresp_fir_up_id ON cylinderunitsfreqresp_fir(UP_ID);

CREATE INDEX idx_squareholeunitsfreqresp_nir_up_id ON squareholeunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_squareholeunitsfreqresp_mir_up_id ON squareholeunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_squareholeunitsfreqresp_fir_up_id ON squareholeunitsfreqresp_fir(UP_ID);

CREATE INDEX idx_symmetriccrossunitsfreqresp_nir_up_id ON symmetriccrossunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_symmetriccrossunitsfreqresp_mir_up_id ON symmetriccrossunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_symmetriccrossunitsfreqresp_fir_up_id ON symmetriccrossunitsfreqresp_fir(UP_ID);

CREATE INDEX idx_squareringunitsfreqresp_nir_up_id ON squareringunitsfreqresp_nir(UP_ID);
CREATE INDEX idx_squareringunitsfreqresp_mir_up_id ON squareringunitsfreqresp_mir(UP_ID);
CREATE INDEX idx_squareringunitsfreqresp_fir_up_id ON squareringunitsfreqresp_fir(UP_ID);