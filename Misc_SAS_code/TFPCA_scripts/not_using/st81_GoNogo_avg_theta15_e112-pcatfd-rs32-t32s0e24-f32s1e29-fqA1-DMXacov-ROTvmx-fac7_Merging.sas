PROC IMPORT OUT= WORK.thetaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_theta15_e112_BIG-pcatfd-rs64-t64s0e48-f128s1e57-fqA1-DMXacov-ROTvmx-fac7.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data theta_raw;
set work.thetaorg;
if elecname ne 52 and elecname ne 53 and elecname ne 54 and elecname ne 60 and elecname ne 61 and elecname ne 62 
   and elecname ne 78 and elecname ne 79 and elecname ne 80 and elecname ne 46 and elecname ne 47 and elecname ne 48 and elecname ne 65 and elecname ne 66 and elecname ne 67
   and elecname ne 72 and elecname ne 73 and elecname ne 74 then delete;
keep subname subnum elecname catcodes PC1m PC2m PC3m PC4m PC5m PC6m PC7m;
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

proc transpose data = theta_raw out = theta_rawPC4 prefix = TPC4m;
by subname subnum;
id elecname catcodes; 
var PC4m;
run;

proc transpose data = theta_raw out = theta_rawPC5 prefix = TPC5m;
by subname subnum;
id elecname catcodes; 
var PC5m;
run;

proc transpose data = theta_raw out = theta_rawPC6 prefix = TPC6m;
by subname subnum;
id elecname catcodes; 
var PC6m;
run;

proc transpose data = theta_raw out = theta_rawPC7 prefix = TPC7m;
by subname subnum;
id elecname catcodes; 
var PC7m;
run;

/* merge all PCs */
data theta_raw_allPCs;
	merge theta_rawPC1 theta_rawPC2 theta_rawPC3 theta_rawPC4 theta_rawPC5 theta_rawPC6 theta_rawPC7;
	TPC1mavg1 = mean(TPC1m601, TPC1m611, TPC1m621, TPC1m521, TPC1m531, TPC1m541, TPC1m781, TPC1m791, TPC1m801);
	TPC1mavg2 = mean(TPC1m602, TPC1m612, TPC1m622, TPC1m522, TPC1m532, TPC1m542, TPC1m782, TPC1m792, TPC1m802);
	TPC1mavg3 = mean(TPC1m603, TPC1m613, TPC1m623, TPC1m523, TPC1m533, TPC1m543, TPC1m783, TPC1m793, TPC1m803);
	TPC1mavg4 = mean(TPC1m604, TPC1m614, TPC1m624, TPC1m524, TPC1m534, TPC1m544, TPC1m784, TPC1m794, TPC1m804);
	TPC2mavg1 = mean(TPC2m651, TPC2m661, TPC2m671, TPC2m461, TPC2m471, TPC2m481, TPC2m721, TPC2m731, TPC2m741);
	TPC2mavg2 = mean(TPC2m652, TPC2m662, TPC2m672, TPC2m462, TPC2m472, TPC2m482, TPC2m722, TPC2m732, TPC2m742);
	TPC2mavg3 = mean(TPC2m653, TPC2m663, TPC2m673, TPC2m463, TPC2m473, TPC2m483, TPC2m723, TPC2m733, TPC2m743);
	TPC2mavg4 = mean(TPC2m654, TPC2m664, TPC2m674, TPC2m464, TPC2m474, TPC2m484, TPC2m724, TPC2m734, TPC2m744);
	TPC3mavg1 = mean(TPC3m601, TPC3m611, TPC3m621, TPC3m521, TPC3m531, TPC3m541, TPC3m781, TPC3m791, TPC3m801);
	TPC3mavg2 = mean(TPC3m602, TPC3m612, TPC3m622, TPC3m522, TPC3m532, TPC3m542, TPC3m782, TPC3m792, TPC3m802);
	TPC3mavg3 = mean(TPC3m603, TPC3m613, TPC3m623, TPC3m523, TPC3m533, TPC3m543, TPC3m783, TPC3m793, TPC3m803);
	TPC3mavg4 = mean(TPC3m604, TPC3m614, TPC3m624, TPC3m524, TPC3m534, TPC3m544, TPC3m784, TPC3m794, TPC3m804);
	TPC5mavg1 = mean(TPC5m601, TPC5m611, TPC5m621, TPC5m521, TPC5m531, TPC5m541, TPC5m781, TPC5m791, TPC5m801);
	TPC5mavg2 = mean(TPC5m602, TPC5m612, TPC5m622, TPC5m522, TPC5m532, TPC5m542, TPC5m782, TPC5m792, TPC5m802);
	TPC5mavg3 = mean(TPC5m603, TPC5m613, TPC5m623, TPC5m523, TPC5m533, TPC5m543, TPC5m783, TPC5m793, TPC5m803);
	TPC5mavg4 = mean(TPC5m604, TPC5m614, TPC5m624, TPC5m524, TPC5m534, TPC5m544, TPC5m784, TPC5m794, TPC5m804);
run;

/* create average of Go trials */
data theta_MV;
	set theta_raw_allPCs;
	TPC1mavgG = mean(TPC1mavg2, TPC1mavg3, TPC1mavg4);
	TPC2mavgG = mean(TPC2mavg2, TPC2mavg3, TPC2mavg4);
	TPC3mavgG = mean(TPC3mavg2, TPC3mavg3, TPC3mavg4);
	TPC5mavgG = mean(TPC5mavg2, TPC5mavg3, TPC5mavg4);
	TPC1mavgN = TPC1mavg1;
	TPC2mavgN = TPC2mavg1;
	TPC3mavgN = TPC3mavg1;
	TPC5mavgN = TPC5mavg1;
	TPC1mavgD = TPC1mavgN - TPC1mavgG;
	TPC2mavgD = TPC2mavgN - TPC2mavgG;
	TPC3mavgD = TPC3mavgN - TPC3mavgG;
	TPC5mavgD = TPC5mavgN - TPC5mavgG;
run;

data mylib.st81_GNG_avg_theta15_7PC_MV;
	set theta_MV;
run;

proc univariate data = theta_MV normal;
	var TPC1mavgD TPC2mavgD TPC3mavgD TPC5mavgD;
	histogram / normal;
run;
