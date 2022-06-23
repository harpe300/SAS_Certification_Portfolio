
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\data';

data avg;
	set mylib.s81_gng_t29_ICPS_ROI_ERNFNN2_mv;
run;

proc glm data = avg;
	model
    	T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE
		T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNpostmLPFNF
		T61refN2premLPFN  T61refN2N2mLPFN  T61refN2postmLPFN = / nouni;
	repeated COMPONENT 3, TIME 3;
run; quit;

proc glm data = avg;
	model
		T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNpostmLPFNF
		T61refN2premLPFN  T61refN2N2mLPFN  T61refN2postmLPFN = / nouni;
	repeated COMPONENT 2, TIME 3;
run; quit;
proc glm data = avg;
	model
    	T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE
		T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNpostmLPFNF = / nouni;
	repeated COMPONENT 2, TIME 3;
run; quit;
proc glm data = avg;
	model
    	T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE
		T61refN2premLPFN  T61refN2N2mLPFN  T61refN2postmLPFN = / nouni;
	repeated COMPONENT 2, TIME 3;
run; quit;

proc glm data = avg;
	model
    	T61refENpremLPFE T61refENERNmLPFE T61refENpostmLPFE = / nouni;
	repeated TIME 3;
run; quit;
proc ttest data = avg;
	paired T61refENpremLPFE*T61refENERNmLPFE;
run;
proc ttest data = avg;
	paired T61refENERNmLPFE*T61refENpostmLPFE;
run;
proc ttest data = avg;
	paired T61refENpremLPFE*T61refENpostmLPFE;
run;
proc ttest data = avg;
	paired T61refENERNmLPFE*T61refENERNmLPFC;
run;

proc glm data = avg;
	model
		T61refFNpremLPFNF T61refFNFNmLPFNF T61refFNpostmLPFNF = / nouni;
	repeated TIME 3;
run; quit;
proc ttest data = avg;
	paired T61refFNpremLPFNF*T61refFNFNmLPFNF;
run;
proc ttest data = avg;
	paired T61refFNFNmLPFNF*T61refFNpostmLPFNF;
run;
proc ttest data = avg;
	paired T61refFNpremLPFNF*T61refFNpostmLPFNF;
run;

proc glm data = avg;
	model
		T61refN2premLPFN  T61refN2N2mLPFN  T61refN2postmLPFN = / nouni;
	repeated TIME 3;
run; quit;
proc ttest data = avg;
	paired T61refN2premLPFN*T61refN2N2mLPFN;
run;
proc ttest data = avg;
	paired T61refN2N2mLPFN*T61refN2postmLPFN;
run;
proc ttest data = avg;
	paired T61refN2premLPFN*T61refN2postmLPFN;
run;
proc ttest data = avg;
	paired T61refN2N2mLPFN*T61refN2N2mLPFG;
run;


proc glm data = avg;
	model
		T61refN2premLPFN T61refFNFNmLPFNF T61refENERNmLPFE = / nouni;
	repeated TIME 3;
run; quit;
proc ttest data = avg;
	paired T61refN2N2mLPFN*T61refFNFNmLPFNF;
run;
proc ttest data = avg;
	paired T61refFNFNmLPFNF*T61refENERNmLPFE;
run;
proc ttest data = avg;
	paired T61refN2N2mLPFN*T61refENERNmLPFE;
run;



/* PROFILE PLOT */

data all;
	set avg;
	variable="T61refENpremLPFE";   power = T61refENpremLPFE; output;
	variable="T61refENERNmLPFE";   power = T61refENERNmLPFE; output;
  	variable="T61refENpostmLPFE";  power = T61refENpostmLPFE; output;
	variable="T61refFNpremLPFNF";  power = T61refFNpremLPFNF; output;
	variable="T61refFNFNmLPFNF";   power = T61refFNFNmLPFNF; output;
  	variable="T61refFNpostmLPFNF"; power = T61refFNpostmLPFNF; output;
	variable="T61refN2premLPFN";   power = T61refN2premLPFN; output;
	variable="T61refN2N2mLPFN";    power = T61refN2N2mLPFN; output;
  	variable="T61refN2postmLPFN";  power = T61refN2postmLPFN; output;
  	keep variable power;
run;

proc sort;
	by variable;
run;

proc means noprint;
  	by variable;
  	var power;
  	output out=a n=n mean=xbar var=s2;
run;

data b;
	set a;
	power = xbar;
	if variable = 'T61refENpremLPFE' then variable = '1T61refERNmLPFE';
	if variable = 'T61refENERNmLPFE' then variable = '2T61refERNmLPFE';
	if variable = 'T61refENpostmLPF' then variable = '3T61refERNmLPFE';
	if variable = 'T61refFNpremLPFN' then variable = '4T61refFNmLPFNF';
	if variable = 'T61refFNFNmLPFNF' then variable = '5T61refFNmLPFNF';
	if variable = 'T61refFNpostmLPF' then variable = '6T61refFNNmLPFNF';
	if variable = 'T61refN2premLPFN' then variable = '7T61refN2mLPFE';
	if variable = 'T61refN2N2mLPFN'  then variable = '8T61refN2mLPFE';
	if variable = 'T61refN2postmLPF' then variable = '9T61refN2mLPFE';
run;

proc sort data = b;
	by variable;
run; 

proc sgplot data = b;
	series y = power x = variable / markers markerattrs=(symbol=circle) lineattrs=(pattern=solid);
run;
