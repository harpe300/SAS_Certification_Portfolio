
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data';

data ISF;
	merge mylib.s81_gng_t29_ISF_ROI_ERNN2_mv mylib.st81_ind_diff;
	by subname;
	if subnum = . then delete;
run;

proc corr data = ISF pearson spearman;
	var TTPENERNm61E TTPENm61Ediff;
	with pemt nemt cont ext_pro_100 ext_pro_159 ads_tot bhr_tot bhr_juv bhr_aab sdst_tot smst_tot stai_tot zung_tot tf12_tot ppi_tot;
run;

proc sgplot data = ISF;
	reg y = TTPENm61Ediff x = ext_pro_159 ;
run;

proc sgplot data = ISF;
	reg y = TTPENm61Ediff x = ext_pro_100 ;
run;


proc corr data = ISF pearson spearman;
	var TTPN2N2m61N TTPN2m61Ndiff;
	with pemt nemt cont ext_pro_100 ext_pro_159 ads_tot bhr_tot bhr_juv bhr_aab sdst_tot smst_tot stai_tot zung_tot tf12_tot ppi_tot;
run;

proc sgplot data = ISF;
	reg y = T61refENmLPFEdiff x = ext_pro_159 ;
run;

proc sgplot data = ISF;
	reg y = T61refENmLPFEdiff x = ext_pro_100 ;
run;


