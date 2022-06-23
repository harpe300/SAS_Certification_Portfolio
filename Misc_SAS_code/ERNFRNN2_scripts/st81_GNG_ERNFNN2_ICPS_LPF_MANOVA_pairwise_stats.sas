
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data ICPS;
	set mylib.s81_gng_t29_ICPS_ROI_ERNFNN2_mv;
run;

title ' test of LR difference';
proc ttest data = ICPS;
	paired T61refENERNm28E*T61refENERNm107E;
run;
proc ttest data = ICPS;
	paired T61refN2N2m28N*T61refN2N2m107N;
run;
proc ttest data = ICPS;
	paired T61refFNFNm28NF*T61refFNFNm107NF;
run;

title ' 3x3 MANOVA Component x Time';
proc glm data = ICPS;
	model
    	T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE
		T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNpostmLPFNF
		T61refN2premLPFN  T61refN2N2mLPFN  T61refN2postmLPFN = / nouni;
	repeated COMPONENT 3 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 2x3 GLM FN/N2 x Time';
proc glm data = ICPS;
	model
		T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNpostmLPFNF
		T61refN2premLPFN  T61refN2N2mLPFN  T61refN2postmLPFN = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 2x3 GLM ERN/FN x Time';
proc glm data = ICPS;
	model
    	T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE
		T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNpostmLPFNF = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 2x3 GLM ERN/N2 x Time';
proc glm data = ICPS;
	model
    	T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE
		T61refN2premLPFN  T61refN2N2mLPFN  T61refN2postmLPFN = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 3-way GLM Time ERN and pairwise';
proc glm data = ICPS;
	model
    	T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE = / nouni;
	repeated TIME 3 polynomial / summary;
run; quit;

proc ttest data = ICPS;
	paired T61refENpremLPFE*T61refENERNmLPFE;
run;
proc ttest data = ICPS;
	paired T61refENERNmLPFE*T61refENpostmLPFE;
run;
proc ttest data = ICPS;
	paired T61refENpremLPFE*T61refENpostmLPFE;
run;

title ' 3-way GLM Time FN and pairwise';
proc glm data = ICPS;
	model
		T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNpostmLPFNF = / nouni;
	repeated TIME 3 polynomial / summary;
run; quit;
proc ttest data = ICPS;
	paired T61refFNpremLPFNF*T61refFNFNmLPFNF;
run;
proc ttest data = ICPS;
	paired T61refFNFNmLPFNF*T61refFNpostmLPFNF;
run;
proc ttest data = ICPS;
	paired T61refFNpremLPFNF*T61refFNpostmLPFNF;
run;

title ' 3-way GLM Time N2 and pairwise';
proc glm data = ICPS;
	model
		T61refN2premLPFN  T61refN2N2mLPFN  T61refN2postmLPFN = / nouni;
	repeated TIME 3 polynomial / summary;
run; quit;
proc ttest data = ICPS;
	paired T61refN2premLPFN*T61refN2N2mLPFN;
run;
proc ttest data = ICPS;
	paired T61refN2N2mLPFN*T61refN2postmLPFN;
run;
proc ttest data = ICPS;
	paired T61refN2premLPFN*T61refN2postmLPFN;
run;

title ' 3-way GLM ROI and pairwise';
proc glm data = ICPS;
	model
		T61refN2N2mLPFN T61refFNFNmLPFNF T61refENERNmLPFE = / nouni;
	repeated TIME 3 polynomial / summary;
run; quit;
proc ttest data = ICPS;
	paired T61refN2N2mLPFN*T61refFNFNmLPFNF;
run;
proc ttest data = ICPS;
	paired T61refFNFNmLPFNF*T61refENERNmLPFE;
run;
proc ttest data = ICPS;
	paired T61refN2N2mLPFN*T61refENERNmLPFE;
run;
title;

/* PROFILE PLOT */

