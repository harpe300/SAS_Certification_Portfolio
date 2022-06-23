PROC IMPORT OUT= WORK.theta_ITPS 
            DATAFILE= "Z:\Documents\University\Statistics\st0081\reward_
context\final\output_data\st81_Gambling_ISFtrl2avg_e112_theta3_ITPS-pcat
fd-rs32-t32s0e24-f32s1e29-fqA0-DMXacov-ROTvmx-fac3.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname mylib 'Z:\Documents\University\Statistics\st0081\reward_context\final\data\';


data theta3_ITPS_raw;
set work.theta_ITPS;
if elecname ne 52 and elecname ne 53 and elecname ne 54 and elecname ne 60 and elecname ne 61 and elecname ne 62 
   and elecname ne 78 and elecname ne 79 and elecname ne 80 then delete;
if reward = 'H' then delete;
if reward = 'G' then reward = '1';
	else if reward = 'E' then reward = '2';
	else if reward = 'L' then reward = '3';
if acc = 0 then acc = 2;
keep subname subnum elecname reward acc PC1m;
run;


proc sort data = theta3_ITPS_raw;
by subname subnum elecname reward acc;
run;

proc transpose data = theta3_ITPS_raw out = theta3_ITPS_temp prefix = TITPSPC1m;
by subname subnum;
id elecname reward acc; 
var PC1m;
run;


/* compute frontal cluster */
data theta3_ITPS_avg;
	set work.theta3_ITPS_temp;
	TITPSPC1mavgG0 = mean(TITPSPC1m6012, TITPSPC1m6112, TITPSPC1m6212, TITPSPC1m5212, TITPSPC1m5312, TITPSPC1m5412, TITPSPC1m7812, TITPSPC1m7912, TITPSPC1m8012);
	TITPSPC1mavgG1 = mean(TITPSPC1m6011, TITPSPC1m6111, TITPSPC1m6211, TITPSPC1m5211, TITPSPC1m5311, TITPSPC1m5411, TITPSPC1m7811, TITPSPC1m7911, TITPSPC1m8011);
	TITPSPC1mavgE0 = mean(TITPSPC1m6022, TITPSPC1m6122, TITPSPC1m6222, TITPSPC1m5222, TITPSPC1m5322, TITPSPC1m5422, TITPSPC1m7822, TITPSPC1m7922, TITPSPC1m8022);
	TITPSPC1mavgE1 = mean(TITPSPC1m6021, TITPSPC1m6121, TITPSPC1m6221, TITPSPC1m5221, TITPSPC1m5321, TITPSPC1m5421, TITPSPC1m7821, TITPSPC1m7921, TITPSPC1m8021);
	TITPSPC1mavgL0 = mean(TITPSPC1m6032, TITPSPC1m6132, TITPSPC1m6232, TITPSPC1m5232, TITPSPC1m5332, TITPSPC1m5432, TITPSPC1m7832, TITPSPC1m7932, TITPSPC1m8032);
	TITPSPC1mavgL1 = mean(TITPSPC1m6031, TITPSPC1m6131, TITPSPC1m6231, TITPSPC1m5231, TITPSPC1m5331, TITPSPC1m5431, TITPSPC1m7831, TITPSPC1m7931, TITPSPC1m8031);
run;


/* compute variables for overall and good-bad diffferences */
data theta3_ITPS_MV;
	set theta3_ITPS_avg;
	TITPSPC1mavgraw = mean(TITPSPC1mavgE0, TITPSPC1mavgE1, TITPSPC1mavgL0, TITPSPC1mavgL1, TITPSPC1mavgG0, TITPSPC1mavgG1); 
	TITPSPC1mavgraw_goodO = mean(TITPSPC1mavgE1, TITPSPC1mavgL1, TITPSPC1mavgG1); 
	TITPSPC1mavgraw_badO = mean(TITPSPC1mavgE0, TITPSPC1mavgL0, TITPSPC1mavgG0); 
	TITPSPC1mavgraw_GO = mean(TITPSPC1mavgG0, TITPSPC1mavgG1);
	TITPSPC1mavgraw_EO = mean(TITPSPC1mavgE0, TITPSPC1mavgE1);
	TITPSPC1mavgraw_LO = mean(TITPSPC1mavgL0, TITPSPC1mavgL1);
	TITPSPC1mavg_DO = TITPSPC1mavgraw_goodO - TITPSPC1mavgraw_badO;
	TITPSPC1mavg_DG = TITPSPC1mavgG1 - TITPSPC1mavgG0;
	TITPSPC1mavg_DE = TITPSPC1mavgE1 - TITPSPC1mavgE0;
	TITPSPC1mavg_DL = TITPSPC1mavgL1 - TITPSPC1mavgL0;
