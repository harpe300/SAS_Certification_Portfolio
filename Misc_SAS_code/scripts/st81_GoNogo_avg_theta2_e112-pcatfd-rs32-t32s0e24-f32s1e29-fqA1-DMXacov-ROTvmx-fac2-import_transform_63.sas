PROC IMPORT OUT= WORK.thetaorg 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\N2_EXT\output_data\st81_GoNogo_avg_theta2_e112-pcatfd-rs32-t32s0e24-f32s1e29-fqA1-DMXacov-ROTvmx-fac2.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\N2_EXT\data';

data theta_raw;
	set work.thetaorg;
	if elecname ne 63 then delete;
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
	TPC2m63G = mean(TPC2m632, TPC2m633, TPC2m634);
	TPC2m63N = TPC2m631;
	TPC2m63O = mean(TPC2m63G, TPC2m63N);
	TPC2m63D = TPC2m63N - TPC2m63G;
	if ext_pro_159 = -999 then delete;
	if ext_pro_100 = -999 then delete;
	if nemt = -999 then nemt = .;
	keep subname subnum TPC2m63G TPC2m63N TPC2m63O TPC2m63D ext_grp_100 ext_pro_100 ext_grp_159 ext_pro_159 pemt nemt cont stai_tot zung_tot;
run;

%inc "Z:/Documents/University/Statistics/sas_macros/multnorm.sas";
%multnorm(data = theta_MV, var= TPC2m63G TPC2m63N, plot=mult, hires=yes)

proc univariate data = theta_MV normal;
	var TPC2m63G TPC2m63N ext_pro_159 ext_pro_100;
	histogram / normal;
	ID subname;
run;

proc ttest data = theta_MV;
	paired TPC2m63G*TPC2m63N;
run;		

data temp;
	set theta_MV;
	TPC2m63Gcon = TPC2m63G + 0.03;
	TPC2m63Ncon = TPC2m63N + 0.03;
run;

title ' t-test after constant of 0.03 was added';
proc ttest data = temp;
	paired TPC2m63Gcon*TPC2m63Ncon;
run; title;

data trans;
	set temp;
	z = 0;
run;

proc transreg data = trans details maxiter=0 nozeroconstant;
	model BoxCox(TPC2m63Gcon / convenient alpha=0.05) = identity(z);
run;

proc transreg data = trans details maxiter=0 nozeroconstant;
	model BoxCox(TPC2m63Ncon / convenient alpha=0.05) = identity(z);
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
	TPC2m63Gsqrt = (((TPC2m63Gcon**.25)-1)/.25);
	TPC2m63Glog = log(TPC2m63Gcon);
	TPC2m63Nlog = log(TPC2m63Ncon);
	TPC2m63Olog = mean(TPC2m63Glog, TPC2m63Nlog);
	TPC2m63Dlog = TPC2m63Nlog - TPC2m63Glog;
	ext_pro_159log = log(ext_pro_159);
	ext_pro_100log = log(ext_pro_100);
	ext_pro_100sqrt = (((ext_pro_100**.25)-1)/.25);
run; 

data mylib.st81_gng_63_theta2_2pc_MV;
	set transform;
run;

%inc "Z:/Documents/University/Statistics/sas_macros/multnorm.sas";
%multnorm(data = transform, var= TPC2m63Glog TPC2m63Nlog, plot=mult, hires=yes)

proc univariate data = transform normal;
	var TPC2m63Glog TPC2m63Gsqrt TPC2m63Nlog ext_pro_159log ext_pro_100log ext_pro_100sqrt;
	histogram / normal;
	ID subname;
run;

proc corr data = transform plots = matrix;
	var TPC2m63Glog TPC2m63Nlog TPC2m63Olog TPC2m63Dlog;
	with ext_pro_159log ext_pro_100log ext_pro_100sqrt ext_pro_159 ext_pro_100;
run;

data minusone;
	set transform;
	if subname = 'st0081_s1101' then delete;
	TPC2m63Olog = mean(TPC2m63Glog, TPC2m63Nlog);
	TPC2m63Dlog = TPC2m63Nlog - TPC2m63Glog;
run;


proc univariate data = minusone normal;
	var TPC2m63Glog TPC2m63Gsqrt TPC2m63Nlog ext_pro_159log ext_pro_100log ext_pro_100sqrt;
	histogram / normal;
	ID subname;
run;

proc corr data = minusone plots = matrix;
	var TPC2m63Glog TPC2m63Nlog TPC2m63Olog TPC2m63Dlog;
	with ext_pro_159log ext_pro_100log ext_pro_100sqrt ext_pro_159 ext_pro_100 nemt;
run;

proc sgplot data = minusone;
	reg y = ext_pro_159log x = TPC2m63Nlog;
run;




proc univariate data = transform normal;
	var TPC2m61Glog TPC2m61Nlog TPC2m61Olog TPC2m61Dlog ext_pro_159log ext_pro_100sqrt nemt;
	histogram / normal;
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
