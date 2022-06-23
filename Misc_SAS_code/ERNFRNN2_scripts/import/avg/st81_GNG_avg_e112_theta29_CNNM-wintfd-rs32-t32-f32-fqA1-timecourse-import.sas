PROC IMPORT OUT= WORK.N2theta61
	DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_avg_e112_theta29_CNNM-wintfd-rs32-t32-f32-fqA1-timecourse.dat"
		DBMS=TAB REPLACE;     
	GETNAMES=YES;
	DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\avg';

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

proc transpose data = N2theta61UV out = N2theta61MVrawpre prefix = TavgN2prem;
	by subname subnum;
	id elecname catcodes; 
	var prem;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawFN prefix = TavgN2N2m;
	by subname subnum;
	id elecname catcodes; 
	var N2m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawP3 prefix = TavgN2P3m;
	by subname subnum;
	id elecname catcodes; 
	var P3m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawpost prefix = TavgN2postm;
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
	TavgN2prem61N = TavgN2prem611;	
	TavgN2N2m61N = TavgN2N2m611;	
	TavgN2P3m61N = TavgN2P3m611;	
	TavgN2postm61N = TavgN2postm611;	
	TavgN2prem61G = TavgN2prem612;	
	TavgN2N2m61G = TavgN2N2m612;	
	TavgN2P3m61G = TavgN2P3m612;	
	TavgN2postm61G = TavgN2postm612;	
	TavgN2m61diff = TavgN2N2m61N - TavgN2postm61N;	
	keep subname subnum TavgN2prem61N TavgN2N2m61N TavgN2P3m61N TavgN2postm61N TavgN2prem61G TavgN2N2m61G TavgN2P3m61G TavgN2postm61G TavgN2m61diff;
run;

data mylib.st81_GNG_the29_avg_N2ROI_61_MV;	
	set N2theta61MV;
run;