run;

data mylib.st81_RC_theta3_ITPSavg_MV;
	set theta3_ITPS_MV;
run;


proc sort data = theta3_ITPS_raw;
by subname subnum reward acc;
run;

proc transpose data = theta3_ITPS_raw out = theta3_ITPS_tempUV prefix = TITPSPC1m;
by subname subnum reward acc;
id elecname; 
var PC1m;
run;

data theta3_ITPS_UV_avg;
	set theta3_ITPS_tempUV;
	TITPSPC1mavg = MEAN(TITPSPC1m60, TITPSPC1m61, TITPSPC1m62, TITPSPC1m52, TITPSPC1m53, TITPSPC1m54, TITPSPC1m78, TITPSPC1m79, TITPSPC1m80);
run;

data mylib.st81_RC_delta4_ITPSavg_UV;
	set delta4_ITPS_UV_avg;
run;


ods pdf file='st81_Gambling_theta3_ITPS_MANOVA_ttest.pdf';

ods graphics on;

proc glm data = theta3_ITPS_MV;	
	model TITPSPC1mavgG0 TITPSPC1mavgG1 TITPSPC1mavgE0 TITPSPC1mavgE1 TITPSPC1mavgL0 TITPSPC1mavgL1 = / nouni;	
	repeated reward 3, acc 2 / mean printe;
run; quit;


/*MANOVA Approach */
proc mixed data = theta3_ITPS_UV_avg;
	class reward acc;
	model TITPSPC1mavg = reward|acc / ddfm = kr;
	repeated / subject = subnum type = un ;
run; quit;

/* creates least squares means dataset for plotting */
ods output lsmeans=work._lsmeans;                                                                                                           

ods listing close; 
proc mixed data = theta3_ITPS_UV_avg;
	class reward acc;
	model TITPSPC1mavg = reward|acc / ddfm = kr outpred=pred;
	repeated / subject = subnum type = un;
    lsmeans reward acc reward*acc;
run; quit;
ods listing;

/* Plot TITPSPC1m by reward and acc */

ods graphics on;

proc sgplot data=_lsmeans ;                                                                                                             
   where upcase(effect) = "ACC";                                                                                            
   label estimate = "TITPSPC1mavg";
   series y = estimate x = acc / markers markerattrs=(symbol=circle) lineattrs=(pattern=solid) ;  
   xaxis integer values = (1 to 2 by 1) label = "Good/Bad";
   yaxis label = "Power";
   run;                                                                                                                                 
quit;

proc sgplot data=_lsmeans ;                                                                                                             
   where upcase(effect) = "REWARD";                                                                                            
   label estimate = "TITPSPC1mavg";
   series y = estimate x = reward / markers markerattrs=(symbol=circle) lineattrs=(pattern=solid) ;  
   xaxis integer values = (1 to 3 by 1) label = "Gain/Even/Loss";
   yaxis label = "Power";
   run;                                                                                                                                 
quit;

** Two-way effect plots  **;                                                                                                                                                                                         

proc sgplot data=_lsmeans ;                                                                                                             
   where upcase(effect) = "REWARD*ACC";                                                                                            
   label estimate = "TITPSPC1mavg";
   series y = estimate x = reward /group = acc markers markerattrs=(symbol=circle) lineattrs=(pattern=solid) ;  
   xaxis integer values = (1 to 3 by 1) label = "Gain/Even/Loss";
   yaxis label = "Power";
      keylegend  / location=inside across=1 position=topright title= 'Good/Bad'; 
   run;                                                                                                                                 
quit;                                                                                                                                   
goptions reset=all device=WIN; 


proc ttest data = theta3_ITPS_MV;
	paired TITPSPC1mavgG1*TITPSPC1mavgG0 
		   TITPSPC1mavgE1*TITPSPC1mavgE0
		   TITPSPC1mavgL1*TITPSPC1mavgL0;
run;

proc glm data = theta3_ITPS_MV;	
	model TITPSPC1mavgG1 TITPSPC1mavgE1 TITPSPC1mavgL1 = / nouni;	
	repeated reward 3/ mean printe;
run; quit;

proc glm data = theta3_ITPS_MV;	
	model TITPSPC1mavgG0 TITPSPC1mavgE0 TITPSPC1mavgL0 = / nouni;	
	repeated reward 3/ mean printe;
run; quit;

ods pdf close;
