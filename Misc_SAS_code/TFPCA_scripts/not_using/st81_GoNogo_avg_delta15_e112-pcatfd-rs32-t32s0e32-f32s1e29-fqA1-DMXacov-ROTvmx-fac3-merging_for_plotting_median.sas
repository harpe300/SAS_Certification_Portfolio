PROC IMPORT OUT= WORK.deltaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_delta15_e112_BIG-pcatfd-rs64-t64s0e64-f128s1e57-fqA1-DMXacov-ROTvmx-fac3-median.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data delta_raw;
set work.deltaorg;
	if elecname ne 50 and elecname ne 51 and elecname ne 63 and elecname ne 
		64 and elecname ne 76 and elecname ne 77 then delete;
keep subname subnum elecname catcodes PC2d;
run;

proc sort data = delta_raw;
by subname subnum catcodes elecname;
run;

proc transpose data = delta_raw out = delta_rawPC2 prefix = DPC2d;
by subname subnum catcodes;
id elecname; 
var PC2d;
run;


/* merge all PCs */
data delta_raw_allPCs;
	set delta_rawPC2;
	DPC2davg = mean(DPC2d50, DPC2d51, DPC2d63, DPC2d64, DPC2d76, DPC2d77);
	if catcodes = 1 then catcodes = 1;
		else if catcodes = 2 then catcodes = 2;
		else if catcodes = 3 then catcodes = 2;
		else if catcodes = 4 then catcodes = 2;
	keep subname subnum catcodes DPC2davg;
run;

 proc sgplot data = delta_raw_allPCs;
 	vbar catcodes / stat = mean response=DPC2davg limitstat = stderr; 
 run;


