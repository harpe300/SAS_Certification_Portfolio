PROC IMPORT OUT= WORK.ROIorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_e112_BIG-wintfd-rs64-t64-f128-fqA1-theta.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data ROI_raw;
set work.ROIorg;
if elecname ne 63 and elecname ne 65 then delete;
keep subname subnum elecname catcodes dem thm;
run;

proc sort data = ROI_raw;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = ROI_raw out = ROI_rawth prefix = Tm;
by subname subnum ;
id elecname catcodes; 
var thm;
run;

proc transpose data = ROI_raw out = ROI_rawde prefix = Dm;
by subname subnum;
id elecname catcodes; 
var dem;
run;

/* merge all PCs */
data ROI_raw_allPCs;
	merge ROI_rawth ROI_rawde ;
run;


/* create average of Go trials */
data ROI_MV;
	set ROI_raw_allPCs;
	Tm63G = mean(Tm632, Tm633, Tm634);
	Tm63N = Tm631;
	Dm65G = mean(Dm652, Dm653, Dm654);
	Dm65N = Dm651;
	Tm63O = mean(Tm63G, Tm63N);
	Tm63D = Tm63N - Tm63G;
	Dm65O = mean(Dm65G, Dm65N);
	Dm65D = Dm65N - Dm65G;
	keep subname subnum Tm63G Tm63G Dm65G Dm65N Tm63O Tm63D Dm65O Dm65D;
run;

data mylib.st81_GNG_avg_ROI_MV;
	set ROI_MV;
run;

data merged;
	merge ROI_MV mylib.st81_gng_avg_utd_mv mylib.st81_GNG_avg_PCA_ltlwin_MV;
	p2pavgO = mean(p2pavgN, p2pavgG);
	n2pavgO = mean(n2pavgN, n2pavgG);
	p3pavgO = mean(p3pavgN, p3pavgG);
	p2pavgD = p2pavgN - p2pavgG;
	n2pavgD = n2pavgN - n2pavgG;
	p3pavgD = p3pavgN - p3pavgG;
run;

proc reg data = merged;
	model n2pavgO = Tm63O Dm65O;
	model n2pavgD = Tm63D Dm65D;
	model p3pavgO = Tm63O Dm65O;
	model p3pavgD = Tm63D Dm65D;
	model n2pavgO = PC1m64O PC2m66O;
	model n2pavgD = PC1m64D PC2m66D;
	model p3pavgO = PC1m64O PC2m66O;
	model p3pavgD = PC1m64D PC2m66D;
run; quit;

proc corr data = ROI_MV;
	var Tm63O Tm63D Dm65O Dm65D;
run;

proc univariate data = ROI_MV normal;
	var	Tm63O Tm63D Dm65O Dm65D;
	histogram / normal;
run;
