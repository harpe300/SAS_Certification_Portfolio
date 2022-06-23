

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data avg;
	merge mylib.s81_gng_t29_avg_ROI_ERNFNN2_mv mylib.st81_ind_diff;
	by subname;
	if subnum = . then delete;
run;

proc corr data = avg pearson spearman;
	var TavgENERNm61E TavgENm61Ediff;
	with pemt nemt cont ext_pro_100 ext_pro_159 ads_tot bhr_tot bhr_juv bhr_aab sdst_tot smst_tot stai_tot zung_tot tf12_tot ppi_tot;
run;

proc sgplot data = avg;
	reg y = TavgENm61Ediff x = ext_pro_159 ;
run;

proc sgplot data = avg;
	reg y = TavgENm61Ediff x = ext_pro_100 ;
run;


proc corr data = avg pearson spearman;
	var TavgN2N2m61N TavgN2m61diff;
	with pemt nemt cont ext_pro_100 ext_pro_159 ads_tot bhr_tot bhr_juv bhr_aab sdst_tot smst_tot stai_tot zung_tot tf12_tot ppi_tot;
run;

proc sgplot data = avg;
	reg y = T61refENmLPFEdiff x = ext_pro_159 ;
run;

proc sgplot data = avg;
	reg y = T61refENmLPFEdiff x = ext_pro_100 ;
run;


