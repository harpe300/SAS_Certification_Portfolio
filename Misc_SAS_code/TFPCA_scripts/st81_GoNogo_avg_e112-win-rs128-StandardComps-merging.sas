PROC IMPORT OUT= WORK.TDorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_e112-win-rs128-StandardComps.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data TD_raw;
set work.TDorg;
if elecname ne 51 and elecname ne 52 and  elecname ne 53 and elecname ne 61 and elecname ne 62 and elecname ne 63 and elecname ne 77 and elecname ne 78 and elecname ne 79 then delete;
keep subname subnum elecname catcodes p2m p2p n2m n2p p3m p3p;
run;

proc sort data = TD_raw;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = TD_raw out = TD_rawp2m prefix = p2m;
by subname subnum;
id elecname catcodes; 
var p2m;
run;

proc transpose data = TD_raw out = TD_rawn2m prefix = n2m;
by subname subnum;
id elecname catcodes; 
var n2m;
run;

proc transpose data = TD_raw out = TD_rawp3m prefix = p3m;
by subname subnum;
id elecname catcodes; 
var p3m;
run;

proc transpose data = TD_raw out = TD_rawp2p prefix = p2p;
by subname subnum;
id elecname catcodes; 
var p2p;
run;

proc transpose data = TD_raw out = TD_rawn2p prefix = n2p;
by subname subnum;
id elecname catcodes; 
var n2p;
run;

proc transpose data = TD_raw out = TD_rawp3p prefix = p3p;
by subname subnum;
id elecname catcodes; 
var p3p;
run;

/* merge all PCs */
data TD_raw_allwin;
	merge TD_rawp2m TD_rawn2m TD_rawp3m TD_rawp2p TD_rawn2p TD_rawp3p;
	p2mavg1 = mean(p2m511, p2m521, p2m531, p2m611, p2m621, p2m631, p2m771, p2m781, p2m791);
	p2mavg2 = mean(p2m512, p2m522, p2m532, p2m612, p2m622, p2m632, p2m772, p2m782, p2m792);
	p2mavg3 = mean(p2m513, p2m523, p2m533, p2m613, p2m623, p2m633, p2m773, p2m783, p2m793);
	p2mavg4 = mean(p2m514, p2m524, p2m534, p2m614, p2m624, p2m634, p2m774, p2m784, p2m794);
	n2mavg1 = mean(n2m511, n2m521, n2m531, n2m611, n2m621, n2m631, n2m771, n2m781, n2m791);
	n2mavg2 = mean(n2m512, n2m522, n2m532, n2m612, n2m622, n2m632, n2m772, n2m782, n2m792);
	n2mavg3 = mean(n2m513, n2m523, n2m533, n2m613, n2m623, n2m633, n2m773, n2m783, n2m793);
	n2mavg4 = mean(n2m514, n2m524, n2m534, n2m614, n2m624, n2m634, n2m774, n2m784, n2m794);
	p3mavg1 = mean(p3m511, p3m521, p3m531, p3m611, p3m621, p3m631, p3m771, p3m781, p3m791);
	p3mavg2 = mean(p3m512, p3m522, p3m532, p3m612, p3m622, p3m632, p3m772, p3m782, p3m792);
	p3mavg3 = mean(p3m513, p3m523, p3m533, p3m613, p3m623, p3m633, p3m773, p3m783, p3m793);
	p3mavg4 = mean(p3m514, p3m524, p3m534, p3m614, p3m624, p3m634, p3m774, p3m784, p3m794);
	p2pavg1 = mean(p2p511, p2p521, p2p531, p2p611, p2p621, p2p631, p2p771, p2p781, p2p791);
	p2pavg2 = mean(p2p512, p2p522, p2p532, p2p612, p2p622, p2p632, p2p772, p2p782, p2p792);
	p2pavg3 = mean(p2p513, p2p523, p2p533, p2p613, p2p623, p2p633, p2p773, p2p783, p2p793);
	p2pavg4 = mean(p2p514, p2p524, p2p534, p2p614, p2p624, p2p634, p2p774, p2p784, p2p794);
	n2pavg1 = mean(n2p511, n2p521, n2p531, n2p611, n2p621, n2p631, n2p771, n2p781, n2p791);
	n2pavg2 = mean(n2p512, n2p522, n2p532, n2p612, n2p622, n2p632, n2p772, n2p782, n2p792);
	n2pavg3 = mean(n2p513, n2p523, n2p533, n2p613, n2p623, n2p633, n2p773, n2p783, n2p793);
	n2pavg4 = mean(n2p514, n2p524, n2p534, n2p614, n2p624, n2p634, n2p774, n2p784, n2p794);
	p3pavg1 = mean(p3p511, p3p521, p3p531, p3p611, p3p621, p3p631, p3p771, p3p781, p3p791);
	p3pavg2 = mean(p3p512, p3p522, p3p532, p3p612, p3p622, p3p632, p3p772, p3p782, p3p792);
	p3pavg3 = mean(p3p513, p3p523, p3p533, p3p613, p3p623, p3p633, p3p773, p3p783, p3p793);
	p3pavg4 = mean(p3p514, p3p524, p3p534, p3p614, p3p624, p3p634, p3p774, p3p784, p3p794);
run;

/* create average of Go trials */
data TD_MV;
	set TD_raw_allwin;
	p2mavgG = mean(p2mavg2, p2mavg3, p2mavg4);
	n2mavgG = mean(n2mavg2, n2mavg3, n2mavg4);
	p3mavgG = mean(p3mavg2, p3mavg3, p3mavg4);
	p2pavgG = mean(p2pavg2, p2pavg3, p2pavg4);
	n2pavgG = mean(n2pavg2, n2pavg3, n2pavg4);
	p3pavgG = mean(p3pavg2, p3pavg3, p3pavg4);
	p2mavgN = p2mavg1;
	n2mavgN = n2mavg1;
	p3mavgN = p3mavg1;
	p2pavgN = p2pavg1;
	n2pavgN = n2pavg1;
	p3pavgN = p3pavg1;
	keep subname subnum p2mavgG n2mavgG p3mavgG p2mavgN n2mavgN p3mavgN p2pavgG n2pavgG p3pavgG p2pavgN n2pavgN p3pavgN;
run;

data mylib.st81_GNG_avg_uTD_MV;
	set TD_MV;
run;

proc univariate data = TD_MV normal;
	var p2mavgG n2mavgG p3mavgG p2mavgN n2mavgN p3mavgN p2pavgG n2pavgG p3pavgG p2pavgN n2pavgN p3pavgN;
	histogram / normal;
run;

data alltogether;
	merge mylib.st81_GNG_avg_uTD_MV mylib.st81_gng_avg_delta15_3pc_mv mylib.st81_gng_avg_theta15_2pc_mv;
	p2mavgO = mean(p2mavgN, p2mavgG);
	n2mavgO = mean(n2mavgN, n2mavgG);
	p3mavgO = mean(p3mavgN, p3mavgG);
	p2pavgO = mean(p2pavgN, p2pavgG);
	n2pavgO = mean(n2pavgN, n2pavgG);
	p3pavgO = mean(p3pavgN, p3pavgG);
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
run;

data mylib.st81_GNG_filt15_T2_D3_TD_merged;
	set alltogether;
run;
