PROC IMPORT OUT= WORK.N2theta61
	DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\output_data\st81_GNG_ISFtrl2avg_e112_theta29_CNNM_RT-wintfd-rs32-t32-f32-fqA1-timecourse.dat"
		DBMS=TAB REPLACE;     
	GETNAMES=YES;
	DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data';

data N2theta61UV;
	set work.N2theta61;
	keep subname subnum elecname catcodes prem N2m p3m postm rt rt_plus_1 rt_minus_1;
	if elecname ne 61 then delete;
run;

proc contents data = N2theta61UV;
run;

proc sort data = N2theta61UV;
	by subname subnum elecname catcodes;
run;

/* create MV dataset */

proc transpose data = N2theta61UV out = N2theta61MVrawpre prefix = TTPN2prem;
	by subname subnum;
	id elecname catcodes; 
	var prem;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawFN prefix = TTPN2N2m;
	by subname subnum;
	id elecname catcodes; 
	var N2m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawP3 prefix = TTPN2P3m;
	by subname subnum;
	id elecname catcodes; 
	var P3m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawpost prefix = TTPN2postm;
	by subname subnum;
	id elecname catcodes; 
	var postm;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrt prefix = TTPN2rt;
	by subname subnum;
	id elecname catcodes; 
	var rt;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrtplus1 prefix = TTPN2rtplus1;
	by subname subnum;
	id elecname catcodes; 
	var rt_plus_1;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrtminus1 prefix = TTPN2rtminus1;
	by subname subnum;
	id elecname catcodes; 
	var rt_minus_1;
run;

data N2theta61MVraw;	
	merge N2theta61MVrawpre N2theta61MVrawFN N2theta61MVrawP3 N2theta61MVrawpost N2theta61MVrawrt N2theta61MVrawrtplus1 N2theta61MVrawrtminus1;	
	rename TTPN2rt611 = TTPN2rtN TTPN2rt612 = TTPN2rtG TTPN2rtplus1611 = TTPN2rtplus1N TTPN2rtplus1612 = TTPN2rtplus1G TTPN2rtminus1611 = TTPN2rtminus1N TTPN2rtminus1612 = TTPN2rtminus1G ;	
	drop _name_;
run;

data N2theta61MV;	
	set N2theta61MVraw;	
	TTPN2prem61N = TTPN2prem611;	
	TTPN2N2m61N = TTPN2N2m611;	
	TTPN2P3m61N = TTPN2P3m611;	
	TTPN2postm61N = TTPN2postm611;	
	TTPN2prem61G = TTPN2prem612;	
	TTPN2N2m61G = TTPN2N2m612;	
	TTPN2P3m61G = TTPN2P3m612;	
	TTPN2postm61G = TTPN2postm612;	
	TTPN2m61Ndiff = TTPN2N2m61N - TTPN2postm61N;	
	keep subname subnum TTPN2prem61N TTPN2N2m61N TTPN2P3m61N TTPN2postm61N TTPN2prem61G TTPN2N2m61G TTPN2P3m61G TTPN2postm61G TTPN2m61Ndiff 	
	TTPN2rtN TTPN2rtG TTPN2rtplus1N TTPN2rtplus1G TTPN2rtminus1N TTPN2rtminus1G;
run;

data mylib.st81_GNG_the29_ISF_N2ROI_61_MV;	
	set N2theta61MV;
run;
