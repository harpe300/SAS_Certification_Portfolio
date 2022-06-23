
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\N2_EXT\data';

data theta;
	set mylib.st81_gng_61_theta2_2pc_MV;
run;


proc corr data = theta pearson spearman;
	var EXT_pro_159log EXT_pro_100sqrt nemt EXT_pro_159 EXT_pro_100;
run;

proc corr data = theta pearson spearman plots = matrix;
	var TPC2m61G TPC2m61N TPC2m61O TPC2m61D TPC2m61Glog TPC2m61Nlog TPC2m61Olog TPC2m61Dlog;
run;

proc corr data = theta pearson spearman plots = matrix;
	var TPC2m61G TPC2m61N TPC2m61O TPC2m61D;
	with EXT_pro_159log EXT_pro_100sqrt nemt EXT_pro_159 EXT_pro_100;
run;

proc corr data = theta pearson spearman plots = matrix;
	var TPC2m61Glog TPC2m61Nlog TPC2m61Olog TPC2m61Dlog;
	with EXT_pro_159log EXT_pro_100sqrt nemt EXT_pro_159 EXT_pro_100;
run;

proc reg data = theta;
	model EXT_pro_159log = TPC2m61Glog TPC2m61Nlog;
run; quit;

proc sort data = theta;
	by ext_grp_100;
run;

proc npar1way data = theta wilcoxon correct = no;
	class ext_grp_100;
	var TPC2m61Nlog;
	where ext_grp_100 ne 2;
run;

proc ttest data = theta;
	class ext_grp_100;
	var TPC2m61N;
	where ext_grp_100 ne 2;
run;
