PROC IMPORT OUT= WORK.ENtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\output_data\st81_GNG_rsp_ISFtrl2avg_e112_theta29_ECM_RT-wintfd-rs32-t32-f32-fqA1-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data';

data ENtheta61UV;
set work.ENtheta61;
keep subname subnum elecname catcodes prem ERNm p3em postm rt rt_plus_1 rt_minus_1;
if elecname ne 61 then delete;
run;

proc contents data = ENtheta61UV;
run;

proc sort data = ENtheta61UV;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = ENtheta61UV out = ENtheta61MVrawpre prefix = TTPENprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawFN prefix = TTPENERNm;
by subname subnum;
id elecname catcodes; 
var ERNm;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawP3 prefix = TTPENp3em;
by subname subnum;
id elecname catcodes; 
var p3em;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawpost prefix = TTPENpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawrt prefix = TTPENrt;
by subname subnum;
id elecname catcodes; 
var rt;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawrtplus1 prefix = TTPENrtplus1;
by subname subnum;
id elecname catcodes; 
var rt_plus_1;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawrtminus1 prefix = TTPENrtminus1;
by subname subnum;
id elecname catcodes; 
var rt_minus_1;
run;

data ENtheta61MVraw;
	merge ENtheta61MVrawpre ENtheta61MVrawFN ENtheta61MVrawP3 ENtheta61MVrawpost ENtheta61MVrawrt ENtheta61MVrawrtplus1 ENtheta61MVrawrtminus1;
	rename TTPENrt611 = TTPENrtC TTPENrt612 = TTPENrtE TTPENrtplus1611 = TTPENrtplus1C TTPENrtplus1612 = TTPENrtplus1E TTPENrtminus1611 = TTPENrtminus1C TTPENrtminus1612 = TTPENrtminus1E;	
	drop _name_;
run;

data ENtheta61MV;
	set ENtheta61MVraw;
	TTPENprem61C = TTPENprem611;
	TTPENERNm61C = TTPENERNm611;
	TTPENp3em61C = TTPENp3em611;
	TTPENpostm61C = TTPENpostm611;
	TTPENprem61E = TTPENprem612;
	TTPENERNm61E = TTPENERNm612;
	TTPENp3em61E = TTPENp3em612;
	TTPENpostm61E = TTPENpostm612;
	TTPENm61Ediff = TTPENERNm61E - TTPENpostm61E;
	keep subname subnum TTPENprem61C TTPENERNm61C TTPENp3em61C TTPENpostm61C TTPENprem61E TTPENERNm61E TTPENp3em61E TTPENpostm61E TTPENm61Ediff
	TTPENrtC TTPENrtE TTPENrtplus1C TTPENrtplus1E TTPENrtminus1C TTPENrtminus1E;
run;

data mylib.st81_GNG_the29_isf_ENROI_61_MV;
	set ENtheta61MV;
run;
