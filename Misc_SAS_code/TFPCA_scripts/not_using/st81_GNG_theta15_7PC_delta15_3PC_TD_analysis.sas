
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data GNG;
	set mylib.st81_gng_filt15_t7_d3_td_merged;
run;

	/* Descriptives - Go */
proc univariate data = GNG normal;
	var p2pavgG n2pavgG p3pavgG TPC1mavgG TPC2mavgG TPC3mavgG TPC5mavgG DPC2mavgG;
	histogram / normal;
run;	

	/* Descriptives - Nogo */
proc univariate data = GNG normal;
	var p2pavgN n2pavgN p3pavgN TPC1mavgN TPC2mavgN TPC3mavgN TPC5mavgN DPC2mavgN;
	histogram / normal;
run;	

	/* Descriptives - Overall */
proc univariate data = GNG normal;
	var p2pavgO n2pavgO p3pavgO TPC1mavgO TPC2mavgO TPC3mavgO TPC5mavgO DPC2mavgO;
	histogram / normal;
run;	

	/* Descriptives - N-G Difference */
proc univariate data = GNG normal;
	var p2pavgD n2pavgD p3pavgD TPC1mavgD TPC2mavgD TPC3mavgD TPC5mavgD DPC2mavgD;
	histogram / normal;
run;			

	/* Correlation between Theta, Delta, and TD Go */
proc corr data = GNG pearson spearman;
	var p2pavgG n2pavgG p3pavgG TPC1mavgG TPC2mavgG TPC3mavgG TPC5mavgG DPC2mavgG;
run;

	/* Correlation between Theta, Delta, and TD Nogo */
proc corr data = GNG pearson spearman;
	var p2pavgN n2pavgN p3pavgN TPC1mavgN TPC2mavgN TPC3mavgN TPC5mavgN DPC2mavgN;
run;

	/* Correlation between Theta, Delta, and TD Overall */
proc corr data = GNG pearson spearman;
	var p2pavgO n2pavgO p3pavgO TPC1mavgO TPC2mavgO TPC3mavgO TPC5mavgO DPC2mavgO;
run;

	/* Correlation between Theta, Delta, and TD N-G Difference */
proc corr data = GNG pearson spearman;
	var p2pavgD n2pavgD p3pavgD TPC1mavgD TPC2mavgD TPC3mavgD TPC5mavgD DPC2mavgD;
run;

	/* Regression of n2p with theta and delta */

title 'Go n2p = Go theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgG = DPC2mavgG TPC5mavgG / collin vif;
run; quit;

title 'Nogo n2p = Nogo theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgN = DPC2mavgN TPC5mavgN / collin vif;
run; quit;

title 'Raw n2p = Raw theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgO = DPC2mavgO TPC5mavgO / collin vif;
run; quit;

title 'Nogo-Go diff n2p = Nogo-Go diff theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgD = DPC2mavgD TPC5mavgD / collin vif;
run; quit;


	/* Regression of p3p with theta and delta */

title 'Go p3p = Go theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgG = DPC2mavgG TPC2mavgG TPC3mavgG / collin vif;
run; quit;

title 'Nogo p3p = Nogo theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgN = DPC2mavgN TPC2mavgN TPC3mavgN / collin vif;
run; quit;

title 'Raw p3p = Raw theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgO = DPC2mavgO TPC2mavgO TPC3mavgO / collin vif;
run; quit;

title 'Nogo-Go diff p3p = Nogo-Go diff theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgD = DPC2mavgD TPC2mavgD TPC3mavgD / collin vif;
run; quit;
