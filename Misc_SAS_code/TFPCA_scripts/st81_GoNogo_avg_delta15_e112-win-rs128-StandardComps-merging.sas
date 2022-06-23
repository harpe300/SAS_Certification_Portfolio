PROC IMPORT OUT= WORK.TDorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_delta15_e112_BIG-win-rs128-StandardComps.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data TD_raw;
set work.TDorg;
if elecname ne 51 and elecname ne 52 and  elecname ne 53 and elecname ne 61 and elecname ne 62 and elecname ne 63 and elecname ne 77 and elecname ne 78 and elecname ne 79 then delete;
keep subname subnum elecname catcodes p2m p2p n2m n2p p3m p3p lpcm lpcp;
run;

proc sort data = TD_raw;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = TD_raw out = TD_rawp2m prefix = Dp2m;
by subname subnum;
id elecname catcodes; 
var p2m;
run;

proc transpose data = TD_raw out = TD_rawn2m prefix = Dn2m;
by subname subnum;
id elecname catcodes; 
var n2m;
run;

proc transpose data = TD_raw out = TD_rawp3m prefix = Dp3m;
by subname subnum;
id elecname catcodes; 
var p3m;
run;

proc transpose data = TD_raw out = TD_rawlpcm prefix = Dlpcm;
by subname subnum;
id elecname catcodes; 
var lpcm;
run;

proc transpose data = TD_raw out = TD_rawp2p prefix = Dp2p;
by subname subnum;
id elecname catcodes; 
var p2p;
run;

proc transpose data = TD_raw out = TD_rawn2p prefix = Dn2p;
by subname subnum;
id elecname catcodes; 
var n2p;
run;

proc transpose data = TD_raw out = TD_rawp3p prefix = Dp3p;
by subname subnum;
id elecname catcodes; 
var p3p;
run;

proc transpose data = TD_raw out = TD_rawlpcp prefix = Dlpcp;
by subname subnum;
id elecname catcodes; 
var lpcp;
run;

