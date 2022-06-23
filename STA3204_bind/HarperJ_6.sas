/* J.Harper Assignment Six */

/* J.Harper Problem One */
/* 1a */

data bodyfat;
set work.bodyfat;
run;

proc corr data = bodyfat;
var _fat age weight height chest abdomen hip thigh;
run;
/*proc corr creates the correlation matrix for the specified variables */

/* 1bcde */

proc reg data = bodyfat;
Forward_Method:  model _fat = age weight height chest abdomen hip thigh/ selection = forward;
Backward_Method: model _fat = age weight height chest abdomen hip thigh/ selection = backward;
Stepwise_Method: model _fat = age weight height chest abdomen hip thigh/ selection = stepwise;
All_Method:      model _fat = age weight height chest abdomen hip thigh/ selection = rsquare;
run;
/* proc reg performs a regression on the speficied variables, and the selection option allows
one to choose what kind of method to use to try and fit a model to %fat (such as forward and
stepwise */

/* 2a */

proc import out= WORK.angrytype 
            datafile= "C:\Users\jbh08c\Documents\My SAS Files\9.2\AngryT
ype.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="AngryType$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
run;

data angrytype;
set work.angrytype;
run;

proc freq data = angrytype;
tables emotionkind*severity;
run;
/* proc freq creates a cross-tabulation of emotionkind and severity using the tables statement */

/* J.Harper Problem Two */
/* 2b */

proc freq data = angrytype;
tables emotionkind*severity / chisq;
run;
/* the chi square option performs a chi square test for independence on the two variables */
