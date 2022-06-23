
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data GNG;
	set mylib.st81_GNG_filtTF_f3_TD_merged;
run;

proc contents data = GNG;
run;

ods pdf file = 'Z:\Documents\University\st81_GNG_TD_theta_delta_regressions_correlations_ttests_descriptives.pdf' ;

title 'Go p2p = Go theta and delta';
proc reg data = GNG;
	model p2pavgG = TPC1mavgG TPC2mavgG TPC3mavgG / collin vif;
run; quit;

title 'Nogo p2p = Nogo theta and delta';
proc reg data = GNG;
	model p2pavgN = TPC1mavgN TPC2mavgN TPC3mavgN / collin vif;
run; quit;

title 'Raw p2p = Raw theta and delta';
proc reg data = GNG;
	model p2pavgO = TPC1mavgO TPC2mavgO TPC3mavgO / collin vif;
run; quit;

title 'Nogo-Go diff p2p = Nogo-Go diff theta and delta';
proc reg data = GNG;
	model p2pavgD = TPC1mavgD TPC2mavgD TPC3mavgD / collin vif;
run; quit;

/* n2p */

title 'Go n2p = Go theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgG = TPC3mavgG DPC1mavgG DPC2mavgG DPC3mavgG / collin vif;
run; quit;

title 'Nogo n2p = Nogo theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgN = TPC3mavgN DPC1mavgN DPC2mavgN DPC3mavgN / collin vif;
run; quit;

title 'Raw n2p = Raw theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgO = TPC3mavgO DPC1mavgO DPC2mavgO DPC3mavgO / collin vif;
run; quit;

title 'Nogo-Go diff n2p = Nogo-Go diff theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgD = TPC3mavgD DPC1mavgD DPC2mavgD DPC3mavgD / collin vif;
run; quit;


title 'Go n2p = Go theta and delta (Reduced Model)';
proc reg data = GNG;
	model n2pavgG = TPC3mavgG DPC2mavgG / collin vif;
run; quit;

title 'Nogo n2p = Nogo theta and delta (Reduced Model)';
proc reg data = GNG;
	model n2pavgN = TPC3mavgN DPC2mavgN / collin vif;
run; quit;

title 'Raw n2p = Raw theta and delta (Reduced Model)';
proc reg data = GNG;
	model n2pavgO = TPC3mavgO DPC2mavgO / collin vif;
run; quit;

title 'Nogo-Go diff n2p = Nogo-Go diff theta and delta (Reduced Model)';
proc reg data = GNG;
	model n2pavgD = TPC3mavgD DPC2mavgD / collin vif;
run; quit;

/* p3p */

title 'Go p3p = Go theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgG = TPC3mavgG DPC1mavgG DPC2mavgG DPC3mavgG / collin vif;
run; quit;

title 'Nogo p3p = Nogo theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgN = TPC3mavgN DPC1mavgN DPC2mavgN DPC3mavgN / collin vif;
run; quit;

title 'Raw p3p = Raw theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgO = TPC3mavgO DPC1mavgO DPC2mavgO DPC3mavgO / collin vif;
run; quit;

title 'Nogo-Go diff p3p = Nogo-Go diff theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgD = TPC3mavgD DPC1mavgD DPC2mavgD DPC3mavgD / collin vif;
run; quit;

/* correlations */

title 'Raw Theta and Delta correlations';
proc corr data = GNG;
	var TPC3mavgO DPC1mavgO DPC2mavgO DPC3mavgO;
run;

title 'N-G Theta and Delta correlations';
proc corr data = GNG;
	var TPC3mavgD DPC1mavgD DPC2mavgD DPC3mavgD;
run;

title 'Go Theta and Delta correlations';
proc corr data = GNG;
	var TPC3mavgG DPC1mavgG DPC2mavgG DPC3mavgG;
run;

title 'Nogo Theta and Delta correlations';
proc corr data = GNG;
	var TPC3mavgN DPC1mavgN DPC2mavgN DPC3mavgN;
run;

/* Descriptives and Nogo-Go ttest and Wilcoxon Signed-Ranks Test */

title 'Nogo-Go descriptives, t-test, and Wilcoxon Signed-Ranks Test';
proc univariate data = GNG normal;
	var TPC1mavgD TPC2mavgD TPC3mavgD DPC1mavgD DPC2mavgD DPC3mavgD p2pavgD n2pavgD p3pavgD;
	histogram / normal;
run;

ods rtf close;
