
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data avg;
	set mylib.s81_gng_t29_avg_ROI_ERNFNN2_mv;
run;

title ' 3x3 MANOVA Component x Time';
proc glm data = avg;
	model
    	TavgENprem61E TavgENERNm61E TavgENpostm61E
		TavgFNprem61NF TavgFNFNm61NF TavgFNpostm61NF
		TavgN2prem61N  TavgN2N2m61N  TavgN2postm61N = / nouni;
	repeated COMPONENT 3 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 2x3 GLM FN/N2 x Time';
proc glm data = avg;
	model
		TavgFNprem61NF TavgFNFNm61NF TavgFNpostm61NF
		TavgN2prem61N  TavgN2N2m61N  TavgN2postm61N = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 2x3 GLM ERN/FN x Time';
proc glm data = avg;
	model
    	TavgENprem61E TavgENERNm61E TavgENpostm61E
		TavgFNprem61NF TavgFNFNm61NF TavgFNpostm61NF = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial /sumamry;
run; quit;

title ' 2x3 GLM ERN/N2 x Time';
proc glm data = avg;
	model
    	TavgENprem61E TavgENERNm61E TavgENpostm61E
		TavgN2prem61N  TavgN2N2m61N  TavgN2postm61N = / nouni;
	repeated COMPONENT 2 polynomial, TIME 3 polynomial / summary;
run; quit;

title ' 3-way GLM Time ERN and pairwise';
proc glm data = avg;
	model
    	TavgENprem61E TavgENERNm61E TavgENpostm61E = / nouni;
	repeated TIME 3 polynomial / summary;
run; quit;

proc ttest data = avg;
	paired TavgENprem61E*TavgENERNm61E;
run;
proc ttest data = avg;
	paired TavgENERNm61E*TavgENpostm61E;
run;
proc ttest data = avg;
	paired TavgENprem61E*TavgENpostm61E;
run;

title ' 3-way GLM Time FN and pairwise';
proc glm data = avg;
	model
		TavgFNprem61NF TavgFNFNm61NF TavgFNpostm61NF = / nouni;
	repeated TIME 3 polynomial / summary;
run; quit;
proc ttest data = avg;
	paired TavgFNprem61NF*TavgFNFNm61NF;
run;
proc ttest data = avg;
	paired TavgFNFNm61NF*TavgFNpostm61NF;
run;
proc ttest data = avg;
	paired TavgFNprem61NF*TavgFNpostm61NF;
run;

title ' 3-way GLM Time N2 and pairwise';
proc glm data = avg;
	model
		TavgN2prem61N  TavgN2N2m61N  TavgN2postm61N = / nouni;
	repeated TIME 3 polynomial / summary;
run; quit;
proc ttest data = avg;
	paired TavgN2prem61N*TavgN2N2m61N;
run;
proc ttest data = avg;
	paired TavgN2N2m61N*TavgN2postm61N;
run;
proc ttest data = avg;
	paired TavgN2prem61N*TavgN2postm61N;
run;

title ' 3-way GLM ROI and pairwise';
proc glm data = avg;
	model
		TavgN2N2m61N TavgFNFNm61NF TavgENERNm61E = / nouni;
	repeated TIME 3 polynomial / summary;
run; quit;
proc ttest data = avg;
	paired TavgN2N2m61N*TavgFNFNm61NF;
run;
proc ttest data = avg;
	paired TavgFNFNm61NF*TavgENERNm61E;
run;
proc ttest data = avg;
	paired TavgN2N2m61N*TavgENERNm61E;
run;
title;

/* PROFILE PLOT */

