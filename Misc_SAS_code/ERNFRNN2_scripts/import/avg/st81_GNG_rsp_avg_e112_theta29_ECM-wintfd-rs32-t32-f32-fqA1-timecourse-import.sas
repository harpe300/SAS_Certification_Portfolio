PROC IMPORT OUT= WORK.ENtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_rsp_avg_e112_theta29_ECM-wintfd-rs32-t32-f32-fqA1-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\avg';

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
proc transpose data = ENtheta61UV out = ENtheta61MVrawpre prefix = TavgENprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawFN prefix = TavgENERNm;
by subname subnum;
id elecname catcodes; 
var ERNm;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawP3 prefix = TavgENp3em;
by subname subnum;
id elecname catcodes; 
var p3em;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawpost prefix = TavgENpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

data ENtheta61MVraw;
	merge ENtheta61MVrawpre ENtheta61MVrawFN ENtheta61MVrawP3 ENtheta61MVrawpost;
	drop _name_;
run;

data ENtheta61MV;
	set ENtheta61MVraw;
	TavgENprem61C = TavgENprem611;
	TavgENERNm61C = TavgENERNm611;
	TavgENp3em61C = TavgENp3em611;
	TavgENpostm61C = TavgENpostm611;
	TavgENprem61E = TavgENprem612;
	TavgENERNm61E = TavgENERNm612;
	TavgENp3em61E = TavgENp3em612;
	TavgENpostm61E = TavgENpostm612;
	TavgENm61Ediff = TavgENERNm61E - TavgENpostm61E;
	keep subname subnum TavgENprem61C TavgENERNm61C TavgENp3em61C TavgENpostm61C TavgENprem61E TavgENERNm61E TavgENp3em61E TavgENpostm61E TavgENm61Ediff;
run;

data mylib.st81_GNG_the29_avg_ENROI_61_MV;
	set ENtheta61MV;
run;
