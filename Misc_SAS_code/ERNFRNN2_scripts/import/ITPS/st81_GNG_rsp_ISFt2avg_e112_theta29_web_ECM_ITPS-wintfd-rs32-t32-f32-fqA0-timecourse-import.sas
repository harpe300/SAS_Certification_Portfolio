PROC IMPORT OUT= WORK.ENtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_rsp_ISFt2avg_e112_theta29_web_ECM_ITPS-wintfd-rs32-t32-f32-fqA0-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data ENtheta61UV;
set work.ENtheta61;
keep subname subnum elecname catcodes prem ERNm p3em postm;
if elecname ne 61 then delete;
run;

proc contents data = ENtheta61UV;
run;

proc sort data = ENtheta61UV;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = ENtheta61UV out = ENtheta61MVrawpre prefix = TITENprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawFN prefix = TITENERNm;
by subname subnum;
id elecname catcodes; 
var ERNm;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawP3 prefix = TITENp3em;
by subname subnum;
id elecname catcodes; 
var p3em;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawpost prefix = TITENpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;


data ENtheta61MVraw;
	merge ENtheta61MVrawpre ENtheta61MVrawFN ENtheta61MVrawP3 ENtheta61MVrawpost ;
	drop _name_;
run;

data ENtheta61MV;
	set ENtheta61MVraw;
	TITENprem61C = TITENprem611;
	TITENERNm61C = TITENERNm611;
	TITENp3em61C = TITENp3em611;
	TITENpostm61C = TITENpostm611;
	TITENprem61E = TITENprem612;
	TITENERNm61E = TITENERNm612;
	TITENp3em61E = TITENp3em612;
	TITENpostm61E = TITENpostm612;
	TITENm61Ediff = TITENERNm61E - TITENpostm61E;
	keep subname subnum TITENprem61C TITENERNm61C TITENp3em61C TITENpostm61C TITENprem61E TITENERNm61E TITENp3em61E TITENpostm61E TITENm61Ediff;
run;

data mylib.st81_GNG_the29_itps_ENROI_61_MV;
	set ENtheta61MV;
run;
