PROC IMPORT OUT= WORK.deltaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_delta15_e112_BIG-pcatfd-rs64-t64s0e64-f128s1e57-fqA1-DMXacov-ROTvmx-fac3.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data delta_raw;
set work.deltaorg;
	if elecname ne 50 and elecname ne 51 and elecname ne 63 and elecname ne 
		64 and elecname ne 76 and elecname ne 77 then delete;
keep subname subnum elecname catcodes PC1m PC2m PC3m;
run;

proc sort data = delta_raw;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = delta_raw out = delta_rawPC1 prefix = DPC1m;
by subname subnum;
id elecname catcodes; 
var PC1m;
run;

proc transpose data = delta_raw out = delta_rawPC2 prefix = DPC2m;
by subname subnum;
id elecname catcodes; 
var PC2m;
run;

proc transpose data = delta_raw out = delta_rawPC3 prefix = DPC3m;
by subname subnum;
id elecname catcodes; 
var PC3m;
run;

/* merge all PCs */
data delta_raw_allPCs;
	merge delta_rawPC1 delta_rawPC2 delta_rawPC3;
	DPC1mavg1 = mean(DPC1m501, DPC1m511, DPC1m631, DPC1m641, DPC1m761, DPC1m771);
	DPC1mavg2 = mean(DPC1m502, DPC1m512, DPC1m632, DPC1m642, DPC1m762, DPC1m772);
	DPC1mavg3 = mean(DPC1m503, DPC1m513, DPC1m633, DPC1m643, DPC1m763, DPC1m773);
	DPC1mavg4 = mean(DPC1m504, DPC1m514, DPC1m634, DPC1m644, DPC1m764, DPC1m774);
	DPC2mavg1 = mean(DPC2m501, DPC2m511, DPC2m631, DPC2m641, DPC2m761, DPC2m771);
	DPC2mavg2 = mean(DPC2m502, DPC2m512, DPC2m632, DPC2m642, DPC2m762, DPC2m772);
	DPC2mavg3 = mean(DPC2m503, DPC2m513, DPC2m633, DPC2m643, DPC2m763, DPC2m773);
	DPC2mavg4 = mean(DPC2m504, DPC2m514, DPC2m634, DPC2m644, DPC2m764, DPC2m774);
	DPC3mavg1 = mean(DPC3m501, DPC3m511, DPC3m631, DPC3m641, DPC3m761, DPC3m771);
	DPC3mavg2 = mean(DPC3m502, DPC3m512, DPC3m632, DPC3m642, DPC3m762, DPC3m772);
	DPC3mavg3 = mean(DPC3m503, DPC3m513, DPC3m633, DPC3m643, DPC3m763, DPC3m773);
	DPC3mavg4 = mean(DPC3m504, DPC3m514, DPC3m634, DPC3m644, DPC3m764, DPC3m774);
run;


/* create average of Go trials */
data delta_MV;
	set delta_raw_allPCs;
	DPC1mavgG = mean(DPC1mavg2, DPC1mavg3, DPC1mavg4);
	DPC2mavgG = mean(DPC2mavg2, DPC2mavg3, DPC2mavg4);
	DPC3mavgG = mean(DPC3mavg2, DPC3mavg3, DPC3mavg4);
	DPC1mavgN = DPC1mavg1;
	DPC2mavgN = DPC2mavg1;
	DPC3mavgN = DPC3mavg1;
	DPC1mavgD = DPC1mavgN - DPC1mavgG;
	DPC2mavgD = DPC2mavgN - DPC2mavgG;
	DPC3mavgD = DPC3mavgN - DPC3mavgG;
	drop _name_;
run;

data mylib.st81_GNG_avg_delta15_3PC_MV;
	set delta_MV;
run;

proc univariate data = delta_MV normal;
	var DPC1mavgD DPC2mavgD DPC3mavgD;
	histogram / normal;
run;
