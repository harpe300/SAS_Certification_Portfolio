/* J.Harper Assignment 5 */

/* 1a */

proc format; /* this function applies labels to the different values */
value class_new 2=sophmore 3=junior 4=senior; 
run;

data grades;
infile 'R:\data\public\jharper\SAS\assignment_data\Grades.txt';
input ID $ 
      gender $ 
      class 
      quiz 
      exam_one 
      exam_two 
      lab_grade 
      final;
	  quiz = quiz/50;
	  exam_one = exam_one/100;
	  exam_two = exam_two/100;
	  lab_grade = lab_grade/100;
	  final = final/200;
	  avg = mean(quiz, exam_one, exam_two, lab_grade);
format class class_new.; /* assigns the format to the dataset */
run;

proc print data = grades;
run;

/* 1b */

proc sgscatter data = grades; 
matrix quiz exam_one exam_two lab_grade final /
diagonal = (histogram kernal);
run;
/* this function produces multiple scatter plots for the 
four variables and displays a histogram and smoothing function 
in the diagonal portion of the plots */

/* 1d */

data grades_one;
set grades;
	if class ^=2; /* the if statement excludes sophomores from the dataset */
format class class_new.;
run;

proc sgpanel data = grades_one;
panelby class gender;
scatter y = final x = avg;
loess y = final x = avg / CLM CLMTRANSPARENCY = .6;
run;
/* this function produces a panel display of scatter plots by gender and class with
grade on the final as a function of total average. a loess smooth was applied and made
semi-transparent */

/* 2a */
proc ttest data = _exp0_.diabetes h0=70 alpha=.05 sides=u;
var pulse;
run;

/* this function excecutes a t-test to see if the average heart rate is over 70 */

/* 2b */

data twob;
set _exp0_.diabetes;
Gluc = 'FastGluc';
score = FastGluc;
output;
Gluc = 'PostGluc';
score = PostGluc;
output;
run;
/* in order to excecute the two-sample t-test, variables for different
Glucose ratings and scores had to be created */

proc ttest data = twob;
class Gluc;
var score;
run;
/* this function is a two-sample t-test comparing the two categories of Glucose */

/* 2c */

proc ttest data = _exp0_.diabetes;
paired FastGluc*PostGluc;
run;
/* this function excecutes a paired t-test of PostGluc scores against FastGluc */

/* 3a */

proc anova data = _exp0_.diameter;
class machine;
model diameter = machine;
run;
quit;
/* this function is an anova test comparing the mean diameter size of each machine
group against eachother. the class function assigns the categories to be compared */

/* 3b */

proc anova data = _exp0_.diameter;
class machine;
model diameter = machine;
means machine / tukey lines;
run;
quit;
/* the tukey lines statement allows one to parse out which groups differ
siginificantly */

/* 3c */

proc anova data = _exp0_.diameter;
class operator;
model diameter = operator;
run;
quit;

/* 3d */

proc anova data = _exp0_.diameter;
class operator;
model diameter = operator;
means operator / tukey cldiff;
run;
quit;
/* the tukey cldiff statement works like the tukey lines statement, but presents
the output differently */ 
