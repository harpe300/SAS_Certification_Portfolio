DATA T1_6;
     INFILE '\\psf\Home\Documents\University\Spring_2012\STA4702\Datasets\T1-6.dat';
	 input x1 x2 x3 x4 x5 group;
RUN;  

/* One 14b */

title 'Jeremy Harper - Problem One (14b)';
proc corr data = T1_6 cov;
	var x1 x2 x3 x4 x5;
	by group;
run;

/* Two 15b */

DATA T1_7;
     INFILE '\\psf\Home\Documents\University\Spring_2012\STA4702\Datasets\T1-7.dat';
	 input x1 x2 x3 x4 x5 x6;
RUN;  

title 'Jeremy Harper - Problem Two (15b)';
proc corr data = T1_7 cov;
	var x1 x2 x3 x4 x5 x6;
run;

/* proc iml is not neeed */

proc iml;
use work.T1_6;
read all into mat;
print mat;
/* split by group first */
mean = mean(mat);
cov = cov(mat);
corr = corr(mat);
print mean cov corr;
quit;

