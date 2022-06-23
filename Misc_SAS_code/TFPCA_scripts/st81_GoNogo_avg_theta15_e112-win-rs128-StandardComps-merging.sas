PROC IMPORT OUT= WORK.TDorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\output_data\st81_GoNogo_avg_theta15_e112_BIG-win-rs128-StandardComps.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data TD_raw;
set work.TDorg;
	if elecname ne 52 and elecname ne 53 and elecname ne 61 and elecname ne 62 
		and elecname ne 78 and elecname ne 79 then delete;
keep subname subnum elecname catcodes p2m p2p n2m n2p p3m p3p;
run;

proc sort data = TD_raw;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = TD_raw out = TD_rawp2m prefix = Tp2m;
by subname subnum;
id elecname catcodes; 
var p2m;
run;

proc transpose data = TD_raw out = TD_rawn2m prefix = Tn2m;
by subname subnum;
id elecname catcodes; 
var n2m;
run;

proc transpose data = TD_raw out = TD_rawp3m prefix = Tp3m;
by subname subnum;
id elecname catcodes; 
var p3m;
run;

proc transpose data = TD_raw out = TD_rawp2p prefix = Tp2p;
by subname subnum;
id elecname catcodes; 
var p2p;
run;

proc transpose data = TD_raw out = TD_rawn2p prefix = Tn2p;
by subname subnum;
id elecname catcodes; 
var n2p;
run;

proc transpose data = TD_raw out = TD_rawp3p prefix = Tp3p;
by subname subnum;
id elecname catcodes; 
var p3p;
run;

/* merge all PCs */
data TD_raw_allwin;
	merge TD_rawp2m TD_rawn2m TD_rawp3m TD_rawp2p TD_rawn2p TD_rawp3p;
	Tp2mavg1 = mean(Tp2m611, Tp2m621, Tp2m521, Tp2m531, Tp2m781, Tp2m791);
	Tp2mavg2 = mean(Tp2m612, Tp2m622, Tp2m522, Tp2m532, Tp2m782, Tp2m792);
	Tp2mavg3 = mean(Tp2m613, Tp2m623, Tp2m523, Tp2m533, Tp2m783, Tp2m793);
	Tp2mavg4 = mean(Tp2m614, Tp2m624, Tp2m524, Tp2m534, Tp2m784, Tp2m794);
	Tn2mavg1 = mean(Tn2m611, Tn2m621, Tn2m521, Tn2m531, Tn2m781, Tn2m791);
	Tn2mavg2 = mean(Tn2m612, Tn2m622, Tn2m522, Tn2m532, Tn2m782, Tn2m792);
	Tn2mavg3 = mean(Tn2m613, Tn2m623, Tn2m523, Tn2m533, Tn2m783, Tn2m793);
	Tn2mavg4 = mean(Tn2m614, Tn2m624, Tn2m524, Tn2m534, Tn2m784, Tn2m794);
	Tp3mavg1 = mean(Tp3m611, Tp3m621, Tp3m521, Tp3m531, Tp3m781, Tp3m791);
	Tp3mavg2 = mean(Tp3m612, Tp3m622, Tp3m522, Tp3m532, Tp3m782, Tp3m792);
	Tp3mavg3 = mean(Tp3m613, Tp3m623, Tp3m523, Tp3m533, Tp3m783, Tp3m793);
	Tp3mavg4 = mean(Tp3m614, Tp3m624, Tp3m524, Tp3m534, Tp3m784, Tp3m794);
	Tp2pavg1 = mean(Tp2m611, Tp2m621, Tp2m521, Tp2m531, Tp2m781, Tp2m791);
	Tp2pavg2 = mean(Tp2m612, Tp2m622, Tp2m522, Tp2m532, Tp2m782, Tp2m792);
	Tp2pavg3 = mean(Tp2m613, Tp2m623, Tp2m523, Tp2m533, Tp2m783, Tp2m793);
	Tp2pavg4 = mean(Tp2m614, Tp2m624, Tp2m524, Tp2m534, Tp2m784, Tp2m794);
	Tn2pavg1 = mean(Tn2m611, Tn2m621, Tn2m521, Tn2m531, Tn2m781, Tn2m791);
	Tn2pavg2 = mean(Tn2m612, Tn2m622, Tn2m522, Tn2m532, Tn2m782, Tn2m792);
	Tn2pavg3 = mean(Tn2m613, Tn2m623, Tn2m523, Tn2m533, Tn2m783, Tn2m793);
	Tn2pavg4 = mean(Tn2m614, Tn2m624, Tn2m524, Tn2m534, Tn2m784, Tn2m794);
	Tp3pavg1 = mean(Tp3m611, Tp3m621, Tp3m521, Tp3m531, Tp3m781, Tp3m791);
	Tp3pavg2 = mean(Tp3m612, Tp3m622, Tp3m522, Tp3m532, Tp3m782, Tp3m792);
	Tp3pavg3 = mean(Tp3m613, Tp3m623, Tp3m523, Tp3m533, Tp3m783, Tp3m793);
	Tp3pavg4 = mean(Tp3m614, Tp3m624, Tp3m524, Tp3m534, Tp3m784, Tp3m794);
