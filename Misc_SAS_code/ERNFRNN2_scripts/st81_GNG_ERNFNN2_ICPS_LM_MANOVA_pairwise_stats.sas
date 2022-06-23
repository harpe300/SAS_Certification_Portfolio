
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data ICPS;
	set mylib.s81_gng_t29_ICPS_ROI_ERNFNN2_mv;
run;

title ' test of LR difference';
proc ttest data = ICPS;
	paired T61refENERNm25E*T61refENERNm104E;
run;
proc ttest data = ICPS;
	paired T61refN2N2m25N*T61refN2N2m104N;
run;
proc ttest data = ICPS;
	paired T61refFNFNm25NF*T61refFNFNm104NF;
run;

title ' 3x3x2 MANOVA Component x Time x LR';
proc glm data = ICPS;
	model
    	T61refENprem25E T61refENprem104E T61refENERNm104E T61refENERNm25E T61refENpostm104E T61refENpostm104E
		T61refFNprem25NF T61refFNprem104NF T61refFNFNm104NF T61refFNFNm25NF T61refFNpostm104NF T61refFNpostm104NF
		T61refN2prem25N T61refN2prem104N T61refN2N2m104N T61refN2N2m25N T61refN2postm104N T61refN2postm104N = / nouni;
	repeated COMPONENT 3, TIME 3, LR 2 polynomial / summary;
run; quit;

title ' 2x3x2 GLM FN/N2 x Time x LR';
proc glm data = ICPS;
	model
		T61refFNprem25NF T61refFNprem104NF T61refFNFNm104NF T61refFNFNm25NF T61refFNpostm104NF T61refFNpostm104NF
		T61refN2prem25N T61refN2prem104N T61refN2N2m104N T61refN2N2m25N T61refN2postm104N T61refN2postm104N = / nouni;
	repeated COMPONENT 2, TIME 3, LR 2;
run; quit;

title ' 2x3x2 GLM ERN/FN x Time x LR';
proc glm data = ICPS;
	model
    	T61refENprem25E T61refENprem104E T61refENERNm104E T61refENERNm25E T61refENpostm104E T61refENpostm104E
		T61refFNprem25NF T61refFNprem104NF T61refFNFNm104NF T61refFNFNm25NF T61refFNpostm104NF T61refFNpostm104NF = / nouni;
	repeated COMPONENT 2, TIME 3, LR 2;
run; quit;

title ' 2x3x2 GLM ERN/N2 x Time x LR';
proc glm data = ICPS;
	model
    	T61refENprem25E T61refENprem104E T61refENERNm104E T61refENERNm25E T61refENpostm104E T61refENpostm104E
		T61refN2prem25N T61refN2prem104N T61refN2N2m104N T61refN2N2m25N T61refN2postm104N T61refN2postm104N = / nouni;
	repeated COMPONENT 2, TIME 3, LR 2;
run; quit;

title ' 3x2 GLM Time x LR ERN and pairwise';
proc glm data = ICPS;
	model
    	T61refENprem25E T61refENprem104E T61refENERNm104E T61refENERNm25E T61refENpostm104E T61refENpostm104E = / nouni;
	repeated TIME 3, LR 2;
run; quit;

proc ttest data = ICPS;
	paired T61refENprem25E*T61refENERNm25E;
run;
proc ttest data = ICPS;
	paired T61refENERNm25E*T61refENpostm25E;
run;
proc ttest data = ICPS;
	paired T61refENprem25E*T61refENpostmLME;
run;
proc ttest data = ICPS;
	paired T61refENprem104E*T61refENERNm104E;
run;
proc ttest data = ICPS;
	paired T61refENERNm104E*T61refENpostm104E;
run;
proc ttest data = ICPS;
	paired T61refENprem104E*T61refENpostm104E;
run;

title ' 3-way GLM Time FN and pairwise';
proc glm data = ICPS;
	model
		T61refFNprem25NF T61refFNprem104NF T61refFNFNm104NF T61refFNFNm25NF T61refFNpostm104NF T61refFNpostm104NF = / nouni;
	repeated TIME 3, LR 2;
run; quit;
proc ttest data = ICPS;
	paired T61refFNprem25NF*T61refFNFNm25NF;
run;
proc ttest data = ICPS;
	paired T61refFNFNm25NF*T61refFNpostm25NF;
run;
proc ttest data = ICPS;
	paired T61refFNprem25NF*T61refFNpostm25NF;
run;
proc ttest data = ICPS;
	paired T61refFNprem104NF*T61refFNFNm104NF;
run;
proc ttest data = ICPS;
	paired T61refFNFNm104NF*T61refFNpostm104NF;
run;
proc ttest data = ICPS;
	paired T61refFNprem104NF*T61refFNpostm104NF;
run;

title ' 3-way GLM Time N2 and pairwise';
proc glm data = ICPS;
	model
		T61refN2prem25N T61refN2prem104N T61refN2N2m104N T61refN2N2m25N T61refN2postm104N T61refN2postm104N = / nouni;
	repeated TIME 3, LR 2;
run; quit;
proc ttest data = ICPS;
	paired T61refN2prem25N*T61refN2N2m25N;
run;
proc ttest data = ICPS;
	paired T61refN2N2m25N*T61refN2postm25N;
run;
proc ttest data = ICPS;
	paired T61refN2prem25N*T61refN2postm25N;
