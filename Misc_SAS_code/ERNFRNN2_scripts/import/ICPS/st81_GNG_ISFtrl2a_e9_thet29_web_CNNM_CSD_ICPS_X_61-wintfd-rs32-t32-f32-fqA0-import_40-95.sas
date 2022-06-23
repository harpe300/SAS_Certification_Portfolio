PROC IMPORT OUT= WORK.N2theta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\output_data\st81_GNG_ISFtrl2a_e9_thet29_web_CNNM_RT_CSD_ICPS_X_61-wintfd-rs32-t32-f32-fqA0-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data\ICPS\channels_40_95';

data N2theta61UV;
set work.N2theta61;
keep subname subnum elecname catcodes prem N2m p3m postm postm rt rt_plus_1 rt_minus_1;
run;

proc contents data = N2theta61UV;
run;

proc sort data = N2theta61UV;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = N2theta61UV out = N2theta61MVrawpre prefix = T61refN2prem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawFN prefix = T61refN2N2m;
by subname subnum;
id elecname catcodes; 
var N2m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawP3 prefix = T61refN2P3m;
by subname subnum;
id elecname catcodes; 
var P3m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawpost prefix = T61refN2postm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrt prefix = T61refN2rt;
	by subname subnum;
	id elecname catcodes; 
	var rt;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrtplus1 prefix = T61refN2rtplus1;
	by subname subnum;
	id elecname catcodes; 
	var rt_plus_1;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrtminus1 prefix = T61refN2rtminus1;
	by subname subnum;
	id elecname catcodes; 
	var rt_minus_1;
run;

data N2theta61MVraw;
	merge N2theta61MVrawpre N2theta61MVrawFN N2theta61MVrawP3 N2theta61MVrawpost N2theta61MVrawrt N2theta61MVrawrtplus1 N2theta61MVrawrtminus1;
	rename T61refN2rt611 = T61refN2rtN T61refN2rt612 = T61refN2rtG T61refN2rtplus1611 = T61refN2rtplus1N T61refN2rtplus1612 = T61refN2rtplus1G T61refN2rtminus1611 = T61refN2rtminus1N T61refN2rtminus1612 = T61refN2rtminus1G ;	
	drop _name_;
run;

/* pool L+R LPF channels */

data N2theta61MV;
	set N2theta61MVraw;
	T61refN2prem40N = T61refN2prem401;
	T61refN2prem95N = T61refN2prem951;
	T61refN2N2m40N = T61refN2N2m401;
	T61refN2N2m95N = T61refN2N2m951;
	T61refN2P3m40N = T61refN2P3m401;
	T61refN2P3m95N = T61refN2P3m951;
	T61refN2postm40N = T61refN2postm401;
	T61refN2postm95N = T61refN2postm951;
	T61refN2prem40G = T61refN2prem402;
	T61refN2prem95G = T61refN2prem952;
	T61refN2N2m40G = T61refN2N2m402;
	T61refN2N2m95G = T61refN2N2m952;
	T61refN2P3m40G = T61refN2P3m402;
	T61refN2P3m95G = T61refN2P3m952;
	T61refN2postm40G = T61refN2postm402;
	T61refN2postm95G = T61refN2postm952;
	T61refN2premLPN    = mean(T61refN2prem40N, T61refN2prem95N);
	T61refN2N2mLPN     = mean(T61refN2N2m40N, T61refN2N2m95N);
	T61refN2postmLPN   = mean(T61refN2postm40N, T61refN2postm95N);
	T61refN2premLPG    = mean(T61refN2prem40G, T61refN2prem95G);
	T61refN2N2mLPG     = mean(T61refN2N2m40G, T61refN2N2m95G);
	T61refN2postmLPG   = mean(T61refN2postm40G, T61refN2postm95G);
	T61refN2mLPNdiff = T61refN2N2mLPN - T61refN2postmLPN;
	keep subname subnum T61refN2prem40N T61refN2prem95N T61refN2N2m40N T61refN2N2m95N T61refN2P3m40N T61refN2P3m95N  T61refN2postm40N T61refN2postm95N T61refN2prem40G T61refN2prem95G 
T61refN2N2m40G T61refN2N2m95G T61refN2P3m40G T61refN2P3m95G T61refN2postm40G T61refN2postm95G T61refN2premLPN T61refN2N2mLPN T61refN2postmLPN T61refN2premLPG T61refN2N2mLPG T61refN2postmLPG 
T61refN2mLPNdiff T61refN2rtN T61refN2rtG T61refN2rtplus1N T61refN2rtplus1G T61refN2rtminus1N T61refN2rtminus1G;
run;


data mylib.st81_GNG_t29_ICPS_N2ROI_61LP_MV;
	set N2theta61MV;
run;
