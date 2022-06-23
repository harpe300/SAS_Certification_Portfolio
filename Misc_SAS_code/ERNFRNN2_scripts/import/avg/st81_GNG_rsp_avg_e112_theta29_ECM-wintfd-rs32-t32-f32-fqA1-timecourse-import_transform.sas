PROC IMPORT OUT= WORK.ENtheta61 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\output_data\st81_GNG_rsp_avg_e112_theta29_ECM_RT-wintfd-rs32-t32-f32-fqA1-timecourse.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data';

data ENtheta61UV;
set work.ENtheta61;
keep subname subnum elecname catcodes prem ERNm p3em postm rt rt_plus_1 rt_minus_1;
if elecname ne 61 then delete;
run;

proc contents data = ENtheta61UV;
run;

proc sort data = ENtheta61UV;
by subname subnum elecname catcodes;
run;

/* create MV dataset */
proc transpose data = ENtheta61UV out = ENtheta61MVrawpre prefix = TavgENprem;
by subname subnum;
id elecname catcodes; 
var prem;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawFN prefix = TavgENERNm;
by subname subnum;
id elecname catcodes; 
var ERNm;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawP3 prefix = TavgENp3em;
by subname subnum;
id elecname catcodes; 
var p3em;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawpost prefix = TavgENpostm;
by subname subnum;
id elecname catcodes; 
var postm;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawrt prefix = TavgENrt;
by subname subnum;
id elecname catcodes; 
var rt;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawrtplus1 prefix = TavgENrtplus1;
by subname subnum;
id elecname catcodes; 
var rt_plus_1;
run;

proc transpose data = ENtheta61UV out = ENtheta61MVrawrtminus1 prefix = TavgENrtminus1;
by subname subnum;
id elecname catcodes; 
var rt_minus_1;
run;

data ENtheta61MVraw;
	merge ENtheta61MVrawpre ENtheta61MVrawFN ENtheta61MVrawP3 ENtheta61MVrawpost ENtheta61MVrawrt ENtheta61MVrawrtplus1 ENtheta61MVrawrtminus1;
	rename TavgENrt611 = TavgENrtC TavgENrt612 = TavgENrtE TavgENrtplus1611 = TavgENrtplus1C TavgENrtplus1612 = TavgENrtplus1E TavgENrtminus1611 = TavgENrtminus1C TavgENrtminus1612 = TavgENrtminus1E;	
	drop _name_;
run;

data ENtheta61MV;
	set ENtheta61MVraw;
	TavgENprem61C = TavgENprem611;
	TavgENERNm61C = TavgENERNm611;
	TavgENp3em61C = TavgENp3em611;
	TavgENpostm61C = TavgENpostm611;
	TavgENprem61E = TavgENprem612;
	TavgENERNm61E = TavgENERNm612;
	TavgENp3em61E = TavgENp3em612;
	TavgENpostm61E = TavgENpostm612;
	TavgENm61Ediff = TavgENERNm61E - TavgENpostm61E;
	keep subname subnum TavgENprem61C TavgENERNm61C TavgENp3em61C TavgENpostm61C TavgENprem61E TavgENERNm61E TavgENp3em61E TavgENpostm61E TavgENm61Ediff
	TavgENrtC TavgENrtE TavgENrtplus1C TavgENrtplus1E TavgENrtminus1C TavgENrtminus1E;
run;

/* begin transformation */

%inc "Z:/Documents/University/Statistics/sas_macros/multnorm.sas";
%multnorm(data=ENtheta61MV, var=TavgENERNm61E TavgENpostm61E, plot=mult, hires=yes)

proc univariate data = ENtheta61MV;
	var TavgENERNm61E TavgENpostm61E;
run;

data trans;
	set ENtheta61MV;
	TavgENERNm61E = TavgN2N2m61N + 0.7;
	TavgENpostm61E = TavgN2postm61N + 1.95;
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


data ENtheta61MV;
	set N2theta61MV;
	TavgN2N2m61Ncon = TavgN2N2m61N + 0.7; /* add minimal constant for > 0 */
	TavgN2postm61Ncon = TavgN2postm61N + 1.95;
	TavgN2N2m61Ntrans  = TavgN2N2m61Ncon*.25; /* 4th root transform based on above */
	TavgN2postm61Ntrans = TavgN2postm61Ncon*.25;
	TavgN2m61difftrans = TavgN2N2m61Ntrans - TavgN2postm61Ntrans;
	drop TavgN2N2m61Ncon TavgN2postm61Ncon;
run;




data mylib.st81_GNG_the29_avg_ENROI_61_MV;
	set ENtheta61MV;
run;