run;
proc ttest data = ICPS;
	paired T61refN2prem104N*T61refN2N2m104N;
run;
proc ttest data = ICPS;
	paired T61refN2N2m104N*T61refN2postm104N;
run;
proc ttest data = ICPS;
	paired T61refN2prem104N*T61refN2postm104N;
run;

title ' 3x2 GLM ROI x LR and pairwise';
proc glm data = ICPS;
	model
		T61refN2N2m25N T61refN2N2m104N T61refFNFNm25NF T61refFNFNm104NF T61refENERNm25E T61refENERNm104E  = / nouni;
	repeated TIME 3;
run; quit;
proc ttest data = ICPS;
	paired T61refN2N2m25N*T61refFNFNm25NF;
run;
proc ttest data = ICPS;
	paired T61refFNFNm25NF*T61refENERNm25E;
run;
proc ttest data = ICPS;
	paired T61refN2N2m25N*T61refENERNm25E;
run;
proc ttest data = ICPS;
	paired T61refN2N2m104N*T61refFNFNm104NF;
run;
proc ttest data = ICPS;
	paired T61refFNFNm104NF*T61refENERNm104E;
run;
proc ttest data = ICPS;
	paired T61refN2N2m104N*T61refENERNm104E;
run;
title;

/* PROFILE PLOT */

data all;
	set icps;
	variable="T61refENprem25E";   PLV = T61refENprem25E;   ROI = 'ERN';  time = '1preL ';  output;
	variable="T61refENERNm25E";   PLV = T61refENERNm25E;   ROI = 'ERN';  time = '2ROIL ';  output;
  	variable="T61refENpostm25E";  PLV = T61refENpostm25E;  ROI = 'ERN';  time = '3postL'; output;
	variable="T61refFNprem25NF";  PLV = T61refFNprem25NF;  ROI = 'FRN';  time = '1preL ';  output;
	variable="T61refFNFNm25NF";   PLV = T61refFNFNm25NF;   ROI = 'FRN';  time = '2ROIL ';  output;
  	variable="T61refFNpostm25NF"; PLV = T61refFNpostm25NF; ROI = 'FRN';  time = '3postL';  output;
	variable="T61refN2prem25N";   PLV = T61refN2prem25N;   ROI = 'N2 ';  time = '1preL ';  output;
	variable="T61refN2N2m25N";    PLV = T61refN2N2m25N;    ROI = 'N2 ';  time = '2ROIL ';  output;
  	variable="T61refN2postm25N";  PLV = T61refN2postm25N;  ROI = 'N2 ';  time = '3postL';  output;
  	keep variable PLV ROI time;
run;

proc sort;
	by ROI time;
run;

proc means noprint;
  	by ROI time;
  	var PLV;
  	output out=a n=n mean=xbar var=s2;
run;

data b;
	set a;
	PLV = xbar;
run;

proc sort data = b;
	by time ROI;
run; 

proc sgplot data = b;
	series y = PLV x = time / group = ROI markers markerattrs=(symbol=circle) lineattrs=(pattern=solid);
run;

data all;
	set icps;
	variable="T61refENprem104E";   PLV = T61refENprem104E;   ROI = 'ERN';  time = '1preR ';  output;
	variable="T61refENERNm104E";   PLV = T61refENERNm104E;   ROI = 'ERN';  time = '2ROIR ';  output;
  	variable="T61refENpostm104E";  PLV = T61refENpostm104E;  ROI = 'ERN';  time = '3postR'; output;
	variable="T61refFNprem104NF";  PLV = T61refFNprem104NF;  ROI = 'FRN';  time = '1preR ';  output;
	variable="T61refFNFNm104NF";   PLV = T61refFNFNm104NF;   ROI = 'FRN';  time = '2ROIR ';  output;
  	variable="T61refFNpostm104NF"; PLV = T61refFNpostm104NF; ROI = 'FRN';  time = '3postR';  output;
	variable="T61refN2prem104N";   PLV = T61refN2prem104N;   ROI = 'N2 ';  time = '1preR ';  output;
	variable="T61refN2N2m104N";    PLV = T61refN2N2m104N;    ROI = 'N2 ';  time = '2ROIR ';  output;
  	variable="T61refN2postm104N";  PLV = T61refN2postm104N;  ROI = 'N2 ';  time = '3postR';  output;
  	keep variable PLV ROI time;
run;

proc sort;
	by ROI time;
run;

proc means noprint;
  	by ROI time;
  	var PLV;
  	output out=a n=n mean=xbar var=s2;
run;

data b;
	set a;
	PLV = xbar;
run;

proc sort data = b;
	by time ROI;
run; 

proc sgplot data = b;
	series y = PLV x = time / group = ROI markers markerattrs=(symbol=circle) lineattrs=(pattern=solid);
run;

title 'Go v. Nogo';
proc ttest data = icps;
	paired T61refN2N2m104N*T61refN2N2m104G;
run;
proc ttest data = icps;
	paired T61refN2N2m25N*T61refN2N2m25G;
run;
proc ttest data = icps;
	paired T61refN2N2mLPFN*T61refN2N2mLPFG;
run;

title 'Error v. Correct';
proc ttest data = icps;
	paired T61refENERNm104E*T61refENERNm104C;
run;
proc ttest data = icps;
	paired T61refENERNm25E*T61refENERNm25C;
run;
proc ttest data = icps;
	paired T61refENERNmLPFE*T61refENERNmLPFC;
run;
