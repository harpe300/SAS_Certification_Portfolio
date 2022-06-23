
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data GNG;
	set mylib.st81GNG_fAB15_TD_T2D3_uTD_merged;
run;

	/* Descriptives - Overall */
proc univariate data = GNG normal;
	var p2pavgO n2pavgO p3pavgO TPC1mavgO TPC2mavgO DPC1mavgO DPC2mavgO DPC3mavgO Tp2pavgO Tn2pavgO Tp3pavgO Dp2pavgO Dn2pavgO Dp3pavgO DlpcpavgO;
	ID subname;
	histogram / normal;
run;	

	/* Descriptives - N-G Difference */
proc univariate data = GNG normal;
	var p2pavgD n2pavgD p3pavgD TPC1mavgD TPC2mavgD DPC1mavgD DPC2mavgD DPC3mavgD Tp2pavgD Tn2pavgD Tp3pavgD Dp2pavgD Dn2pavgD Dp3pavgD DlpcpavgD;
	ID subname;
	histogram / normal;
run;			

	/* Correlation between Theta, Delta, and TD Overall */
proc corr data = GNG pearson;
	var n2pavgO p3pavgO TPC1mavgO DPC2mavgO Tn2pavgO Tp3pavgO Dn2pavgO DlpcpavgO;
run;

	/* Correlation between Theta, Delta, and TD N-G Difference */
proc corr data = GNG pearson spearman;
	var n2pavgD p3pavgD TPC1mavgD DPC2mavgD Tn2pavgD Tp3pavgD Dn2pavgD DlpcpavgD;
run;

	/* Regression of n2p with theta and delta TF and TD */

title 'Raw n2p = Raw theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgO = TPC1mavgO DPC2mavgO Tn2pavgO Dn2pavgO;
run; quit;

title 'Nogo-Go diff n2p = Nogo-Go diff theta and delta (Full Model)';
proc reg data = GNG;
	model n2pavgD = TPC1mavgD DPC2mavgD Tn2pavgD Dn2pavgD;
run; quit;

	/* Regression of p3p with theta and delta TF and TD */

title 'Raw p3p = Raw theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgO = TPC1mavgO DPC2mavgO Tp3pavgO DlpcpavgO;
run; quit;

title 'Nogo-Go diff p3p = Nogo-Go diff theta and delta (Full Model)';
proc reg data = GNG;
	model p3pavgD = TPC1mavgD DPC2mavgD Tp3pavgD DlpcpavgD;
run; quit;


	/* Regression of n2p with theta and delta TF and TD */

title 'Raw n2p = Raw theta';
proc reg data = GNG;
	model n2pavgO = TPC1mavgO Tn2pavgO;
run; quit;

title 'Nogo-Go diff n2p = Nogo-Go diff theta';
proc reg data = GNG;
	model n2pavgD = TPC1mavgD Tn2pavgD;
run; quit;

title 'Raw n2p = Raw delta';
proc reg data = GNG;
	model n2pavgO = DPC2mavgO Dn2pavgO;
run; quit;

title 'Nogo-Go diff n2p = Nogo-Go diff delta';
proc reg data = GNG;
	model n2pavgD = DPC2mavgD Dn2pavgD;
run; quit;

	/* Regression of p3p with theta and delta TF and TD */

title 'Raw p3p = Raw theta';
proc reg data = GNG;
	model p3pavgO = TPC1mavgO Tp3pavgO;
run; quit;

title 'Nogo-Go diff p3p = Nogo-Go diff theta';
proc reg data = GNG;
	model p3pavgD = TPC1mavgD Tp3pavgD;
run; quit;

title 'Raw p3p = Raw delta';
proc reg data = GNG;
	model p3pavgO = DPC2mavgO DlpcpavgO;
run; quit;

title 'Nogo-Go diff p3p = Nogo-Go diff delta';
proc reg data = GNG;
	model p3pavgD = DPC2mavgD DlpcpavgD;
run; quit;






	/* Regression of n2p with theta and delta - Reduced Model */

title 'Go n2p = Go theta and delta (Reduced Model)';
proc reg data = GNG;
	model n2pavgG = TPC1mavgG DPC2mavgG / dwprob;
run; quit;

title 'Nogo n2p = Nogo theta and delta (Reduced Model)';
proc reg data = GNG;
	model n2pavgN = TPC1mavgN DPC2mavgN / partial dwprob;
run; quit;

title 'Raw n2p = Raw theta and delta (Reduced Model)';
proc reg data = GNG;
	model n2pavgO = TPC1mavgO DPC2mavgO / partial dwprob;
	output out = n2pO_resid r = resid p = predid p = predid;
run; quit;

title 'Nogo-Go diff n2p = Nogo-Go diff theta and delta (Reduced Model)';
proc reg data = GNG;
	model n2pavgD = TPC1mavgD DPC2mavgD / dwprob;
	output out = n2pD_resid r = resid p = predid;
run; quit; title;

	/* n2p Residual Analysis */

title 'n2p reduced model raw residuals';
proc univariate data = n2pO_resid normal;
	var resid;
	ID subname;
	histogram / normal;
run;

title 'n2p reduced model difference residuals';
proc univariate data = n2pD_resid normal;
	var resid;
	ID subname;
	histogram / normal;
run;

data n2pO_resid;
	set n2pO_resid;
	absresid = abs(resid);
run;

data n2pD_resid;
	set n2pD_resid;
	absresid = abs(resid);
run;

title 'n2p reduced model raw - check for constant variance';
proc reg data = n2pO_resid;
	model absresid = predid;
run;

title 'n2p reduced model diff - check for constant variance';
proc reg data = n2pD_resid;
	model absresid = predid;
run;

	/* Regression of p3p with theta and delta - Reduced Model */

title 'Go p3p = Go theta and delta (Reduced Model)';
proc reg data = GNG;
	model p3pavgG = TPC1mavgG DPC2mavgG / dwprob;
run; quit;

title 'Nogo p3p = Nogo theta and delta (Reduced Model)';
proc reg data = GNG;
	model p3pavgN = TPC1mavgN DPC2mavgN / dwprob;
run; quit;

title 'Raw p3p = Raw theta and delta (Reduced Model)';
proc reg data = GNG;
	model p3pavgO = TPC1mavgO DPC2mavgO / dwprob;
	output out = p3pO_resid r = resid p = predid;
run; quit;

title 'Nogo-Go diff p3p = Nogo-Go diff theta and delta (Reduced Model)';
proc reg data = GNG;
	model p3pavgD = TPC1mavgD DPC2mavgD / dwprob;
	output out = p3pD_resid r = resid p = predid;
run; quit;


	/* p3p Residual Analysis */

title 'p3p reduced model raw residuals';
proc univariate data = p3pO_resid normal;
	var resid;
	ID subname;
	histogram / normal;
run;

title 'p3p reduced model raw residuals';
proc univariate data = p3pD_resid normal;
	var resid;
	ID subname;
	histogram / normal;
run;

data p3pO_resid;
	set p3pO_resid;
	absresid = abs(resid);
run;

data p3pD_resid;
	set p3pD_resid;
	absresid = abs(resid);
run;

title 'p3p reduced model raw - check for constant variance';
proc reg data = p3pO_resid;
	model absresid = predid;
run;

title 'p3p reduced model diff - check for constant variance';
proc reg data = p3pD_resid;
	model absresid = predid;
run;
