
/* 6.23 */
data t115;
	infile '\\psf\Home\Documents\University\Spring_2012\STA4702\Datasets\T11-5.dat';
	input x1 x2 x3 x4 fac;
run;

/* p = 2, g = 3*/
proc glm data=t115;
	class fac ;
	model x2 x4 = fac /ss3;
	manova h = fac /printe;
	means fac;
run; quit;

proc discrim  data=t115  pool=test wcov pcov;
	class fac;
	var x2 x4;
run;

/* 6.23 */
data t617;
	infile '\\psf\Home\Documents\University\Spring_2012\STA4702\Datasets\T6-17.dat';
	input fac1 fac2 x1 x2 x3;
run;
ods graphics on;
/* p = 2, g = 3*/
proc glm data=t617;
	class fac1 fac2;
	model x1 x2 x3 = fac1 fac2 fac1*fac2 /ss3;
	manova h = fac1 fac2 fac1*fac2 /printe;
	means fac1 fac2 fac1*fac2;
	output out = resid r = resid;
run; quit;

proc discrim  data=t617  pool=test wcov pcov;
	class fac1 fac2;
	var x1 x2 x3;
run;

proc discrim  data=t617  pool=test wcov pcov;
	class fac2;
	var x1 x2 x3;
run;

proc sgplot data = resid;
	scatter y = resid x = fac1;
run;

proc sgplot data = resid;
	scatter y = resid x = fac2;
run;

/* sas program for generating data for chi-square q-q plots */
%let inputdata = work.resid;  /* this line must be edited */
%let varlist   = resid;  /* this line must be edited */
proc iml;
   use &inputdata;  
   read all var { &varlist } into X; 
   n = nrow(X);
   p = ncol(X);
   One = J(n,n,1);           /* just a n x n square matrix full of 1s (nxn)*/
   Xd = X - (One / n)` * X;  /* mean-centered data matrix (nxp)*/
   S = (1 / (n-1)) * Xd`*Xd; /* covariance matrix  (pxp) */
   Sinv = inv(S);
   chisq = j(n,1,0);
     do i = 1 to n;
     chisq[i] = Xd[i,] * Sinv * Xd[i,]`;  /*Distance from obs i to the mean */
     end;
   probs = (rank(chisq) - j(n,1,.5))/n;   /* contains (r-.5)/n  values */
   quants = quantile('chisquare', probs, p);      /* contains chi-square quantiles */
   plotdata = quants||chisq;
   create chisqqdata(rename=(col1=chi_square_quantile col2=distance_squared)) from plotdata;   
   append from plotdata;
   quit;
   data chisqqdata;
      merge chisqqdata &inputdata;
   run;
title "Chi-Square Q-Q Plot using";
title2 "Variables &varlist from &inputdata ";
goptions ftext=SWISS ctext=BLACK htext=1 cells;                                                                                         
axis1 width=1 offset=(3 pct) label=(a=90 r=0);                                                                                          
axis2 width=1 offset=(3 pct);                                                                                                           
symbol1 c=BLUE ci=BLUE v=SQUARE height=1 cells                                                                                          
        interpol=NONE l=1 w=1;   
symbol2 c=BLACK ci=BLUE v=none height=1 cells                                                                                          
        interpol=spline l=1 w=1;                                                                                                        
proc gplot data=Work.Chisqqdata ;                                                                                                       
   plot distance_squared * chi_square_quantile
          chi_square_quantile *  chi_square_quantile / overlay                                                                                                                                                                                                                                 
      description="Scatter Plot of DISTSQ * CHIQUANT"                                                                                   
      caxis = BLACK                                                                                                                     
      ctext = BLACK                                                                                                                     
      cframe = CXF7E1C2                                                                                                                 
      hminor = 0                                                                                                                        
      vminor = 0                                                                                                                        
      vaxis = axis1                                                                                                                     
      haxis = axis2                                                                                                                     
      ;                                                                                                                                 
      run;                                                                                                                              
quit;                                                                                                                                   
goptions ftext= ctext= htext=;                                                                                                          
symbol1; symbol2;                                                                                                                                
axis1; axis2; title; 

