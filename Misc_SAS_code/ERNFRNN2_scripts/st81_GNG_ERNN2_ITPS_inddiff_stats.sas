
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data';

data ITPS;
	merge mylib.s81_gng_t29_ITPS_ROI_ERNN2_mv mylib.st81_ind_diff;
	by subname;
	if subnum = . then delete;
run;

proc corr data = ITPS pearson spearman;
	var TITENERNm61E TITENm61Ediff;
	with pemt nemt cont ext_pro_100 ext_pro_159 ads_tot bhr_tot bhr_juv bhr_aab sdst_tot smst_tot stai_tot zung_tot tf12_tot ppi_tot;
run;

proc sgplot data = ITPS;
	reg y = TITENm61Ediff x = ext_pro_159 ;
run;

proc sgplot data = ITPS;
	reg y = TITENm61Ediff x = ext_pro_100 ;
run;


proc corr data = ITPS pearson spearman;
	var TITN2N2m61N TITN2m61diff;
	with pemt nemt cont ext_pro_100 ext_pro_159 ads_tot bhr_tot bhr_juv bhr_aab sdst_tot smst_tot stai_tot zung_tot tf12_tot ppi_tot;
run;

proc sgplot data = ITPS;
	reg y = T61refENmLPFEdiff x = ext_pro_159 ;
run;

proc sgplot data = ITPS;
	reg y = T61refENmLPFEdiff x = ext_pro_100 ;
run;


