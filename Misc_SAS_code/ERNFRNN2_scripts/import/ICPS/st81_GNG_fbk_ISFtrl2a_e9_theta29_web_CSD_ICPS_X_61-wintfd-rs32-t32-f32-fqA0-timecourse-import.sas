PROC IMPORT OUT= WORK.FNtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_fbk_ISFtrl2a_e9_theta29_web_CSD_ICPS_X_61-wintfd-rs32-t32-f32-fqA0-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\ICPS';

data FNtheta61UV;
set work.FNtheta61;
keep subname subnum elecname catcodes prem FNm p3m postm;
run;

proc contents data = FNtheta61UV;
run;

proc sort data = FNtheta61UV;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = FNtheta61UV out = FNtheta61MVrawpre prefix = T61refFNprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawFN prefix = T61refFNFNm;
by subname subnum;
id elecname catcodes; 
var FNm;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawP3 prefix = T61refFNP3m;
by subname subnum;
id elecname catcodes; 
var P3m;
run;

proc transpose data = FNtheta61UV out = FNtheta61MVrawpost prefix = T61refFNpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

data FNtheta61MVraw;
	merge FNtheta61MVrawpre FNtheta61MVrawFN FNtheta61MVrawP3 FNtheta61MVrawpost;
run;

data FNtheta61MV;
	set FNtheta61MVraw;

	T61refFNprem28NF = T61refFNprem281;
	T61refFNprem107NF = T61refFNprem1071;
	T61refFNprem25NF = T61refFNprem251;
	T61refFNprem104NF = T61refFNprem1041;
	T61refFNprem40NF = T61refFNprem401;
	T61refFNprem95NF = T61refFNprem951;

	T61refFNFNm28NF = T61refFNFNm281;
	T61refFNFNm107NF = T61refFNFNm1071;
	T61refFNFNm25NF = T61refFNFNm251;
	T61refFNFNm104NF = T61refFNFNm1041;
	T61refFNFNm40NF = T61refFNFNm401;
	T61refFNFNm95NF = T61refFNFNm951;

	T61refFNP3m28NF = T61refFNP3m281;
	T61refFNP3m107NF = T61refFNP3m1071;
	T61refFNP3m25NF = T61refFNP3m251;
	T61refFNP3m104NF = T61refFNP3m1041;
	T61refFNP3m40NF = T61refFNP3m401;
	T61refFNP3m95NF = T61refFNP3m951;

	T61refFNpostm28NF = T61refFNpostm281;
	T61refFNpostm107NF = T61refFNpostm1071;
	T61refFNpostm25NF = T61refFNpostm251;
	T61refFNpostm104NF = T61refFNpostm1041;
	T61refFNpostm40NF = T61refFNpostm401;
	T61refFNpostm95NF = T61refFNpostm951;

	T61refFNpremLPFNF = mean(T61refFNprem28NF, T61refFNprem107NF);
	T61refFNFNmLPFNF = mean(T61refFNFNm28NF, T61refFNFNm107NF);
	T61refFNP3mLPFNF = mean(T61refFNP3m28NF, T61refFNP3m107NF);
	T61refFNpostmLPFNF = mean(T61refFNpostm28NF, T61refFNpostm107NF);
	T61refFNmLPFNFdiff = T61refFNFNmLPFNF - T61refFNpostmLPFNF;

	T61refFNpremLMNF = mean(T61refFNprem25NF, T61refFNprem104NF);
	T61refFNFNmLMNF = mean(T61refFNFNm25NF, T61refFNFNm104NF);
	T61refFNP3mLMNF = mean(T61refFNP3m25NF, T61refFNP3m104NF);
	T61refFNpostmLMNF = mean(T61refFNpostm25NF, T61refFNpostm104NF);
	T61refFNmLMNFdiff = T61refFNFNmLMNF - T61refFNpostmLMNF;

	T61refFNpremLPNF = mean(T61refFNprem40NF, T61refFNprem95NF);
	T61refFNFNmLPNF = mean(T61refFNFNm40NF, T61refFNFNm95NF);
	T61refFNP3mLPNF = mean(T61refFNP3m40NF, T61refFNP3m95NF);
	T61refFNpostmLPNF = mean(T61refFNpostm40NF, T61refFNpostm95NF);
	T61refFNmLPNFdiff = T61refFNFNmLPNF - T61refFNpostmLPNF;

	keep subname subnum 
    T61refFNprem28NF T61refFNprem107NF T61refFNprem25NF T61refFNprem104NF T61refFNprem40NF T61refFNprem95NF
	T61refFNFNm28NF T61refFNFNm107NF T61refFNFNm25NF T61refFNFNm104NF T61refFNFNm40NF T61refFNFNm95NF
	T61refFNP3m28NF T61refFNP3m107NF T61refFNP3m25NF T61refFNP3m104NF T61refFNP3m40NF T61refFNP3m95NF
	T61refFNpostm28NF T61refFNpostm107NF T61refFNpostm25NF T61refFNpostm104NF T61refFNpostm40NF T61refFNpostm95NF
	T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNP3mLPFNF T61refFNpostmLPFNF T61refFNmLPFNFdiff
	T61refFNpremLMNF T61refFNFNmLMNF T61refFNP3mLMNF T61refFNpostmLMNF T61refFNmLMNFdiff
	T61refFNpremLPNF T61refFNFNmLPNF T61refFNP3mLPNF T61refFNpostmLPNF T61refFNmLPNFdiff; 
run;

data mylib.st81_GNG_the29_ICPS_FNROI_61_MV;
	set FNtheta61MV;
run;
