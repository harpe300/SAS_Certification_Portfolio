PROC IMPORT OUT= WORK.avgRTorg
            DATAFILE= "Z:\Documents\University\Statistics\st0081\gonogo\
TF-energy\output_data\st81_GoNogo_avg_theta15_e112_BIG-pcatfd-rs64-t64s0e48-f128s1e57-fqA1-DMXacov-ROTvmx-fac2.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\TF-energy\data';

data avgRT_raw;
set work.avgRTorg;
	if elecname ne 52 then delete;
keep subname subnum rt catcodes;
run;

proc sort data = avgRT_raw;
by subname subnum catcodes;
run;

proc transpose data = avgRT_raw out = avgRT_struc prefix = RT;
by subname subnum;
id catcodes; 
var rt;
run;

/* merge all PCs */
data avgRT_mv;
	set avgRT_struc;
	RTavgG = mean(RT2, RT3, RT4);
	RTavgN = RT1;
	RTavgD = RTavgN - RTavgG;
	drop _name_;
run;

proc univariate data = avgRT_mv normal;
	var RTavgG;
	histogram / normal;
run;

proc univariate data = avgRT_mv normal;
	var RTavg2 RTavg3 RTavg4;
	histogram / normal;
run;

proc glm data = avgRT_mv;	
	model RT2 RT3 RT4 = / nouni;	
	repeated GO 3 / mean;
run; quit;
