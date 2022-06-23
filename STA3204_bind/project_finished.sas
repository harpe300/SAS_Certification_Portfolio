PROC IMPORT OUT= WORK.project 
            DATAFILE= "R:\data\public\jharper\SAS\project\project.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="'Sheet 1 - Table 1 - Table 1$'"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

/* finalized work */

data projecta;
set work.project;
if DX = 1 and sex = 1 then DX_sex = 'M-';
if DX = 1 and sex = 2 then DX_sex = 'F-';
if DX = 2 and sex = 1 then DX_sex = 'M+';
if DX = 2 and sex = 2 then DX_sex = 'F+';
run;

proc contents data = projecta;
run;

	/* descriptives of each variable */

title 'Frequency of Diagnosis, Sex, and Diagnosis/Sex for the Sample';
proc freq data = projecta;
tables DX sex DX_sex;
run;

proc sort data = projecta;
by DX;
run;

title 'Descriptive Statistics of all Variables by Diagnosis Alone';
proc means data = projecta;
var FS_IQ TBV GMV WMV CSF L_superior_frontal_gyrus R_superior_frontal_gyrus L_hippocampus R_hippocampus;
by DX;
run;

proc sort data = projecta;
by DX_sex;
run;

title 'Descriptive Statistics of all Variables by Diagnosis and Sex';
proc means data = projecta;
var FS_IQ TBV GMV WMV CSF L_superior_frontal_gyrus R_superior_frontal_gyrus L_hippocampus R_hippocampus;
by DX_sex;
run;

	/* Statistical Graphs */

title 'Pie Chart of Sample Distribution';
proc gchart data = projecta;
pie DX_sex / discrete value = inside
			 percent = inside slice = outside;
run;

title 'Boxplot of Total Brain Volume by Diagnosis and Sex';
proc boxplot data = projecta;
plot TBV*DX_sex;
run;

title 'Boxplot of Cerebrospinal Fluid Volume by Diagnosis and Sex';
proc boxplot data = projecta;
plot CSF*DX_sex;
run;

title 'Boxplot of IQ by Diagnosis and Sex';
proc boxplot data = projecta;
plot FS_IQ*DX_sex;
run;

title 'Histogram of IQ';
proc sgplot data = projecta;
histogram FS_IQ;
density FS_IQ;
density FS_IQ / type = kernel; 
run;

title 'Histogram of IQ by Diagnosis and Sex';
proc sgplot data = projecta;
histogram FS_IQ;
density FS_IQ;
density FS_IQ / type = kernel;
by DX_sex; 
run;

title 'Scatter Diagram of IQ by Diagnosis and Sex';
proc gplot data = projecta;
plot FS_IQ*DX_sex;
run; quit;

title 'Scatter Martix of IQ Total Brain Volume and Grey Matter Volume';
proc sgscatter data = projecta;
matrix FS_IQ TBV GMV DX sex;
run;

title 'Scatter Martix of IQ and White Matter Volume and Cerebrospinal Fluid Volume';
proc sgscatter data = projecta;
matrix FS_IQ WMV CSF DX sex;
run;

title 'Scatter Martix of IQ and Frontal Gyri Measurements';
proc sgscatter data = projecta;
matrix FS_IQ L_superior_frontal_gyrus R_superior_frontal_gyrus DX sex;
run;

title 'Scatter Martix of IQ and Hippocampal Measurements';
proc sgscatter data = projecta;
matrix FS_IQ L_hippocampus R_hippocampus DX sex;
run;

	/* Correlations */

proc sort data = projecta;
by DX_sex;
run;

title 'Correlations of all Variables by Diagnosis and Sex';
proc corr data = projecta;
var FS_IQ TBV GMV WMV CSF L_superior_frontal_gyrus R_superior_frontal_gyrus L_hippocampus R_hippocampus;
by DX_sex;
run;
	
	/* Statiscical Analyses */

proc sort data = projecta;
by DX;
run;

title 'T-Test of IQ by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var FS_IQ;
class DX;
run;

title 'T-Test of Total Brain Volume by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var TBV;
class DX;
run;

title 'T-Test of Grey Matter Volume by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var GMV;
class DX;
run;

title 'T-Test of White Matter Volume by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var WMV;
class DX;
run;

title 'T-Test of Left Frontal Gyrus Measurement by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var L_superior_frontal_gyrus;
class DX;
run;

title 'T-Test of Right Frontal Gyrus Measurement by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var R_superior_frontal_gyrus;
class DX;
run;

title 'T-Test of Left Hippocampal Measurement by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var L_hippocampus;
class DX;
run;

title 'T-Test of Right Hippocampal Measurement by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var R_hippocampus;
class DX;
run;

title 'T-Test of Cerebrospinal Fluid Volume by Diagnosis';
proc ttest data = projecta alpha = 0.05;
var CSF;
class DX;
run;

	/* ANOVA by DX and Sex to see if there are any differences that do not come out in the Diagnosis-only comparison */

title 'ANOVA of IQ by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model FS_IQ=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

title 'ANOVA of Total Brain Volume by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model TBV=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

title 'ANOVA of Grey Matter Volume by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model GMV=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

title 'ANOVA of White Matter Volume by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model WMV=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

title 'ANOVA of Cerebrospinal Fluid Volume by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model CSF=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

title 'ANOVA of Left Frontal Gyrus Measurement by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model L_superior_frontal_gyrus=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

title 'ANOVA of Right Frontal Gyrus Measurement by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model R_superior_frontal_gyrus=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

title 'ANOVA of Left Hippocampal Measurement by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model L_hippocampus=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

title 'ANOVA of Right Hippocampal Measurement by Diagnosis and Sex';
proc ANOVA data = projecta;
class DX_sex;
model R_hippocampus=DX_sex;
means DX_Sex / tukey lines cldiff;
run; quit;

	/* Chi-Square Test */

title 'Chi-Square Test of IQ by Diagnosis and Sex';
proc freq data = projecta;
weight FS_IQ;
tables DX_sex / chisq;
run;	

	/* Regressions */

proc sort data = projecta;
by DX;
run;

title 'Regression Analysis of IQ and Total Brain Volume by Diagnosis';
proc reg data = projecta;
model FS_IQ=TBV;
by DX;
run; quit; /* the model works for schizophrenia, but not the no-diagnosis group */

proc sort data = projecta;
by DX;
run;

title 'Modeling IQ using Stepwise and R-Square Methods by Diagnosis Alone';
proc reg data = projecta;
Stepwise_model: model FS_IQ = TBV GMV WMV CSF L_superior_frontal_gyrus R_superior_frontal_gyrus R_hippocampus L_hippocampus / selection = stepwise;
All_Method: model FS_IQ = TBV GMV WMV CSF L_superior_frontal_gyrus R_superior_frontal_gyrus R_hippocampus L_hippocampus / selection = rsquare best = 3;
by DX;
run; quit; 

proc sort data = projecta;
by DX_sex;
run;

title 'Modeling IQ using Stepwise and R-Square Methods by Diagnosis and Sex';
proc reg data = projecta;
Stepwise_model: model FS_IQ = TBV GMV WMV CSF L_superior_frontal_gyrus R_superior_frontal_gyrus R_hippocampus L_hippocampus / selection = stepwise;
All_Method: model FS_IQ = TBV GMV WMV CSF L_superior_frontal_gyrus R_superior_frontal_gyrus R_hippocampus L_hippocampus / selection = rsquare best = 3;
by DX_sex;
run; quit;

/* finalized work */