data all;
	set avg;
	variable="TavgENprem61E";   power = TavgENprem61E;   ROI = 'ERN';  time = '1pre';  output;
	variable="TavgENERNm61E";   power = TavgENERNm61E;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="TavgENpostm61E";  power = TavgENpostm61E;  ROI = 'ERN';  time = '3post'; output;
	variable="TavgFNprem61NF";  power = TavgFNprem61NF;  ROI = 'FRN';  time = '1pre';  output;
	variable="TavgFNFNm61NF";   power = TavgFNFNm61NF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="TavgFNpostm61NF"; power = TavgFNpostm61NF; ROI = 'FRN';  time = '3post';  output;
	variable="TavgN2prem61N";   power = TavgN2prem61N;   ROI = 'N2 ';  time = '1pre';  output;
	variable="TavgN2N2m61N";    power = TavgN2N2m61N;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="TavgN2postm61N";  power = TavgN2postm61N;  ROI = 'N2 ';  time = '3post';  output;
  	keep variable power ROI time;
run;

proc sort;
	by ROI time;
run;

proc means noprint;
  	by ROI time;
  	var power;
  	output out=a n=n mean=xbar var=s2;
run;

data b;
	set a;
	power = xbar;
run;

proc sort data = b;
	by time ROI;
run; 

proc sgplot data = b;
	series y = power x = time / group = ROI markers markerattrs=(symbol=circle) lineattrs=(pattern=solid);
run;


/* PROFILE PLOT */

data all;
	set avg;
	variable="TavgENprem61E";   power = TavgENprem61E;   ROI = 'ERN';  time = '1pre';  output;
	variable="TavgENERNm61E";   power = TavgENERNm61E;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="TavgENpostm61E";  power = TavgENpostm61E;  ROI = 'ERN';  time = '3post'; output;
	variable="TavgFNprem61NF";  power = TavgFNprem61NF;  ROI = 'FRN';  time = '1pre';  output;
	variable="TavgFNFNm61NF";   power = TavgFNFNm61NF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="TavgFNpostm61NF"; power = TavgFNpostm61NF; ROI = 'FRN';  time = '3post';  output;
	variable="TavgN2prem61N";   power = TavgN2prem61N;   ROI = 'N2 ';  time = '1pre';  output;
	variable="TavgN2N2m61N";    power = TavgN2N2m61N;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="TavgN2postm61N";  power = TavgN2postm61N;  ROI = 'N2 ';  time = '3post';  output;
  	keep variable power ROI time;
run;

proc sort;
	by time;
run;

proc means noprint;
  	by time;
  	var power;
  	output out=a n=n mean=xbar var=s2;
run;

data b;
	set a;
	power = xbar;
run;

proc sort data = b;
	by time;
run; 

proc sgplot data = b;
	series y = power x = time / markers markerattrs=(symbol=circle) lineattrs=(pattern=solid);
run;


data all;
	set avg;
	variable="TavgENprem61E";   power = TavgENprem61E;   ROI = 'ERN';  time = '1pre';  output;
	variable="TavgENERNm61E";   power = TavgENERNm61E;   ROI = 'ERN';  time = '2ROI';  output;
  	variable="TavgENpostm61E";  power = TavgENpostm61E;  ROI = 'ERN';  time = '3post'; output;
	variable="TavgFNprem61NF";  power = TavgFNprem61NF;  ROI = 'FRN';  time = '1pre';  output;
	variable="TavgFNFNm61NF";   power = TavgFNFNm61NF;   ROI = 'FRN';  time = '2ROI';  output;
  	variable="TavgFNpostm61NF"; power = TavgFNpostm61NF; ROI = 'FRN';  time = '3post';  output;
	variable="TavgN2prem61N";   power = TavgN2prem61N;   ROI = 'N2 ';  time = '1pre';  output;
	variable="TavgN2N2m61N";    power = TavgN2N2m61N;    ROI = 'N2 ';  time = '2ROI';  output;
  	variable="TavgN2postm61N";  power = TavgN2postm61N;  ROI = 'N2 ';  time = '3post';  output;
  	keep variable power ROI time;
run;

proc sort;
	by ROI;
run;

proc means noprint;
  	by ROI;
  	var power;
  	output out=a n=n mean=xbar var=s2;
run;

data b;
	set a;
	power = xbar;
run;

proc sort data = b;
	by ROI;
run; 

proc sgplot data = b;
	series y = power x = ROI / markers markerattrs=(symbol=circle) lineattrs=(pattern=solid);
run;
