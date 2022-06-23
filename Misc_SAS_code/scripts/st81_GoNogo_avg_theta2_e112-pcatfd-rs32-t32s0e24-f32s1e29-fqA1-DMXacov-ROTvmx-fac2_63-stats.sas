
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\N2_EXT\data';

data theta;
	set mylib.st81_gng_63_theta2_2pc_MV;
run;


proc corr data = theta pearson spearman;
	var EXT_pro_159log EXT_pro_100log EXT_pro_100sqrt nemt EXT_pro_159 EXT_pro_100;
run;

proc corr data = theta pearson spearman plots = matrix;
	var TPC2m63G TPC2m63N TPC2m63O TPC2m63D TPC2m63Glog TPC2m63Nlog TPC2m63Olog TPC2m63Dlog;
run;

proc corr data = theta pearson spearman plots = matrix;
	var TPC2m63G TPC2m63N TPC2m63O TPC2m63D;
	with EXT_pro_159log EXT_pro_100sqrt EXT_pro_100log nemt EXT_pro_159 EXT_pro_100;
run;

proc corr data = theta pearson spearman plots = matrix;
	var TPC2m63Glog TPC2m63Nlog TPC2m63Olog TPC2m63Dlog;
	with EXT_pro_159log EXT_pro_100sqrt EXT_pro_100log nemt EXT_pro_159 EXT_pro_100;
run;

proc reg data = theta;
	model EXT_pro_159log = TPC2m63Glog TPC2m63Nlog;
run; quit;

proc sort data = theta;
	by ext_grp_100;
run;

proc npar1way data = theta wilcoxon correct = no;
	class ext_grp_100;
	var TPC2m63Nlog;
	where ext_grp_100 ne 2;
run;

proc ttest data = theta;
	class ext_grp_100;
	var TPC2m63N;
	where ext_grp_100 ne 2;
run;
