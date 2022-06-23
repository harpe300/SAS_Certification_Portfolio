
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data ICPS;
	merge mylib.s81_gng_t29_ICPS_ROI_ERNFNN2_mv mylib.st81_ind_diff;
	by subname;
	if subnum = . then delete;
run;

proc corr data = ICPS pearson spearman;
	var T61refENERNmLPFE T61refENmLPFEdiff;
	with pemt nemt cont ext_pro_100 ext_pro_159 ads_tot bhr_tot bhr_juv bhr_aab sdst_tot smst_tot stai_tot zung_tot tf12_tot ppi_tot;
run;

proc sgplot data = ICPS;
	reg y = T61refENmLPFEdiff x = ext_pro_159 ;
run;

proc sgplot data = ICPS;
	reg y = T61refENmLPFEdiff x = ext_pro_100 ;
run;


proc corr data = ICPS pearson spearman;
	var T61refN2N2mLPFN T61refN2mLPFNdiff;
	with pemt nemt cont ext_pro_100 ext_pro_159 ads_tot bhr_tot bhr_juv bhr_aab sdst_tot smst_tot stai_tot zung_tot tf12_tot ppi_tot;
run;

proc sgplot data = ICPS;
	reg y = T61refENmLPFEdiff x = ext_pro_159 ;
run;

proc sgplot data = ICPS;
	reg y = T61refENmLPFEdiff x = ext_pro_100 ;
run;


