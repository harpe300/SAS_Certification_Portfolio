PROC IMPORT OUT= WORK.FNtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_fbk_ISFtrl2avg_e112_theta29-wintfd-rs32-t32-f32-fqA1-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\ISF';

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
proc transpose data = FNtheta61UV out = FNtheta61MVrawpre prefix = TTPFNprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawFN prefix = TTPFNFNm;
by subname subnum;
id elecname catcodes; 
var FNm;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawP3 prefix = TTPFNP3m;
by subname subnum;
id elecname catcodes; 
var P3m;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawpost prefix = TTPFNpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

data FNtheta61MVraw;
	merge FNtheta61MVrawpre FNtheta61MVrawFN FNtheta61MVrawP3 FNtheta61MVrawpost;
run;

data FNtheta61MV;
	set FNtheta61MVraw;
	TTPFNprem61NF = TTPFNprem611;
	TTPFNFNm61NF = TTPFNFNm611;
	TTPFNP3m61NF = TTPFNP3m611;
	TTPFNpostm61NF = TTPFNpostm611;
	TTPFNm61NFdiff = TTPFNFNm61NF - TTPFNpostm61NF;
	keep subname subnum TTPFNprem61NF TTPFNFNm61NF TTPFNP3m61NF TTPFNpostm61NF TTPFNm61NFdiff;
run;

data mylib.st81_GNG_the29_ISF_FNROI_61_MV;
	set FNtheta61MV;
run;
