PROC IMPORT OUT= WORK.thetaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\N2_EXT\output_data\st81_GoNogo_avg_theta2_e112-pcatfd-rs32-t32s0e24-f32s1e29-fqA1-DMXacov-ROTvmx-fac2.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\N2_EXT\data';

data theta_raw;
	set work.thetaorg;
	if elecname ne 61 then delete;
	keep subname subnum elecname catcodes PC2m ext_grp_100 ext_pro_100 ext_grp_159 ext_pro_159 pemt nemt cont stai_tot zung_tot;
run;

data ind_diff;
	set work.thetaorg;
	if elecname ne 63 then delete;
	if catcodes ne 1 then delete;
	keep subname subnum ext_grp_100 ext_pro_100 ext_grp_159 ext_pro_159 pemt nemt cont stai_tot zung_tot;
run;

proc sort data = theta_raw;
	by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = theta_raw out = theta_rawPC2m prefix = TPC2m;
	by subname subnum;
	id elecname catcodes; 
	var PC2m;
run;

/* create average of Go trials */
data theta_MV;
	merge theta_rawPC2m ind_diff;
        by subname;
	TPC2m61G = mean(TPC2m612, TPC2m613, TPC2m614);
	TPC2m61N = TPC2m611;
	TPC2m61O = mean(TPC2m61G, TPC2m61N);
	TPC2m61D = TPC2m61N - TPC2m61G;
	if ext_pro_159 = -999 then delete;
	if ext_pro_100 = -999 then delete;
	if nemt = -999 then nemt = .;
	keep subname subnum TPC2m61G TPC2m61N TPC2m61O TPC2m61D ext_grp_100 ext_pro_100 ext_grp_159 ext_pro_159 pemt nemt cont stai_tot zung_tot;
run;

%inc "Z:/Documents/University/Statistics/sas_macros/multnorm.sas";
%multnorm(data = theta_MV, var= TPC2m61G TPC2m61N, plot=mult, hires=yes)

proc univariate data = theta_MV normal;
	var TPC2m61G TPC2m61N TPC2m61O TPC2m61D ext_pro_159 ext_pro_100;
	histogram / normal;
run;

proc ttest data = theta_MV;
	paired TPC2m61G*TPC2m61N;
run;		

data temp;
	set theta_MV;
	TPC2m61Gcon = TPC2m61G + 0.016;
	TPC2m61Ncon = TPC2m61N + 0.016;
run;

title ' t-test after constant of 0.016 was added';
proc ttest data = temp;
	paired TPC2m61Gcon*TPC2m61Ncon;
run; title;

data trans;
	set temp;
	z = 0;
run;

proc transreg data = trans details maxiter=0 nozeroconstant;
	model BoxCox(TPC2m61Gcon / convenient alpha=0.05) = identity(z);
run;

proc transreg data = trans details maxiter=0 nozeroconstant;
	model BoxCox(TPC2m61Ncon / convenient alpha=0.05) = identity(z);
run;

proc transreg data = trans details maxiter=0 nozeroconstant;
	model BoxCox(ext_pro_159 / convenient alpha=0.05) = identity(z);
run;

proc transreg data = trans details maxiter=0 nozeroconstant;
	model BoxCox(ext_pro_100 / convenient alpha=0.05) = identity(z);
run;

proc transreg data = trans details maxiter=0 nozeroconstant;
	model BoxCox(nemt / convenient alpha=0.05) = identity(z);
run;

data transform;
	set temp;
	TPC2m61Glog = log(TPC2m61Gcon);
	TPC2m61Nlog = log(TPC2m61Ncon);
	TPC2m61Olog = mean(TPC2m61Glog, TPC2m61Nlog);
	TPC2m61Dlog = TPC2m61Nlog - TPC2m61Glog;
	ext_pro_159log = log(ext_pro_159);
	ext_pro_100sqrt = (((ext_pro_100**.25)-1)/.25);
run; 

proc univariate data = transform normal;
	var TPC2m61Glog TPC2m61Nlog TPC2m61Olog TPC2m61Dlog ext_pro_159log ext_pro_100sqrt nemt;
	histogram / normal;
run;

data mylib.st81_gng_61_theta2_2pc_MV;
	set transform;
run;

data theta_MV;
	set mylib.st81_gng_61_theta2_6pc_MV;
	if ext_pro_159 = -999 then delete;
run;

proc corr data = theta_MV pearson spearman;
	var TPC3m61N TPC5m61N EXT_pro_159 EXT_pro_100;
run;

proc corr data = theta_MV pearson spearman;
	var TPC3m61G TPC5m61G EXT_pro_159 EXT_pro_100;
run;

data onethree;
	set theta_mv;
	if ext_grp_100 = 2 then delete;
run;

proc sort data = onethree;
	by ext_grp_100;
run;

proc npar1way data = onethree wilcoxon correct = no;
	class ext_grp_100;
	var TPC3m61N;
run;

proc ttest data = onethree;
	class ext_grp_100;
	var TPC3m61N;
run;

proc npar1way data = onethree wilcoxon correct = no;
	class ext_grp_100;
	var TPC5m61N;
run;

proc ttest data = onethree;
	class ext_grp_100;
	var TPC5m61N;
run;



proc npar1way data = onethree wilcoxon correct = no;
	class ext_grp_100;
	var TPC3m61G;
run;

proc ttest data = onethree;
	class ext_grp_100;
	var TPC3m61G;
run;

proc npar1way data = onethree wilcoxon correct = no;
	class ext_grp_100;
	var TPC5m61G;
run;

proc ttest data = onethree;
	class ext_grp_100;
	var TPC5m61G;
run;
