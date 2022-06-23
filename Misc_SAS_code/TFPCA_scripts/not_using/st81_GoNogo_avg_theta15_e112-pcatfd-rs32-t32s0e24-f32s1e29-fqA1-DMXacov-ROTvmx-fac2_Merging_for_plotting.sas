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
keep subname subnum elecname catcodes PC1m;
run;

proc sort data = theta_raw;
by subname subnum catcodes elecname;
run;

proc transpose data = theta_raw out = theta_rawPC1 prefix = TPC1m;
by subname subnum catcodes;
id elecname; 
var PC1m;
run;


/* merge all PCs */
data theta_raw_allPCs;
	set theta_rawPC1;
	TPC1mavg = mean(TPC1m52, TPC1m53, TPC1m61, TPC1m62, TPC1m78, TPC1m79);
	if catcodes = 1 then catcodes = 1;
		else if catcodes = 2 then catcodes = 2;
		else if catcodes = 3 then catcodes = 2;
		else if catcodes = 4 then catcodes = 2;
	keep subname subnum catcodes TPC1mavg;
run;

 proc sgplot data = theta_raw_allPCs;
 	vbar catcodes / stat = mean response=TPC1mavg limitstat = stderr; 
 run;


