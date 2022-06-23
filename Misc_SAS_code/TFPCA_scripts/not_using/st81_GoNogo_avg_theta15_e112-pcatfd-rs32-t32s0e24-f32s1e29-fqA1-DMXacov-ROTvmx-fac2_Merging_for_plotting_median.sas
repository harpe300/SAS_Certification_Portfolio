PROC IMPORT OUT= WORK.thetaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_theta15_e112_BIG-pcatfd-rs64-t64s0e48-f128s1e57-fqA1-DMXacov-ROTvmx-fac2-median.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data theta_raw;
set work.thetaorg;
	if elecname ne 52 and elecname ne 53 and elecname ne 61 and elecname ne 62 
		and elecname ne 78 and elecname ne 79 then delete;
keep subname subnum elecname catcodes PC1d;
run;

proc sort data = theta_raw;
by subname subnum catcodes elecname;
run;

proc transpose data = theta_raw out = theta_rawPC1 prefix = TPC1d;
by subname subnum catcodes;
id elecname; 
var PC1d;
run;


/* merge all PCs */
data theta_raw_allPCs;
	set theta_rawPC1;
	TPC1davg = mean(TPC1d52, TPC1d53, TPC1d61, TPC1d62, TPC1d78, TPC1d79);
	if catcodes = 1 then catcodes = 1;
		else if catcodes = 2 then catcodes = 2;
		else if catcodes = 3 then catcodes = 2;
		else if catcodes = 4 then catcodes = 2;
	keep subname subnum catcodes TPC1davg;
run;

 proc sgplot data = theta_raw_allPCs;
 	vbar catcodes / stat = mean response=TPC1davg limitstat = stderr; 
 run;


