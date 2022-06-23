PROC IMPORT OUT= WORK.deltaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
ind_diff\output_data\st81_GoNogo_avg_delta15_e112_BIG-pcatfd-rs64-t64s0e64-f128s1e57-fqA1-DMXacov-ROTvmx-fac3.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ind_diff\data';

data delta_raw;
	set work.deltaorg;
	if elecname ne 48 and elecname ne 49 and  elecname ne 50 and elecname ne 51 and elecname ne 63 and elecname ne 64 and elecname ne 65 and elecname ne 74 and elecname ne 75 and elecname ne 76 and elecname ne 77 then delete;
	keep subname subnum elecname catcodes PC1m PC2m PC3m ext_grp_100 ext_pro_100 ext_grp_159 ext_pro_159 pemt nemt cont stai_tot zung_tot;
run;

data ind_diff;
	set work.deltaorg;
	if elecname ne 63 then delete;
	if catcodes ne 1 then delete;
	keep subname subnum ext_grp_100 ext_pro_100 ext_grp_159 ext_pro_159 pemt nemt cont stai_tot zung_tot;
run;



proc sort data = delta_raw;
	by subname subnum catcodes;
run;

/* create MV dataset of elec */

proc transpose data = delta_raw out = delta_rawPC1m prefix = DPC1m;
	by subname subnum catcodes;
	id elecname; 
	var PC1m;
run;

proc transpose data = delta_raw out = delta_rawPC2m prefix = DPC2m;
	by subname subnum catcodes;
	id elecname; 
	var PC2m;
run;

proc transpose data = delta_raw out = delta_rawPC3m prefix = DPC3m;
	by subname subnum catcodes;
	id elecname; 
	var PC3m;
run;

/* merge all PCs */
data delta_raw_allPCs;
	merge delta_rawPC3m;
        by subname;
	DPC3mavg = mean(DPC3m48, DPC3m49, DPC3m50, DPC3m51, DPC3m63, DPC3m64, DPC3m65, DPC3m74, DPC3m75, DPC3m76, DPC3m77);
run;

proc univariate data = delta_raw_allPCs;
	var DPC3mavg;
run;

data trans;
	set delta_raw_allPCs;
	z = 0;
run;

proc transreg data=trans details maxiter=0 nozeroconstant;
	model BoxCox(DPC3mavg / convenient alpha=0.05) = identity(z);
    output out= boxcox;
run;

proc univariate data = boxcox normal;
	var TDPC3mavg;
	histogram / normal;
run;

data T_PCs;
	set boxcox;
	keep TDPC3mavg;
run;
	
data delta_raw_T_PCs;
	merge delta_raw_allPCs T_PCs;
run;

proc sort data = delta_raw_T_PCs;
	by subname subnum catcodes;
run;

/* create MV dataset */
proc transpose data = delta_raw_T_PCs out = delta_raw_T_PC prefix = TDPC3mavg;
	by subname subnum;
	id catcodes; 
	var TDPC3mavg;
run;

proc transpose data = delta_raw_T_PCs out = delta_raw_UT_PC prefix = DPC3mavg;
	by subname subnum;
	id catcodes; 
	var DPC3mavg;
run;

/* create average of Go trials */
data delta_MV;
	merge delta_raw_T_PC delta_raw_UT_PC ind_diff;
	DPC3mavgG = mean(DPC3mavg2, DPC3mavg3, DPC3mavg4);
	DPC3mavgN = DPC3mavg1;
	DPC3mavgO = mean(DPC3mavgG, DPC3mavgN);
	DPC3mavgD = DPC3mavgN - DPC3mavgG;
	TDPC3mavgG = mean(TDPC3mavg2, TDPC3mavg3, TDPC3mavg4);
	TDPC3mavgN = TDPC3mavg1;
	TDPC3mavgO = mean(TDPC3mavgG, TDPC3mavgN);
	TDPC3mavgD = TDPC3mavgN - TDPC3mavgG;
	keep subname subnum TDPC3mavgG TDPC3mavgN TDPC3mavgO TDPC3mavgD DPC3mavgG DPC3mavgN DPC3mavgO DPC3mavgD ext_grp_100 ext_pro_100 ext_grp_159 ext_pro_159 pemt nemt cont stai_tot zung_tot;
	if zung_tot=-999|stai_tot=-999 then delete;
run;

proc univariate data = delta_mv normal;
	var TDPC3mavgG TDPC3mavgN TDPC3mavgO TDPC3mavgD DPC3mavgG DPC3mavgN DPC3mavgO DPC3mavgD;
run;

proc corr data = delta_MV pearson plots=matrix;
	var TDPC3mavgO TDPC3mavgN TDPC3mavgG TDPC3mavgD DPC3mavgG DPC3mavgN DPC3mavgO DPC3mavgD;
run;

proc corr data = delta_MV pearson plots=matrix;
	var stai_tot zung_tot TDPC3mavgO TDPC3mavgN TDPC3mavgG TDPC3mavgD;
run;

proc corr data = delta_MV pearson plots=matrix spearman kendall;
	var stai_tot zung_tot DPC3mavgO DPC3mavgN DPC3mavgG DPC3mavgD;
run;

proc sgplot data = delta_MV;
	reg y = TDPC3mavgO x = stai_tot;
run;
proc sgplot data = delta_MV;
	reg y = TDPC3mavgO x = zung_tot;
run;
proc sgplot data = delta_MV;
	reg y =  DPC3mavgO x = stai_tot;
run;
proc sgplot data = delta_MV;
	reg y =  DPC3mavgO x = zung_tot;
run;

proc reg data = delta_MV;
	model TDPC3mavgO = stai_tot zung_tot;
	model TDPC3mavgN = stai_tot zung_tot;
	model  DPC3mavgO = stai_tot zung_tot;
	model  DPC3mavgN = stai_tot zung_tot;
run; quit;


data mylib.st81_gng_avg_delta15_3pc_MV;
	set delta_MV;
run;
