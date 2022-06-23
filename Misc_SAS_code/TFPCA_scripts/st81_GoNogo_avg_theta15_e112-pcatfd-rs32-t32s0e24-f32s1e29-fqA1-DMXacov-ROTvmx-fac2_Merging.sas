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
	if elecname ne 52 and elecname ne 53 and elecname ne 61 and elecname ne 62 
		and elecname ne 78 and elecname ne 79 then delete;
keep subname subnum elecname catcodes PC1m PC2m;
run;

proc sort data = theta_raw;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = theta_raw out = theta_rawPC1 prefix = TPC1m;
by subname subnum;
id elecname catcodes; 
var PC1m;
run;

proc transpose data = theta_raw out = theta_rawPC2 prefix = TPC2m;
by subname subnum;
id elecname catcodes; 
var PC2m;
run;

/* merge all PCs */
data theta_raw_allPCs;
	merge theta_rawPC1 theta_rawPC2;
	TPC1mavg1 = mean(TPC1m611, TPC1m621, TPC1m521, TPC1m531, TPC1m781, TPC1m791);
	TPC1mavg2 = mean(TPC1m612, TPC1m622, TPC1m522, TPC1m532, TPC1m782, TPC1m792);
	TPC1mavg3 = mean(TPC1m613, TPC1m623, TPC1m523, TPC1m533, TPC1m783, TPC1m793);
	TPC1mavg4 = mean(TPC1m614, TPC1m624, TPC1m524, TPC1m534, TPC1m784, TPC1m794);
	TPC2mavg1 = mean(TPC2m611, TPC2m621, TPC2m521, TPC2m531, TPC2m781, TPC2m791);
	TPC2mavg2 = mean(TPC2m612, TPC2m622, TPC2m522, TPC2m532, TPC2m782, TPC2m792);
	TPC2mavg3 = mean(TPC2m613, TPC2m623, TPC2m523, TPC2m533, TPC2m783, TPC2m793);
	TPC2mavg4 = mean(TPC2m614, TPC2m624, TPC2m524, TPC2m534, TPC2m784, TPC2m794);
run;

/* create average of Go trials */
data theta_MV;
	set theta_raw_allPCs;
	TPC1mavgG = mean(TPC1mavg2, TPC1mavg3, TPC1mavg4);
	TPC2mavgG = mean(TPC2mavg2, TPC2mavg3, TPC2mavg4);
	TPC1mavgN = TPC1mavg1;
	TPC2mavgN = TPC2mavg1;
	TPC1mavgD = TPC1mavgN - TPC1mavgG;
	TPC2mavgD = TPC2mavgN - TPC2mavgG;
	drop _name_;
run;

data mylib.st81_GNG_avg_theta15_2PC_MV;
	set theta_MV;
run;

proc univariate data = theta_MV normal;
	var TPC1mavgD TPC2mavgD TPC1mavgDB;
	histogram / normal;
run;