data all;
	set icps;
	variable="T61refENpremLPFE";   PLV = T61refENpremLPFE;   ROI = 'ERN';  time = '1pre';  output;
	variable="T61refENERNmLPFE";   PLV = T61refENERNmLPFE;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="T61refENpostmLPFE";  PLV = T61refENpostmLPFE;  ROI = 'ERN';  time = '3post'; output;
	variable="T61refFNpremLPFNF";  PLV = T61refFNpremLPFNF;  ROI = 'FRN';  time = '1pre';  output;
	variable="T61refFNFNmLPFNF";   PLV = T61refFNFNmLPFNF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="T61refFNpostmLPFNF"; PLV = T61refFNpostmLPFNF; ROI = 'FRN';  time = '3post';  output;
	variable="T61refN2premLPFN";   PLV = T61refN2premLPFN;   ROI = 'N2 ';  time = '1pre';  output;
	variable="T61refN2N2mLPFN";    PLV = T61refN2N2mLPFN;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="T61refN2postmLPFN";  PLV = T61refN2postmLPFN;  ROI = 'N2 ';  time = '3post';  output;
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
	variable="T61refENpremLPFE";   PLV = T61refENpremLPFE;   ROI = 'ERN';  time = '1pre';  output;
	variable="T61refENERNmLPFE";   PLV = T61refENERNmLPFE;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="T61refENpostmLPFE";  PLV = T61refENpostmLPFE;  ROI = 'ERN';  time = '3post'; output;
	variable="T61refFNpremLPFNF";  PLV = T61refFNpremLPFNF;  ROI = 'FRN';  time = '1pre';  output;
	variable="T61refFNFNmLPFNF";   PLV = T61refFNFNmLPFNF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="T61refFNpostmLPFNF"; PLV = T61refFNpostmLPFNF; ROI = 'FRN';  time = '3post';  output;
	variable="T61refN2premLPFN";   PLV = T61refN2premLPFN;   ROI = 'N2 ';  time = '1pre';  output;
	variable="T61refN2N2mLPFN";    PLV = T61refN2N2mLPFN;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="T61refN2postmLPFN";  PLV = T61refN2postmLPFN;  ROI = 'N2 ';  time = '3post';  output;
  	keep variable PLV ROI time;
run;

proc sort;
	by ROI;
run;

proc means noprint;
  	by ROI;
  	var PLV;
  	output out=a n=n mean=xbar var=s2;
run;

data b;
	set a;
	PLV = xbar;
run;

proc sort data = b;
	by ROI;
run; 

proc sgplot data = b;
	series y = PLV x = ROI / markers markerattrs=(symbol=circle) lineattrs=(pattern=solid);
run;




data all;
	set icps;
	variable="T61refENpremLPFE";   PLV = T61refENpremLPFE;   ROI = 'ERN';  time = '1pre';  output;
	variable="T61refENERNmLPFE";   PLV = T61refENERNmLPFE;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="T61refENpostmLPFE";  PLV = T61refENpostmLPFE;  ROI = 'ERN';  time = '3post'; output;
	variable="T61refFNpremLPFNF";  PLV = T61refFNpremLPFNF;  ROI = 'FRN';  time = '1pre';  output;
	variable="T61refFNFNmLPFNF";   PLV = T61refFNFNmLPFNF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="T61refFNpostmLPFNF"; PLV = T61refFNpostmLPFNF; ROI = 'FRN';  time = '3post';  output;
	variable="T61refN2premLPFN";   PLV = T61refN2premLPFN;   ROI = 'N2 ';  time = '1pre';  output;
	variable="T61refN2N2mLPFN";    PLV = T61refN2N2mLPFN;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="T61refN2postmLPFN";  PLV = T61refN2postmLPFN;  ROI = 'N2 ';  time = '3post';  output;
  	keep variable PLV ROI time;
run;

proc sort;
	by time;
run;

proc means noprint;
  	by time;
  	var PLV;
  	output out=a n=n mean=xbar var=s2;
run;

data b;
	set a;
	PLV = xbar;
run;

proc sort data = b;
	by time;
run; 

proc sgplot data = b;
	series y = PLV x = time / markers markerattrs=(symbol=circle) lineattrs=(pattern=solid);
run;
