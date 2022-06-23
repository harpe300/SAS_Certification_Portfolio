PROC IMPORT OUT= WORK.FNtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_fbk_ISFtrl2avg_e112_theta29_web_ITPS-wintfd-rs32-t32-f32-fqA0-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\ITPS';

data FNtheta61UV;
  set work.FNtheta61;
  keep subname subnum elecname catcodes prem FNm p3m postm;
  if elecname ne 61 then delete;
run;

proc contents data = FNtheta61UV;
run;

proc sort data = FNtheta61UV;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = FNtheta61UV out = FNtheta61MVrawpre prefix = TITFNprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawFN prefix = TITFNFNm;
by subname subnum;
id elecname catcodes; 
var FNm;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawP3 prefix = TITFNP3m;
by subname subnum;
id elecname catcodes; 
var P3m;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawpost prefix = TITFNpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

data FNtheta61MVraw;
	merge FNtheta61MVrawpre FNtheta61MVrawFN FNtheta61MVrawP3 FNtheta61MVrawpost;
	drop _name_;
run;

data FNtheta61MV;
	set FNtheta61MVraw;
	TITFNprem61NF = TITFNprem611;
	TITFNFNm61NF = TITFNFNm611;
	TITFNP3m61NF = TITFNP3m611;
	TITFNpostm61NF = TITFNpostm611;
	TITFNm61NFdiff = TITFNFNm61NF - TITFNpostm61NF; 
	keep subname subnum TITFNprem61NF TITFNFNm61NF TITFNP3m61NF TITFNpostm61NF TITFNm61NFdiff;
run;

data mylib.st81_GNG_the29_itps_FNROI_61_MV;
	set FNtheta61MV;
run;
