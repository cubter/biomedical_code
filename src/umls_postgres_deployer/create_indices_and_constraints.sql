-- UMLS indices. 

CREATE INDEX X_MRCONSO_CUI ON umls.MRCONSO(CUI);

ALTER TABLE umls.MRCONSO ADD CONSTRAINT X_MRCONSO_PK PRIMARY KEY (AUI);

CREATE INDEX X_MRCONSO_SUI ON umls.MRCONSO(SUI);

CREATE INDEX X_MRCONSO_LUI ON umls.MRCONSO(LUI);

CREATE INDEX X_MRCONSO_CODE ON umls.MRCONSO(CODE);

CREATE INDEX X_MRCONSO_SAB_TTY ON umls.MRCONSO(SAB,TTY);

CREATE INDEX X_MRCONSO_SCUI ON umls.MRCONSO(SCUI);

CREATE INDEX X_MRCONSO_SDUI ON umls.MRCONSO(SDUI);

CREATE INDEX X_MRCONSO_STR ON umls.MRCONSO(STR);

CREATE INDEX X_MRCXT_CUI ON umls.MRCXT(CUI);

CREATE INDEX X_MRCXT_AUI ON umls.MRCXT(AUI);

CREATE INDEX X_MRCXT_SAB ON umls.MRCXT(SAB);

CREATE INDEX X_MRDEF_CUI ON umls.MRDEF(CUI);

CREATE INDEX X_MRDEF_AUI ON umls.MRDEF(AUI);

ALTER TABLE umls.MRDEF ADD CONSTRAINT X_MRDEF_PK PRIMARY KEY (ATUI);

CREATE INDEX X_MRDEF_SAB ON umls.MRDEF(SAB);

CREATE INDEX X_MRHIER_CUI ON umls.MRHIER(CUI);

CREATE INDEX X_MRHIER_AUI ON umls.MRHIER(AUI);

CREATE INDEX X_MRHIER_SAB ON umls.MRHIER(SAB);

CREATE INDEX X_MRHIER_PTR ON umls.MRHIER(PTR);

CREATE INDEX X_MRHIER_PAUI ON umls.MRHIER(PAUI);

CREATE INDEX X_MRHIST_CUI ON umls.MRHIST(CUI);

CREATE INDEX X_MRHIST_SOURCEUI ON umls.MRHIST(SOURCEUI);

CREATE INDEX X_MRHIST_SAB ON umls.MRHIST(SAB);

ALTER TABLE umls.MRRANK ADD CONSTRAINT X_MRRANK_PK PRIMARY KEY (SAB,TTY);

CREATE INDEX X_MRREL_CUI1 ON umls.MRREL(CUI1);

CREATE INDEX X_MRREL_AUI1 ON umls.MRREL(AUI1);

CREATE INDEX X_MRREL_CUI2 ON umls.MRREL(CUI2);

CREATE INDEX X_MRREL_AUI2 ON umls.MRREL(AUI2);

ALTER TABLE umls.MRREL ADD CONSTRAINT X_MRREL_PK PRIMARY KEY (RUI);

CREATE INDEX X_MRREL_SAB ON umls.MRREL(SAB);

ALTER TABLE umls.MRSAB ADD CONSTRAINT X_MRSAB_PK PRIMARY KEY (VSAB);
CREATE INDEX X_MRSAB_RSAB ON umls.MRSAB(RSAB);

CREATE INDEX X_MRSAT_CUI ON umls.MRSAT(CUI);

CREATE INDEX X_MRSAT_METAUI ON umls.MRSAT(METAUI);

ALTER TABLE umls.MRSAT ADD CONSTRAINT X_MRSAT_PK PRIMARY KEY (ATUI);

CREATE INDEX X_MRSAT_SAB ON umls.MRSAT(SAB);

CREATE INDEX X_MRSAT_ATN ON umls.MRSAT(ATN);

CREATE INDEX X_MRSTY_CUI ON umls.MRSTY(CUI);

ALTER TABLE umls.MRSTY ADD CONSTRAINT X_MRSTY_PK PRIMARY KEY (ATUI);

CREATE INDEX X_MRSTY_STY ON umls.MRSTY(STY);

CREATE INDEX X_MRXNS_ENG_NSTR ON umls.MRXNS_ENG(NSTR);

CREATE INDEX X_MRXNW_ENG_NWD ON umls.MRXNW_ENG(NWD);

CREATE INDEX X_MRXW_BAQ_WD ON umls.MRXW_BAQ(WD);

CREATE INDEX X_MRXW_CHI_WD ON umls.MRXW_CHI(WD);

CREATE INDEX X_MRXW_CZE_WD ON umls.MRXW_CZE(WD);

CREATE INDEX X_MRXW_DAN_WD ON umls.MRXW_DAN(WD);

CREATE INDEX X_MRXW_DUT_WD ON umls.MRXW_DUT(WD);

CREATE INDEX X_MRXW_ENG_WD ON umls.MRXW_ENG(WD);
CREATE INDEX X_MRXW_ENG_CUI ON umls.mrxw_eng(CUI);

CREATE INDEX X_MRXW_EST_WD ON umls.MRXW_EST(WD);

CREATE INDEX X_MRXW_FIN_WD ON umls.MRXW_FIN(WD);

CREATE INDEX X_MRXW_FRE_WD ON umls.MRXW_FRE(WD);

CREATE INDEX X_MRXW_GER_WD ON umls.MRXW_GER(WD);

CREATE INDEX X_MRXW_GRE_WD ON umls.MRXW_GRE(WD);

CREATE INDEX X_MRXW_HEB_WD ON umls.MRXW_HEB(WD);

CREATE INDEX X_MRXW_HUN_WD ON umls.MRXW_HUN(WD);

CREATE INDEX X_MRXW_ITA_WD ON umls.MRXW_ITA(WD);

CREATE INDEX X_MRXW_JPN_WD ON umls.MRXW_JPN(WD);

CREATE INDEX X_MRXW_KOR_WD ON umls.MRXW_KOR(WD);

CREATE INDEX X_MRXW_LAV_WD ON umls.MRXW_LAV(WD);

CREATE INDEX X_MRXW_NOR_WD ON umls.MRXW_NOR(WD);

CREATE INDEX X_MRXW_POL_WD ON umls.MRXW_POL(WD);

CREATE INDEX X_MRXW_POR_WD ON umls.MRXW_POR(WD);

CREATE INDEX X_MRXW_RUS_WD ON umls.MRXW_RUS(WD);

CREATE INDEX X_MRXW_SCR_WD ON umls.MRXW_SCR(WD);

CREATE INDEX X_MRXW_SPA_WD ON umls.MRXW_SPA(WD);

CREATE INDEX X_MRXW_SWE_WD ON umls.MRXW_SWE(WD);

CREATE INDEX X_MRXW_TUR_WD ON umls.MRXW_TUR(WD);

CREATE INDEX X_AMBIGSUI_SUI ON umls.AMBIGSUI(SUI);

CREATE INDEX X_AMBIGLUI_LUI ON umls.AMBIGLUI(LUI);

CREATE INDEX X_MRAUI_CUI2 ON umls.MRAUI(CUI2);

CREATE INDEX X_MRCUI_CUI2 ON umls.MRCUI(CUI2);

CREATE INDEX X_MRMAP_MAPSETCUI ON umls.MRMAP(MAPSETCUI);