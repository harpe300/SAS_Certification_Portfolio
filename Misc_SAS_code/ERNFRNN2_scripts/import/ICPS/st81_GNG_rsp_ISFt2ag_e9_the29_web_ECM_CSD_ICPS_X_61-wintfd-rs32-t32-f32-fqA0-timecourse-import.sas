PROC IMPORT OUT= WORK.ERNtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_rsp_ISFt2ag_e9_the29_web_ECM_CSD_ICPS_X_61-wintfd-rs32-t32-f32-fqA0-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data ERNtheta61UV;
set work.ERNtheta61;
keep subname subnum elecname catcodes prem ERNm P3em postm;
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

data ERNtheta61MVraw;
	merge ERNtheta61MVrawpre ERNtheta61MVrawFN ERNtheta61MVrawP3e ERNtheta61MVrawpost;
	drop _name_;
run;

/* pool L+R LPF channels */

data ERNtheta61MV;
	set ERNtheta61MVraw;
	T61refENprem28C =T61refENprem281;
	T61refENprem107C =T61refENprem1071;
	T61refENERNm28C =T61refENERNm281;
	T61refENERNm107C =T61refENERNm1071;
	T61refENP3em28C =T61refENP3em281;
	T61refENP3em107C =T61refENP3em1071;
	T61refENpostm28C =T61refENpostm281;
	T61refENpostm107C =T61refENpostm1071;
	T61refENprem28E = T61refENprem282;
	T61refENprem107E = T61refENprem1072;
	T61refENERNm28E = T61refENERNm282;
	T61refENERNm107E = T61refENERNm1072;
	T61refENP3em28E = T61refENP3em282;
	T61refENP3em107E = T61refENP3em1072;
	T61refENpostm28E = T61refENpostm282;
	T61refENpostm107E = T61refENpostm1072;

	T61refENprem25C =T61refENprem251;
	T61refENprem104C =T61refENprem1041;
	T61refENERNm25C =T61refENERNm251;
	T61refENERNm104C =T61refENERNm1041;
	T61refENP3em25C =T61refENP3em251;
	T61refENP3em104C =T61refENP3em1041;
	T61refENpostm25C =T61refENpostm251;
	T61refENpostm104C =T61refENpostm1041;
	T61refENprem25E = T61refENprem252;
	T61refENprem104E = T61refENprem1042;
	T61refENERNm25E = T61refENERNm252;
	T61refENERNm104E = T61refENERNm1042;
	T61refENP3em25E = T61refENP3em252;
	T61refENP3em104E = T61refENP3em1042;
	T61refENpostm25E = T61refENpostm252;
	T61refENpostm104E = T61refENpostm1042;

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

	T61refENpremLPFC    = mean(T61refENprem28C, T61refENprem107C);
	T61refENERNmLPFC     = mean(T61refENERNm28C, T61refENERNm107C);
	T61refENpostmLPFC   = mean(T61refENpostm28C, T61refENpostm107C);
	T61refENpremLPFE    = mean(T61refENprem28E, T61refENprem107E);
	T61refENERNmLPFE     = mean(T61refENERNm28E, T61refENERNm107E);
	T61refENpostmLPFE   = mean(T61refENpostm28E, T61refENpostm107E);
	T61refENmLPFEdiff = T61refENERNmLPFE - T61refENpostmLPFE;

	T61refENpremLMC    = mean(T61refENprem25C, T61refENprem104C);
	T61refENERNmLMC     = mean(T61refENERNm25C, T61refENERNm104C);
	T61refENpostmLMC   = mean(T61refENpostm25C, T61refENpostm104C);
	T61refENpremLME    = mean(T61refENprem25E, T61refENprem104E);
	T61refENERNmLME     = mean(T61refENERNm25E, T61refENERNm104E);
	T61refENpostmLME   = mean(T61refENpostm25E, T61refENpostm104E);
	T61refENmLMEdiff = T61refENERNmLME - T61refENpostmLME;

	T61refENpremLPC    = mean(T61refENprem40C, T61refENprem95C);
	T61refENERNmLPC     = mean(T61refENERNm40C, T61refENERNm95C);
	T61refENpostmLPC   = mean(T61refENpostm40C, T61refENpostm95C);
	T61refENpremLPE    = mean(T61refENprem40E, T61refENprem95E);
	T61refENERNmLPE     = mean(T61refENERNm40E, T61refENERNm95E);
	T61refENpostmLPE   = mean(T61refENpostm40E, T61refENpostm95E);
	T61refENmLPEdiff = T61refENERNmLPE - T61refENpostmLPE;

	keep subname subnum 
	T61refENprem28C T61refENprem107C T61refENERNm28C T61refENERNm107C T61refENP3em28C T61refENP3em107C  T61refENpostm28C T61refENpostm107C T61refENprem28E T61refENprem107E T61refENERNm28E T61refENERNm107E T61refENP3em28E T61refENP3em107E T61refENpostm28E T61refENpostm107E 
	T61refENprem25C T61refENprem104C T61refENERNm25C T61refENERNm104C T61refENP3em25C T61refENP3em104C  T61refENpostm25C T61refENpostm104C T61refENprem25E T61refENprem104E T61refENERNm25E T61refENERNm104E T61refENP3em25E T61refENP3em104E T61refENpostm25E T61refENpostm104E
	T61refENprem40C T61refENprem95C T61refENERNm40C T61refENERNm95C T61refENP3em40C T61refENP3em95C  T61refENpostm40C T61refENpostm95C T61refENprem40E T61refENprem95E T61refENERNm40E T61refENERNm95E T61refENP3em40E T61refENP3em95E T61refENpostm40E T61refENpostm95E
	T61refENpremLPFC T61refENERNmLPFC T61refENpostmLPFC T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE T61refENmLPFEdiff
	T61refENpremLMC T61refENERNmLMC T61refENpostmLMC T61refENpremLME T61refENERNmLME T61refENpostmLME T61refENmLMEdiff
	T61refENpremLPC T61refENERNmLPC T61refENpostmLPC T61refENpremLPE T61refENERNmLPE T61refENpostmLPE T61refENmLPEdiff;
run;

data mylib.st81_GNG_the29_ICPS_ENROI_61_MV;
	set ERNtheta61MV;
run;
