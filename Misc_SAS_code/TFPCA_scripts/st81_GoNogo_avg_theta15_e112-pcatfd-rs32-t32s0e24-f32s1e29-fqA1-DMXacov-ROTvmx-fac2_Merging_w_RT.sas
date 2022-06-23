PROC IMPORT OUT= WORK.thetaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_theta15_e112_BIG-pcatfd-rs64-t64s0e48-f128s1e57-fqA1-DMXacov-ROTvmx-fac2.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data theta_raw;
set work.thetaorg;
	if elecname ne 62 then delete;
keep subname subnum rt catcodes PC1m;
run;

proc sort data = theta_raw;
by subname subnum catcodes;
run;

proc means data = theta_raw;
	var PC1m;
	class catcodes;
	output out = means mean = M;
run;

proc sgplot data=means;                                                                                                                                                                                                       
   label M = "TPC1m";
   series y = M x = catcodes / markers markerattrs=(symbol=circle) lineattrs=(pattern=solid) ;  
   xaxis label = "Go/Nogo";
   yaxis label = "Power";
   run;                                                                                                                                 
quit;

proc transpose data = theta_raw out = theta_rawPC1 prefix = TPC1m;
by subname subnum;
id catcodes; 
var PC1m;
run;

proc transpose data = theta_raw out = theta_rawrt prefix = RT;
by subname subnum;
id catcodes; 
var rt;
run;

data merged;
	merge theta_rawrt theta_rawPC1;
	drop _name_;
run;


/* merge all PCs */
data theta_raw_allPCs;
	set merged;
	TPC1mavg1 = mean(TPC1m611, TPC1m621, TPC1m521, TPC1m531, TPC1m781, TPC1m791);
	TPC1mavg2 = mean(TPC1m612, TPC1m622, TPC1m522, TPC1m532, TPC1m782, TPC1m792);
	TPC1mavg3 = mean(TPC1m613, TPC1m623, TPC1m523, TPC1m533, TPC1m783, TPC1m793);
	TPC1mavg4 = mean(TPC1m614, TPC1m624, TPC1m524, TPC1m534, TPC1m784, TPC1m794);
	RTavg1 = mean(RT611, RT621, RT521, RT531, RT781, RT791);
	RTavg2 = mean(RT612, RT622, RT522, RT532, RT782, RT792);
	RTavg3 = mean(RT613, RT623, RT523, RT533, RT783, RT793);
	RTavg4 = mean(RT614, RT624, RT524, RT534, RT784, RT794);
	TPC1mavgG = mean(TPC1mavg2, TPC1mavg3, TPC1mavg4);
	RTavgG = mean(RTavg2, RTavg3, RTavg4);
	TPC1mavgN = TPC1mavg1;
	RTavgN = RTavg1;
	TPC1mavgD = TPC1mavgN - TPC1mavgG;
	RTavgD = RTavgN - RTavgG;
run;

proc univariate data = theta_raw_allPCs normal;
	var RTavgG TPC1mavgG;
	histogram / normal;
run;

proc univariate data = theta_raw_allPCs normal;
	var RTavg2 RTavg3 RTavg4;
	histogram / normal;
run;

proc glm data = theta_raw_allPCs;	
	model RTavg2 RTavg3 RTavg4 = / nouni;	
	repeated GO 3 / mean;
run; quit;

proc corr data = theta_raw_allPCs pearson spearman plots = matrix;
	var TPC1mavgG RTavgG;
run;


