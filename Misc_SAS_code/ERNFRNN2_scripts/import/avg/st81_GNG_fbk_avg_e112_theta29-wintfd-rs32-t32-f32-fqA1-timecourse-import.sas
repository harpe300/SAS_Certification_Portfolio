PROC IMPORT OUT= WORK.FNtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_fbk_avg_e112_theta29-wintfd-rs32-t32-f32-fqA1-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\avg';

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
proc transpose data = FNtheta61UV out = FNtheta61MVrawpre prefix = TavgFNprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawFN prefix = TavgFNFNm;
by subname subnum;
id elecname catcodes; 
var FNm;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawP3 prefix = TavgFNP3m;
by subname subnum;
id elecname catcodes; 
var P3m;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawpost prefix = TavgFNpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

data FNtheta61MVraw;
	merge FNtheta61MVrawpre FNtheta61MVrawFN FNtheta61MVrawP3 FNtheta61MVrawpost;
run;

data FNtheta61MV;
	set FNtheta61MVraw;
	TavgFNprem61NF = TavgFNprem611;
	TavgFNFNm61NF = TavgFNFNm611;
	TavgFNP3m61NF = TavgFNP3m611;
	TavgFNpostm61NF = TavgFNpostm611;
	TavgFNm61NFdiff = TavgFNFNm61NF - TavgFNpostm61NF;
	keep subname subnum TavgFNprem61NF TavgFNFNm61NF TavgFNP3m61NF TavgFNpostm61NF TavgFNm61NFdiff;
run;

data mylib.st81_GNG_the29_avg_FNROI_61_MV;
	set FNtheta61MV;
run;
