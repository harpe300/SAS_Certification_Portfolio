PROC IMPORT OUT= WORK.ERNtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\output_data\st81_GNG_rsp_ISFt2ag_e9_the29_web_ECM_RT_CSD_ICPS_X_61-wintfd-rs32-t32-f32-fqA0-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data\ICPS\channels_40_95';

data ERNtheta61UV;
set work.ERNtheta61;
keep subname subnum elecname catcodes prem ERNm P3em postm rt rt_plus_1 rt_minus_1;
run;

proc contents data = ERNtheta61UV;
run;

proc sort data = ERNtheta61UV;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = ERNtheta61UV out = ERNtheta61MVrawpre prefix = T61refENprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = ERNtheta61UV out = ERNtheta61MVrawFN prefix = T61refENERNm;
by subname subnum;
id elecname catcodes; 
var ERNm;
run;

proc transpose data = ERNtheta61UV out = ERNtheta61MVrawP3e prefix = T61refENP3em;
by subname subnum;
id elecname catcodes; 
var P3em;
run;

proc transpose data = ERNtheta61UV out = ERNtheta61MVrawpost prefix = T61refENpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

proc transpose data = ERNtheta61UV out = ERNtheta61MVrawrt prefix = T61refENrt;
	by subname subnum;
	id elecname catcodes; 
	var rt;
run;

proc transpose data = ERNtheta61UV out = ERNtheta61MVrawrtplus1 prefix = T61refENrtplus1;
	by subname subnum;
	id elecname catcodes; 
	var rt_plus_1;
run;

proc transpose data = ERNtheta61UV out = ERNtheta61MVrawrtminus1 prefix = T61refENrtminus1;
	by subname subnum;
	id elecname catcodes; 
	var rt_minus_1;
run;

data ERNtheta61MVraw;
	merge ERNtheta61MVrawpre ERNtheta61MVrawFN ERNtheta61MVrawP3e ERNtheta61MVrawpost ERNtheta61MVrawrt ERNtheta61MVrawrtplus1 ERNtheta61MVrawrtminus1;
	rename T61refENrt611 = T61refENrtC T61refENrt612 = T61refENrtE T61refENrtplus1611 = T61refENrtplus1C T61refENrtplus1612 = T61refENrtplus1E T61refENrtminus1611 = T61refENrtminus1C T61refENrtminus1612 = T61refENrtminus1E;	
	drop _name_;
run;

/* pool L+R LPF channels */

data ERNtheta61MV;
	set ERNtheta61MVraw;
	T61refENprem40C =T61refENprem401;
	T61refENprem95C =T61refENprem951;
	T61refENERNm40C =T61refENERNm401;
	T61refENERNm95C =T61refENERNm951;
	T61refENP3em40C =T61refENP3em401;
	T61refENP3em95C =T61refENP3em951;
	T61refENpostm40C =T61refENpostm401;
	T61refENpostm95C =T61refENpostm951;
	T61refENprem40E = T61refENprem402;
	T61refENprem95E = T61refENprem952;
	T61refENERNm40E = T61refENERNm402;
	T61refENERNm95E = T61refENERNm952;
	T61refENP3em40E = T61refENP3em402;
	T61refENP3em95E = T61refENP3em952;
	T61refENpostm40E = T61refENpostm402;
	T61refENpostm95E = T61refENpostm952;
	T61refENpremLPC    = mean(T61refENprem40C, T61refENprem95C);
	T61refENERNmLPC     = mean(T61refENERNm40C, T61refENERNm95C);
	T61refENpostmLPC   = mean(T61refENpostm40C, T61refENpostm95C);
	T61refENpremLPE    = mean(T61refENprem40E, T61refENprem95E);
	T61refENERNmLPE     = mean(T61refENERNm40E, T61refENERNm95E);
	T61refENpostmLPE   = mean(T61refENpostm40E, T61refENpostm95E);
	T61refENmLPEdiff = T61refENERNmLPE - T61refENpostmLPE;
	keep subname subnum T61refENprem40C T61refENprem95C T61refENERNm40C T61refENERNm95C T61refENP3em40C T61refENP3em95C  T61refENpostm40C T61refENpostm95C T61refENprem40E T61refENprem95E 
T61refENERNm40E T61refENERNm95E T61refENP3em40E T61refENP3em95E T61refENpostm40E T61refENpostm95E T61refENpremLPC T61refENERNmLPC T61refENpostmLPC T61refENpremLPE T61refENERNmLPE T61refENpostmLPE 
T61refENmLPEdiff T61refENrtC T61refENrtE T61refENrtplus1C T61refENrtplus1E T61refENrtminus1C T61refENrtminus1E;
run;

data mylib.st81_GNG_t29_ICPS_ENROI_61LP_MV;
	set ERNtheta61MV;
run;
