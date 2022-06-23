DATA P1_4;
     INFILE '\\psf\Home\Documents\University\Spring_2012\STA4702\Datasets\P1-4.dat';
	 input x1 x2 x3;
RUN;  

DATA T4_3;
     INFILE '\\psf\Home\Documents\University\Spring_2012\STA4702\Datasets\T4-3.dat';
	 input x1 x2 x3 x4;
RUN;  


/* 4.25 */
proc iml;
use work.P1_4;
read all into a;
at = t(a);
Scov   = cov(a);
Sinv   = inv(Scov);
x_bar  = mean(a);
x_bart = t(x_bar);
diff = at - x_bart;
difft = t(diff);
dist2 = difft*Sinv*diff;
d2 = vecdiag(dist2);
print a at Scov Sinv x_bar x_bart diff difft dist2 d2;
create d2_one from d2;
append from d2;
quit;

proc sort data = d2_one;
	by col1;
run;

data plot;
	set d2_one;
	rename col1 = d2;
	input quantiles;
	datalines;
	0.3518
	0.7978
	1.2125
	1.6416
	2.1095
	2.6430
	3.2831
	4.1083
	5.3170
	7.8147
	;
run;

proc sgplot data=plot;
   scatter y=d2 x=quantiles;
run;

/* 4.25 */

/* sas program for generating data for chi-square q-q plots */
%let inputdata = work.P1_4;  /* this line must be edited */
%let varlist   = x1 x2 x3 ;  /* this line must be edited */
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




/* 4.26 */

proc iml;
at = {1 2 3 4 5 6 7 8 9 11, 18.95 19.00 17.95 15.54 14.00 12.95 8.94 7.49 6.00 3.99};
a = t(at);
Scov   = cov(a);
Sinv   = inv(Scov);
x_bar  = mean(a);
x_bart = t(x_bar);
diff = at - x_bart;
difft = t(diff);
dist2 = difft*Sinv*diff;
d2 = vecdiag(dist2);
  probs = (rank(d2) - j(10,1,.5))/10;   /* contains (r-.5)/n  values */
   quants = quantile('chisquare', probs, 2);
print a at Scov Sinv x_bar x_bart diff difft dist2 d2 probs quants;
create d2_one from d2;
append from d2;
create a26 from a;
append from a;
quit;

proc sort data = d2_one;
	by col1;
run;

data plot;
	set d2_one;
	rename col1 = d2;
	input quantiles;
	datalines;
	0.1025
	0.3250
	0.5753
	0.8615
	1.1956
	1.5970
	2.0996
	2.7725
	3.7942
	5.9914
	;
run;

proc sgplot data=plot;
   scatter y=d2 x=quantiles;
run;


%let inputdata = work.a26;  /* this line must be edited */
%let varlist   = col1 col2;  /* this line must be edited */
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