run;

/* create average of Go trials */
data TD_MV;
	set TD_raw_allwin;
	Tp2mavgG = mean(Tp2mavg2, Tp2mavg3, Tp2mavg4);
	Tn2mavgG = mean(Tn2mavg2, Tn2mavg3, Tn2mavg4);
	Tp3mavgG = mean(Tp3mavg2, Tp3mavg3, Tp3mavg4);
	Tp2pavgG = mean(Tp2pavg2, Tp2pavg3, Tp2pavg4);
	Tn2pavgG = mean(Tn2pavg2, Tn2pavg3, Tn2pavg4);
	Tp3pavgG = mean(Tp3pavg2, Tp3pavg3, Tp3pavg4);
	Tp2mavgN = Tp2mavg1;
	Tn2mavgN = Tn2mavg1;
	Tp3mavgN = Tp3mavg1;
	Tp2pavgN = Tp2pavg1;
	Tn2pavgN = Tn2pavg1;
	Tp3pavgN = Tp3pavg1;
	keep subname subnum Tp2mavgG Tn2mavgG Tp3mavgG Tp2mavgN Tn2mavgN Tp3mavgN Tp2pavgG Tn2pavgG Tp3pavgG Tp2pavgN Tn2pavgN Tp3pavgN;
run;

data mylib.st81_GNG_avg_theta15_TD_MV;
	set TD_MV;
run;

data alltogether;
	merge mylib.st81_GNG_avg_uTD_MV mylib.st81_gng_avg_delta15_3pc_mv mylib.st81_gng_avg_theta15_2pc_mv mylib.st81_GNG_avg_theta15_TD_MV mylib.st81_GNG_avg_delta15_TD_MV;
	p2mavgO = mean(p2mavgN, p2mavgG);
	n2mavgO = mean(n2mavgN, n2mavgG);
	p3mavgO = mean(p3mavgN, p3mavgG);
	p2pavgO = mean(p2pavgN, p2pavgG);
	n2pavgO = mean(n2pavgN, n2pavgG);
	p3pavgO = mean(p3pavgN, p3pavgG);
	Tp2mavgO = mean(Tp2mavgN, Tp2mavgG);
	Tn2mavgO = mean(Tn2mavgN, Tn2mavgG);
	Tp3mavgO = mean(Tp3mavgN, Tp3mavgG);
	Tp2pavgO = mean(Tp2pavgN, Tp2pavgG);
	Tn2pavgO = mean(Tn2pavgN, Tn2pavgG);
	Tp3pavgO = mean(Tp3pavgN, Tp3pavgG);
	Dp2mavgO = mean(Dp2mavgN, Dp2mavgG);
	Dn2mavgO = mean(Dn2mavgN, Dn2mavgG);
	Dp3mavgO = mean(Dp3mavgN, Dp3mavgG);
	DlpcmavgO = mean(DlpcmavgN, DlpcmavgG);
	Dp2pavgO = mean(Dp2pavgN, Dp2pavgG);
	Dn2pavgO = mean(Dn2pavgN, Dn2pavgG);
	Dp3pavgO = mean(Dp3pavgN, Dp3pavgG);
	DlpcpavgO = mean(DlpcpavgN, DlpcpavgG);
	DPC1mavgO = mean(DPC1mavgN, DPC1mavgG);
	DPC2mavgO = mean(DPC2mavgN, DPC2mavgG);
	DPC3mavgO = mean(DPC3mavgN, DPC3mavgG);
	TPC1mavgO = mean(TPC1mavgN, TPC1mavgG);
	TPC2mavgO = mean(TPC2mavgN, TPC2mavgG);
	p2mavgD = p2mavgN - p2mavgG;
	n2mavgD = n2mavgN - n2mavgG;
	p3mavgD = p3mavgN - p3mavgG;
	p2pavgD = p2pavgN - p2pavgG;
	n2pavgD = n2pavgN - n2pavgG;
	p3pavgD = p3pavgN - p3pavgG;
	Tp2mavgD = Tp2mavgN - Tp2mavgG;
	Tn2mavgD = Tn2mavgN - Tn2mavgG;
	Tp3mavgD = Tp3mavgN - Tp3mavgG;
	Tp2pavgD = Tp2pavgN - Tp2pavgG;
	Tn2pavgD = Tn2pavgN - Tn2pavgG;
	Tp3pavgD = Tp3pavgN - Tp3pavgG;
	Dp2mavgD = Dp2mavgN - Dp2mavgG;
	Dn2mavgD = Dn2mavgN - Dn2mavgG;
	Dp3mavgD = Dp3mavgN - Dp3mavgG;
	DlpcmavgD = DlpcmavgN - DlpcmavgG;
	Dp2pavgD = Dp2pavgN - Dp2pavgG;
	Dn2pavgD = Dn2pavgN - Dn2pavgG;
	Dp3pavgD = Dp3pavgN - Dp3pavgG;
	DlpcpavgD = DlpcpavgN - DlpcpavgG;
run;

data mylib.st81GNG_fAB15_TD_T2D3_uTD_merged;
	set alltogether;
run;
