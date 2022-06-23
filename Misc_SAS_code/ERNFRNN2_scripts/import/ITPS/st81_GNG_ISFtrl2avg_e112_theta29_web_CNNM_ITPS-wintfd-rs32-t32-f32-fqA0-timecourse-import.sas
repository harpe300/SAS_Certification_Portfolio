PROC IMPORT OUT= WORK.N2theta61
	DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_ISFtrl2avg_e112_theta29_web_CNNM_ITPS-wintfd-rs32-t32-f32-fqA0-timecourse.dat"
		DBMS=TAB REPLACE;     
	GETNAMES=YES;
	DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data N2theta61UV;
	set work.N2theta61;
	keep subname subnum elecname catcodes prem N2m p3m postm;
	if elecname ne 61 then delete;
run;

proc contents data = N2theta61UV;
run;

proc sort data = N2theta61UV;
	by subname subnum elecname catcodes;
run;

/* create MV dataset */

proc transpose data = N2theta61UV out = N2theta61MVrawpre prefix = TITN2prem;
	by subname subnum;
	id elecname catcodes; 
	var prem;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawFN prefix = TITN2N2m;
	by subname subnum;
	id elecname catcodes; 
	var N2m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawP3 prefix = TITN2P3m;
	by subname subnum;
	id elecname catcodes; 
	var P3m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawpost prefix = TITN2postm;
	by subname subnum;
	id elecname catcodes; 
	var postm;
run;

data N2theta61MVraw;	
	merge N2theta61MVrawpre N2theta61MVrawFN N2theta61MVrawP3 N2theta61MVrawpost;	
	drop _name_;
run;

data N2theta61MV;	
	set N2theta61MVraw;	
	TITN2prem61N = TITN2prem611;	
	TITN2N2m61N = TITN2N2m611;	
	TITN2P3m61N = TITN2P3m611;	
	TITN2postm61N = TITN2postm611;	
	TITN2prem61G = TITN2prem612;	
	TITN2N2m61G = TITN2N2m612;	
	TITN2P3m61G = TITN2P3m612;	
	TITN2postm61G = TITN2postm612;	
	TITN2m61diff = TITN2N2m61N - TITN2postm61N;	
	keep subname subnum TITN2prem61N TITN2N2m61N TITN2P3m61N TITN2postm61N TITN2prem61G TITN2N2m61G TITN2P3m61G TITN2postm61G TITN2m61diff;
run;

data mylib.st81_GNG_the29_itps_N2ROI_61_MV;	
	set N2theta61MV;
run;
