PROC IMPORT OUT= WORK.N2theta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\output_data\st81_GNG_ISFtrl2a_e9_thet29_web_CNNM_CSD_ICPS_X_61-wintfd-rs32-t32-f32-fqA0-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\ICPS';

data N2theta61UV;
set work.N2theta61;
keep subname subnum elecname catcodes prem N2m p3m postm postm;
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

data N2theta61MVraw;
	merge N2theta61MVrawpre N2theta61MVrawFN N2theta61MVrawP3 N2theta61MVrawpost;
	drop _name_;
run;

/* pool L+R LPF channels */

data N2theta61MV;
	set N2theta61MVraw;

	T61refN2prem28N = T61refN2prem281;
	T61refN2prem107N = T61refN2prem1071;
	T61refN2N2m28N = T61refN2N2m281;
	T61refN2N2m107N = T61refN2N2m1071;
	T61refN2P3m28N = T61refN2P3m281;
	T61refN2P3m107N = T61refN2P3m1071;
	T61refN2postm28N = T61refN2postm281;
	T61refN2postm107N = T61refN2postm1071;
	T61refN2prem28G = T61refN2prem282;
	T61refN2prem107G = T61refN2prem1072;
	T61refN2N2m28G = T61refN2N2m282;
	T61refN2N2m107G = T61refN2N2m1072;
	T61refN2P3m28G = T61refN2P3m282;
	T61refN2P3m107G = T61refN2P3m1072;
	T61refN2postm28G = T61refN2postm282;
	T61refN2postm107G = T61refN2postm1072;

	T61refN2prem25N = T61refN2prem251;
	T61refN2prem104N = T61refN2prem1041;
	T61refN2N2m25N = T61refN2N2m251;
	T61refN2N2m104N = T61refN2N2m1041;
	T61refN2P3m25N = T61refN2P3m251;
	T61refN2P3m104N = T61refN2P3m1041;
	T61refN2postm25N = T61refN2postm251;
	T61refN2postm104N = T61refN2postm1041;
	T61refN2prem25G = T61refN2prem252;
	T61refN2prem104G = T61refN2prem1042;
	T61refN2N2m25G = T61refN2N2m252;
	T61refN2N2m104G = T61refN2N2m1042;
	T61refN2P3m25G = T61refN2P3m252;
	T61refN2P3m104G = T61refN2P3m1042;
	T61refN2postm25G = T61refN2postm252;
	T61refN2postm104G = T61refN2postm1042;

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

	T61refN2premLPFN    = mean(T61refN2prem28N, T61refN2prem107N);
	T61refN2N2mLPFN     = mean(T61refN2N2m28N, T61refN2N2m107N);
	T61refN2postmLPFN   = mean(T61refN2postm28N, T61refN2postm107N);
	T61refN2premLPFG    = mean(T61refN2prem28G, T61refN2prem107G);
	T61refN2N2mLPFG     = mean(T61refN2N2m28G, T61refN2N2m107G);
	T61refN2postmLPFG   = mean(T61refN2postm28G, T61refN2postm107G);
	T61refN2mLPFNdiff = T61refN2N2mLPFN - T61refN2postmLPFN;

	T61refN2premLMN    = mean(T61refN2prem25N, T61refN2prem104N);
	T61refN2N2mLMN     = mean(T61refN2N2m25N, T61refN2N2m104N);
	T61refN2postmLMN   = mean(T61refN2postm25N, T61refN2postm104N);
	T61refN2premLMG    = mean(T61refN2prem25G, T61refN2prem104G);
	T61refN2N2mLMG     = mean(T61refN2N2m25G, T61refN2N2m104G);
	T61refN2postmLMG   = mean(T61refN2postm25G, T61refN2postm104G);
	T61refN2mLMNdiff = T61refN2N2mLMN - T61refN2postmLMN;

	
	T61refN2premLPN    = mean(T61refN2prem40N, T61refN2prem95N);
	T61refN2N2mLPN     = mean(T61refN2N2m40N, T61refN2N2m95N);
	T61refN2postmLPN   = mean(T61refN2postm40N, T61refN2postm95N);
	T61refN2premLPG    = mean(T61refN2prem40G, T61refN2prem95G);
	T61refN2N2mLPG     = mean(T61refN2N2m40G, T61refN2N2m95G);
	T61refN2postmLPG   = mean(T61refN2postm40G, T61refN2postm95G);
	T61refN2mLPNdiff = T61refN2N2mLPN - T61refN2postmLPN;

	keep subname subnum 
T61refN2prem28N T61refN2prem107N T61refN2N2m28N T61refN2N2m107N T61refN2P3m28N T61refN2P3m107N  T61refN2postm28N T61refN2postm107N T61refN2prem28G T61refN2prem107G T61refN2N2m28G T61refN2N2m107G T61refN2P3m28G T61refN2P3m107G T61refN2postm28G T61refN2postm107G
T61refN2prem25N T61refN2prem104N T61refN2N2m25N T61refN2N2m104N T61refN2P3m25N T61refN2P3m104N  T61refN2postm25N T61refN2postm104N T61refN2prem25G T61refN2prem104G T61refN2N2m25G T61refN2N2m104G T61refN2P3m25G T61refN2P3m104G T61refN2postm25G T61refN2postm104G
T61refN2prem40N T61refN2prem95N T61refN2N2m40N T61refN2N2m95N T61refN2P3m40N T61refN2P3m95N  T61refN2postm40N T61refN2postm95N T61refN2prem40G T61refN2prem95G T61refN2N2m40G T61refN2N2m95G T61refN2P3m40G T61refN2P3m95G T61refN2postm40G T61refN2postm95G
T61refN2premLPFN T61refN2N2mLPFN T61refN2postmLPFN T61refN2premLPFG T61refN2N2mLPFG T61refN2postmLPFG T61refN2mLPFNdiff
T61refN2premLMN T61refN2N2mLMN T61refN2postmLMN T61refN2premLMG T61refN2N2mLMG T61refN2postmLMG T61refN2mLMNdiff
T61refN2premLPN T61refN2N2mLPN T61refN2postmLPN T61refN2premLPG T61refN2N2mLPG T61refN2postmLPG T61refN2mLPNdiff
;
run;

data mylib.st81_GNG_the29_ICPS_N2ROI_61_MV;
	set N2theta61MV;
run;
