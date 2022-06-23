
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data itps;
	set mylib.s81_gng_t29_itps_ROI_ERNFNN2_mv;
run;

title ' 3x3 MANOVA Component x Time';
proc glm data = itps;
	model
    	TITENprem61E TITENERNm61E TITENpostm61E
		TITFNprem61NF TITFNFNm61NF TITFNpostm61NF
		TITN2prem61N  TITN2N2m61N  TITN2postm61N = / nouni;
	repeated COMPONENT 3 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 2x3 GLM FN/N2 x Time';
proc glm data = itps;
	model
		TITFNprem61NF TITFNFNm61NF TITFNpostm61NF
		TITN2prem61N  TITN2N2m61N  TITN2postm61N = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 2x3 GLM ERN/FN x Time';
proc glm data = itps;
	model
    	TITENprem61E TITENERNm61E TITENpostm61E
		TITFNprem61NF TITFNFNm61NF TITFNpostm61NF = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 2x3 GLM ERN/N2 x Time';
proc glm data = itps;
	model
    	TITENprem61E TITENERNm61E TITENpostm61E
		TITN2prem61N  TITN2N2m61N  TITN2postm61N = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 3-way GLM Time ERN and pairwise';
proc glm data = itps;
	model
    	TITENprem61E TITENERNm61E TITENpostm61E = / nouni;
	repeated TIME 3 polynomial / summary;;
run; quit;

proc ttest data = itps;
	paired TITENprem61E*TITENERNm61E;
run;
proc ttest data = itps;
	paired TITENERNm61E*TITENpostm61E;
run;
proc ttest data = itps;
	paired TITENprem61E*TITENpostm61E;
run;

title ' 3-way GLM Time FN and pairwise';
proc glm data = itps;
	model
		TITFNprem61NF TITFNFNm61NF TITFNpostm61NF = / nouni;
	repeated TIME 3 polynomial / summary;;
run; quit;
proc ttest data = itps;
	paired TITFNprem61NF*TITFNFNm61NF;
run;
proc ttest data = itps;
	paired TITFNFNm61NF*TITFNpostm61NF;
run;
proc ttest data = itps;
	paired TITFNprem61NF*TITFNpostm61NF;
run;

title ' 3-way GLM Time N2 and pairwise';
proc glm data = itps;
	model
		TITN2prem61N  TITN2N2m61N  TITN2postm61N = / nouni;
	repeated TIME 3 polynomial / summary;;
run; quit;
proc ttest data = itps;
	paired TITN2prem61N*TITN2N2m61N;
run;
proc ttest data = itps;
	paired TITN2N2m61N*TITN2postm61N;
run;
proc ttest data = itps;
	paired TITN2prem61N*TITN2postm61N;
run;

title ' 3-way GLM ROI and pairwise';
proc glm data = itps;
	model
		TITN2N2m61N TITFNFNm61NF TITENERNm61E = / nouni;
	repeated TIME 3 polynomial / summary;;
run; quit;
proc ttest data = itps;
	paired TITN2N2m61N*TITFNFNm61NF;
run;
proc ttest data = itps;
	paired TITFNFNm61NF*TITENERNm61E;
run;
proc ttest data = itps;
	paired TITN2N2m61N*TITENERNm61E;
run;
title;

/* PROFILE PLOT */

data all;
	set itps;
	variable="TITENprem61E";   PLV = TITENprem61E;   ROI = 'ERN';  time = '1pre';  output;
	variable="TITENERNm61E";   PLV = TITENERNm61E;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="TITENpostm61E";  PLV = TITENpostm61E;  ROI = 'ERN';  time = '3post'; output;
	variable="TITFNprem61NF";  PLV = TITFNprem61NF;  ROI = 'FRN';  time = '1pre';  output;
	variable="TITFNFNm61NF";   PLV = TITFNFNm61NF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="TITFNpostm61NF"; PLV = TITFNpostm61NF; ROI = 'FRN';  time = '3post';  output;
	variable="TITN2prem61N";   PLV = TITN2prem61N;   ROI = 'N2 ';  time = '1pre';  output;
	variable="TITN2N2m61N";    PLV = TITN2N2m61N;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="TITN2postm61N";  PLV = TITN2postm61N;  ROI = 'N2 ';  time = '3post';  output;
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
	set itps;
	variable="TITENprem61E";   PLV = TITENprem61E;   ROI = 'ERN';  time = '1pre';  output;
	variable="TITENERNm61E";   PLV = TITENERNm61E;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="TITENpostm61E";  PLV = TITENpostm61E;  ROI = 'ERN';  time = '3post'; output;
	variable="TITFNprem61NF";  PLV = TITFNprem61NF;  ROI = 'FRN';  time = '1pre';  output;
	variable="TITFNFNm61NF";   PLV = TITFNFNm61NF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="TITFNpostm61NF"; PLV = TITFNpostm61NF; ROI = 'FRN';  time = '3post';  output;
	variable="TITN2prem61N";   PLV = TITN2prem61N;   ROI = 'N2 ';  time = '1pre';  output;
	variable="TITN2N2m61N";    PLV = TITN2N2m61N;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="TITN2postm61N";  PLV = TITN2postm61N;  ROI = 'N2 ';  time = '3post';  output;
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


data all;
	set itps;
	variable="TITENprem61E";   PLV = TITENprem61E;   ROI = 'ERN';  time = '1pre';  output;
	variable="TITENERNm61E";   PLV = TITENERNm61E;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="TITENpostm61E";  PLV = TITENpostm61E;  ROI = 'ERN';  time = '3post'; output;
	variable="TITFNprem61NF";  PLV = TITFNprem61NF;  ROI = 'FRN';  time = '1pre';  output;
	variable="TITFNFNm61NF";   PLV = TITFNFNm61NF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="TITFNpostm61NF"; PLV = TITFNpostm61NF; ROI = 'FRN';  time = '3post';  output;
	variable="TITN2prem61N";   PLV = TITN2prem61N;   ROI = 'N2 ';  time = '1pre';  output;
	variable="TITN2N2m61N";    PLV = TITN2N2m61N;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="TITN2postm61N";  PLV = TITN2postm61N;  ROI = 'N2 ';  time = '3post';  output;
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
