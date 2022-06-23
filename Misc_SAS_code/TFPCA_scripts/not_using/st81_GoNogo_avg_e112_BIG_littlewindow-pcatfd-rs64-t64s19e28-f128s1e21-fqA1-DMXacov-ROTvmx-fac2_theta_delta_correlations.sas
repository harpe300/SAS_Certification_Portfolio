PROC IMPORT OUT= WORK.PCAorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_e112_BIG-pcatfd-rs64-t64s19e28-f128s1e21-fqA1-DMXacov-ROTvmx-fac2.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data PCA_raw;
set work.PCAorg;
if elecname ne 64 and elecname ne 66 then delete;
keep subname subnum elecname catcodes PC1m PC2m;
run;

proc sort data = PCA_raw;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = PCA_raw out = PCA_rawPC1m prefix = PC1m;
by subname subnum ;
id elecname catcodes; 
var PC1m;
run;

proc transpose data = PCA_raw out = PCA_rawPC2m prefix = PC2m;
by subname subnum;
id elecname catcodes; 
var PC2m;
run;

/* merge all PCs */
data PCA_raw_allPCs;
	merge PCA_rawPC1m PCA_rawPC2m;
run;


/* create average of Go trials */
data PCA_MV;
	set PCA_raw_allPCs;
	PC1m64G = mean(PC1m642, PC1m643, PC1m644);
	PC1m64N = PC1m641;
	PC2m66G = mean(PC2m662, PC2m663, PC2m664);
	PC2m66N = PC2m661;
	PC1m64O = mean(PC1m64G, PC1m64N);
	PC1m64D = PC1m64N - PC1m64G;
	PC2m66O = mean(PC2m66G, PC2m66N);
	PC2m66D = PC2m66N - PC2m66G;
	keep subname subnum PC1m64G PC1m64G PC2m66G PC2m66N PC1m64O PC1m64D PC2m66O PC2m66D;
run;

data mylib.st81_GNG_avg_PCA_ltlwin_MV;
	set PCA_MV;
run;

proc corr data = PCA_MV;
	var PC1m64O PC1m64D PC2m66O PC2m66D;
run;

proc univariate data = PCA_MV normal;
	var	PC1m64O PC1m64D PC2m66O PC2m66D;
	histogram / normal;
run;