/* merge all PCs */
data TD_raw_allwin;
	merge TD_rawp2m TD_rawn2m TD_rawp3m TD_rawlpcm TD_rawp2p TD_rawn2p TD_rawp3p TD_rawlpcp;
	Dp2mavg1 = mean(Dp2m511, Dp2m521, Dp2m531, Dp2m611, Dp2m621, Dp2m631, Dp2m771, Dp2m781, Dp2m791);
	Dp2mavg2 = mean(Dp2m512, Dp2m522, Dp2m532, Dp2m612, Dp2m622, Dp2m632, Dp2m772, Dp2m782, Dp2m792);
	Dp2mavg3 = mean(Dp2m513, Dp2m523, Dp2m533, Dp2m613, Dp2m623, Dp2m633, Dp2m773, Dp2m783, Dp2m793);
	Dp2mavg4 = mean(Dp2m514, Dp2m524, Dp2m534, Dp2m614, Dp2m624, Dp2m634, Dp2m774, Dp2m784, Dp2m794);
	Dn2mavg1 = mean(Dn2m511, Dn2m521, Dn2m531, Dn2m611, Dn2m621, Dn2m631, Dn2m771, Dn2m781, Dn2m791);
	Dn2mavg2 = mean(Dn2m512, Dn2m522, Dn2m532, Dn2m612, Dn2m622, Dn2m632, Dn2m772, Dn2m782, Dn2m792);
	Dn2mavg3 = mean(Dn2m513, Dn2m523, Dn2m533, Dn2m613, Dn2m623, Dn2m633, Dn2m773, Dn2m783, Dn2m793);
	Dn2mavg4 = mean(Dn2m514, Dn2m524, Dn2m534, Dn2m614, Dn2m624, Dn2m634, Dn2m774, Dn2m784, Dn2m794);
	Dp3mavg1 = mean(Dp3m511, Dp3m521, Dp3m531, Dp3m611, Dp3m621, Dp3m631, Dp3m771, Dp3m781, Dp3m791);
	Dp3mavg2 = mean(Dp3m512, Dp3m522, Dp3m532, Dp3m612, Dp3m622, Dp3m632, Dp3m772, Dp3m782, Dp3m792);
	Dp3mavg3 = mean(Dp3m513, Dp3m523, Dp3m533, Dp3m613, Dp3m623, Dp3m633, Dp3m773, Dp3m783, Dp3m793);
	Dp3mavg4 = mean(Dp3m514, Dp3m524, Dp3m534, Dp3m614, Dp3m624, Dp3m634, Dp3m774, Dp3m784, Dp3m794);
	Dlpcmavg1 = mean(Dlpcm511, Dlpcm521, Dlpcm531, Dlpcm611, Dlpcm621, Dlpcm631, Dlpcm771, Dlpcm781, Dlpcm791);
	Dlpcmavg2 = mean(Dlpcm512, Dlpcm522, Dlpcm532, Dlpcm612, Dlpcm622, Dlpcm632, Dlpcm772, Dlpcm782, Dlpcm792);
	Dlpcmavg3 = mean(Dlpcm513, Dlpcm523, Dlpcm533, Dlpcm613, Dlpcm623, Dlpcm633, Dlpcm773, Dlpcm783, Dlpcm793);
	Dlpcmavg4 = mean(Dlpcm514, Dlpcm524, Dlpcm534, Dlpcm614, Dlpcm624, Dlpcm634, Dlpcm774, Dlpcm784, Dlpcm794);
	Dp2pavg1 = mean(Dp2p511, Dp2p521, Dp2p531, Dp2p611, Dp2p621, Dp2p631, Dp2p771, Dp2p781, Dp2p791);
	Dp2pavg2 = mean(Dp2p512, Dp2p522, Dp2p532, Dp2p612, Dp2p622, Dp2p632, Dp2p772, Dp2p782, Dp2p792);
	Dp2pavg3 = mean(Dp2p513, Dp2p523, Dp2p533, Dp2p613, Dp2p623, Dp2p633, Dp2p773, Dp2p783, Dp2p793);
	Dp2pavg4 = mean(Dp2p514, Dp2p524, Dp2p534, Dp2p614, Dp2p624, Dp2p634, Dp2p774, Dp2p784, Dp2p794);
	Dn2pavg1 = mean(Dn2p511, Dn2p521, Dn2p531, Dn2p611, Dn2p621, Dn2p631, Dn2p771, Dn2p781, Dn2p791);
	Dn2pavg2 = mean(Dn2p512, Dn2p522, Dn2p532, Dn2p612, Dn2p622, Dn2p632, Dn2p772, Dn2p782, Dn2p792);
	Dn2pavg3 = mean(Dn2p513, Dn2p523, Dn2p533, Dn2p613, Dn2p623, Dn2p633, Dn2p773, Dn2p783, Dn2p793);
	Dn2pavg4 = mean(Dn2p514, Dn2p524, Dn2p534, Dn2p614, Dn2p624, Dn2p634, Dn2p774, Dn2p784, Dn2p794);
	Dp3pavg1 = mean(Dp3p511, Dp3p521, Dp3p531, Dp3p611, Dp3p621, Dp3p631, Dp3p771, Dp3p781, Dp3p791);
	Dp3pavg2 = mean(Dp3p512, Dp3p522, Dp3p532, Dp3p612, Dp3p622, Dp3p632, Dp3p772, Dp3p782, Dp3p792);
	Dp3pavg3 = mean(Dp3p513, Dp3p523, Dp3p533, Dp3p613, Dp3p623, Dp3p633, Dp3p773, Dp3p783, Dp3p793);
	Dp3pavg4 = mean(Dp3p514, Dp3p524, Dp3p534, Dp3p614, Dp3p624, Dp3p634, Dp3p774, Dp3p784, Dp3p794);
	Dlpcpavg1 = mean(Dlpcp511, Dlpcp521, Dlpcp531, Dlpcp611, Dlpcp621, Dlpcp631, Dlpcp771, Dlpcp781, Dlpcp791);
	Dlpcpavg2 = mean(Dlpcp512, Dlpcp522, Dlpcp532, Dlpcp612, Dlpcp622, Dlpcp632, Dlpcp772, Dlpcp782, Dlpcp792);
	Dlpcpavg3 = mean(Dlpcp513, Dlpcp523, Dlpcp533, Dlpcp613, Dlpcp623, Dlpcp633, Dlpcp773, Dlpcp783, Dlpcp793);
	Dlpcpavg4 = mean(Dlpcp514, Dlpcp524, Dlpcp534, Dlpcp614, Dlpcp624, Dlpcp634, Dlpcp774, Dlpcp784, Dlpcp794);
run;

/* create average of Go trials */
data TD_MV;
	set TD_raw_allwin;
	Dp2mavgG = mean(Dp2mavg2, Dp2mavg3, Dp2mavg4);
	Dn2mavgG = mean(Dn2mavg2, Dn2mavg3, Dn2mavg4);
	Dp3mavgG = mean(Dp3mavg2, Dp3mavg3, Dp3mavg4);
	DlpcmavgG = mean(Dlpcmavg2, Dlpcmavg3, Dlpcmavg4);
	Dp2pavgG = mean(Dp2pavg2, Dp2pavg3, Dp2pavg4);
	Dn2pavgG = mean(Dn2pavg2, Dn2pavg3, Dn2pavg4);
	Dp3pavgG = mean(Dp3pavg2, Dp3pavg3, Dp3pavg4);
	DlpcpavgG = mean(Dlpcpavg2, Dlpcpavg3, Dlpcpavg4);
	Dp2mavgN = Dp2mavg1;
	Dn2mavgN = Dn2mavg1;
	Dp3mavgN = Dp3mavg1;
	DlpcmavgN = Dlpcmavg1;
	Dp2pavgN = Dp2pavg1;
	Dn2pavgN = Dn2pavg1;
	Dp3pavgN = Dp3pavg1;
	DlpcpavgN = Dlpcpavg1;
	keep subname subnum Dp2mavgG Dn2mavgG Dp3mavgG DlpcmavgG Dp2mavgN Dn2mavgN Dp3mavgN DlpcmavgN Dp2pavgG Dn2pavgG Dp3pavgG DlpcpavgG Dp2pavgN Dn2pavgN Dp3pavgN DlpcpavgN;
run;

data mylib.st81_GNG_avg_delta15_TD_MV;
	set TD_MV;
run;
