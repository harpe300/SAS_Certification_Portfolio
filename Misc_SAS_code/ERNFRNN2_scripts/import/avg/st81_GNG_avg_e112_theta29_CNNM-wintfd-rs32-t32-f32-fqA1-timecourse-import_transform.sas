PROC IMPORT OUT= WORK.N2theta61
	DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\output_data\st81_GNG_avg_e112_theta29_CNNM_RT-wintfd-rs32-t32-f32-fqA1-timecourse.dat"
		DBMS=TAB REPLACE;     
	GETNAMES=YES;
	DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data';

data N2theta61UV;
	set work.N2theta61;
	keep subname subnum elecname catcodes prem N2m p3m postm rt rt_plus_1 rt_minus_1;
	if elecname ne 61 then delete;
run;

proc contents data = N2theta61UV;
run;

proc sort data = N2theta61UV;
	by subname subnum elecname catcodes;
run;

/* create MV dataset */

proc transpose data = N2theta61UV out = N2theta61MVrawpre prefix = TavgN2prem;
	by subname subnum;
	id elecname catcodes; 
	var prem;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawFN prefix = TavgN2N2m;
	by subname subnum;
	id elecname catcodes; 
	var N2m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawP3 prefix = TavgN2P3m;
	by subname subnum;
	id elecname catcodes; 
	var P3m;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawpost prefix = TavgN2postm;
	by subname subnum;
	id elecname catcodes; 
	var postm;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrt prefix = TavgN2rt;
	by subname subnum;
	id elecname catcodes; 
	var rt;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrtplus1 prefix = TavgN2rtplus1;
	by subname subnum;
	id elecname catcodes; 
	var rt_plus_1;
run;

proc transpose data = N2theta61UV out = N2theta61MVrawrtminus1 prefix = TavgN2rtminus1;
	by subname subnum;
	id elecname catcodes; 
	var rt_minus_1;
run;

data N2theta61MVraw;	
	merge N2theta61MVrawpre N2theta61MVrawFN N2theta61MVrawP3 N2theta61MVrawpost N2theta61MVrawrt N2theta61MVrawrtplus1 N2theta61MVrawrtminus1;	
	rename TavgN2rt611 = TavgN2rtN TavgN2rt612 = TavgN2rtG TavgN2rtplus1611 = TavgN2rtplus1N TavgN2rtplus1612 = TavgN2rtplus1G TavgN2rtminus1611 = TavgN2rtminus1N TavgN2rtminus1612 = TavgN2rtminus1G ;	
	drop _name_;
run;

data N2theta61MV;	
	set N2theta61MVraw;	
	TavgN2prem61N = TavgN2prem611;	
	TavgN2N2m61N = TavgN2N2m611;	
	TavgN2P3m61N = TavgN2P3m611;	
	TavgN2postm61N = TavgN2postm611;	
	TavgN2prem61G = TavgN2prem612;	
	TavgN2N2m61G = TavgN2N2m612;	
	TavgN2P3m61G = TavgN2P3m612;	
	TavgN2postm61G = TavgN2postm612;	
	TavgN2m61diff = TavgN2N2m61N - TavgN2postm61N;	
	keep subname subnum TavgN2prem61N TavgN2N2m61N TavgN2P3m61N TavgN2postm61N TavgN2prem61G TavgN2N2m61G TavgN2P3m61G TavgN2postm61G TavgN2m61diff 	
	TavgN2rtN TavgN2rtG TavgN2rtplus1N TavgN2rtplus1G TavgN2rtminus1N TavgN2rtminus1G;
run;

/* begin transformation */

%inc "Z:/Documents/University/Statistics/sas_macros/multnorm.sas";
%multnorm(data=N2theta61MV, var=TavgN2N2m61N TavgN2postm61N, plot=mult, hires=yes)

proc univariate data = N2theta61MV;
	var TavgN2N2m61N TavgN2postm61N;
run;

data trans;
	set N2theta61MV;
	TavgN2N2m61Ncon = TavgN2N2m61N + 0.7;
	TavgN2postm61Ncon = TavgN2postm61N + 1.95;
	z = 0;
run;

proc transreg data=trans details maxiter=0 nozeroconstant;
	model BoxCox(TavgN2N2m61Ncon / convenient alpha=0.05) = identity(z);
    output out= boxcoxN2;
run;

proc transreg data=trans details maxiter=0 nozeroconstant;
	model BoxCox(TavgN2postm61Ncon / convenient alpha=0.05) = identity(z);
    output out= boxcoxpost;
run;

data boxcox;
	merge boxcoxpost boxcoxN2;
	TavgN2postm61Ncontr = TavgN2postm61Ncon**.25;
	diff = TTavgN2N2m61Ncon - TavgN2postm61Ncontr;
	by _name_;
	drop _name_ _type_;
run;

proc univariate data = boxcox normal;
	var diff TTavgN2N2m61Ncon TTavgN2postm61Ncon TavgN2postm61Ncontr;
	histogram / normal;
run;

%multnorm(data=boxcox, var=diff, plot=mult, hires=yes)

/* end transformation */


data N2theta61MVtrans;
	set N2theta61MV;
	TavgN2N2m61Ncon = TavgN2N2m61N + 0.7; /* add minimal constant for > 0 */
	TavgN2postm61Ncon = TavgN2postm61N + 1.95;
	TavgN2N2m61Ntrans  = TavgN2N2m61Ncon*.25; /* 4th root transform based on above */
	TavgN2postm61Ntrans = TavgN2postm61Ncon*.25;
	TavgN2m61difftrans = TavgN2N2m61Ntrans - TavgN2postm61Ntrans;
	drop TavgN2N2m61Ncon TavgN2postm61Ncon;
run;

data mylib.st81GNG_th29_avg_N2ROI_61_MV_tr;	
	set N2theta61MVtrans;
run;
