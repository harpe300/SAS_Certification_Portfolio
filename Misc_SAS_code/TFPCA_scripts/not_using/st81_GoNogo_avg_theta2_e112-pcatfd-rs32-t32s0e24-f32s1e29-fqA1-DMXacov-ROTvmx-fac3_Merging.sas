PROC IMPORT OUT= WORK.thetaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_theta2_e112-pcatfd-rs32-t32s0e24-f
32s1e29-fqA1-DMXacov-ROTvmx-fac3.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data theta_raw;
set work.thetaorg;
if elecname ne 52 and elecname ne 53 and elecname ne 54 and elecname ne 60 and elecname ne 61 and elecname ne 62 
   and elecname ne 78 and elecname ne 79 and elecname ne 80 then delete;
keep subname subnum elecname catcodes PC1m PC2m PC3m;
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

proc transpose data = theta_raw out = theta_rawPC3 prefix = TPC3m;
by subname subnum;
id elecname catcodes; 
var PC3m;
run;

/* merge all PCs */
data theta_raw_allPCs;
	merge theta_rawPC1 theta_rawPC2 theta_rawPC3;
	TPC1mavg1 = mean(TPC1m601, TPC1m611, TPC1m621, TPC1m521, TPC1m531, TPC1m541, TPC1m781, TPC1m791, TPC1m801);
	TPC1mavg2 = mean(TPC1m602, TPC1m612, TPC1m622, TPC1m522, TPC1m532, TPC1m542, TPC1m782, TPC1m792, TPC1m802);
	TPC1mavg3 = mean(TPC1m603, TPC1m613, TPC1m623, TPC1m523, TPC1m533, TPC1m543, TPC1m783, TPC1m793, TPC1m803);
	TPC1mavg4 = mean(TPC1m604, TPC1m614, TPC1m624, TPC1m524, TPC1m534, TPC1m544, TPC1m784, TPC1m794, TPC1m804);
	TPC2mavg1 = mean(TPC2m601, TPC2m611, TPC2m621, TPC2m521, TPC2m531, TPC2m541, TPC2m781, TPC2m791, TPC2m801);
	TPC2mavg2 = mean(TPC2m602, TPC2m612, TPC2m622, TPC2m522, TPC2m532, TPC2m542, TPC2m782, TPC2m792, TPC2m802);
	TPC2mavg3 = mean(TPC2m603, TPC2m613, TPC2m623, TPC2m523, TPC2m533, TPC2m543, TPC2m783, TPC2m793, TPC2m803);
	TPC2mavg4 = mean(TPC2m604, TPC2m614, TPC2m624, TPC2m524, TPC2m534, TPC2m544, TPC2m784, TPC2m794, TPC2m804);
	TPC3mavg1 = mean(TPC3m601, TPC3m611, TPC3m621, TPC3m521, TPC3m531, TPC3m541, TPC3m781, TPC3m791, TPC3m801);
	TPC3mavg2 = mean(TPC3m602, TPC3m612, TPC3m622, TPC3m522, TPC3m532, TPC3m542, TPC3m782, TPC3m792, TPC3m802);
	TPC3mavg3 = mean(TPC3m603, TPC3m613, TPC3m623, TPC3m523, TPC3m533, TPC3m543, TPC3m783, TPC3m793, TPC3m803);
	TPC3mavg4 = mean(TPC3m604, TPC3m614, TPC3m624, TPC3m524, TPC3m534, TPC3m544, TPC3m784, TPC3m794, TPC3m804);
run;


/* create average of Go trials */
data theta_MV;
	set theta_raw_allPCs;
	TPC1mavgG = mean(TPC1mavg2, TPC1mavg3, TPC1mavg4);
	TPC2mavgG = mean(TPC2mavg2, TPC2mavg3, TPC2mavg4);
	TPC3mavgG = mean(TPC3mavg2, TPC3mavg3, TPC3mavg4);
	TPC1mavgN = TPC1mavg1;
	TPC2mavgN = TPC2mavg1;
	TPC3mavgN = TPC3mavg1;
	keep subname subnum TPC1mavg1 TPC1mavg2 TPC1mavg3 TPC1mavg4 TPC2mavg1 TPC2mavg2 TPC2mavg3 TPC2mavg4 TPC3mavg1 TPC3mavg2 TPC3mavg3 TPC3mavg4 TPC1mavgG TPC2mavgG TPC3mavgG TPC1mavgN TPC2mavgN TPC3mavgN;
run;

data mylib.st81_GNG_avg_theta2_3fac_MV;
	set theta_MV;
run;

proc univariate data = theta_MV normal;
	var TPC1mavgG TPC2mavgG TPC3mavgG TPC1mavgN TPC2mavgN TPC3mavgN;
	histogram / normal;
run;
