/* 6.1a */

data t61;
  infile "\\psf\Home\Documents\University\Spring_2012\STA4702\Datasets\T6-1.dat";
  input x1 x2 x3 x4;
  boddiff = x1-x3;
  SSdiff  = x2-x4;
run;

title '95% Confidence Elipse for the (SSdiff, BODdiff) Mean Vector';
proc sgscatter data = T61;
	compare y = boddiff x = SSdiff / ellipse = (type=mean);
run; title '';

/* Program to graph the confidence ellipse for the mean vector */
%let inputdata = T61;  /* this line must be edited */
%let var1      = SSdiff  ;           /* this line must be edited */
%let var2      = boddiff    ;           /* this line must be edited */
%let conf      = 95    ;           /* Confidence level desired*/
proc corr data=&inputdata noprint nocorr cov outp=covout(type=cov);
    var &var1 &var2;          
run; 
data covonly;
   set covout;
   if _type_='COV';
   keep &var1 &var2;
run;
data meanonly;
   set covout;
   if _type_='MEAN';
   keep &var1 &var2;
run;
data nonly;
   set covout;
   if _type_='N';
   keep &var1 &var2;
run;
proc iml;
   use covonly;
   read all into S;
   p = ncol(S);
   use meanonly;
   read all into xbar;
   xbar = xbar`;
   use nonly;
   read all into n;  n=n[1,1];
  A = S/n;                
  Evec = Eigvec(A);
  Eval = diag(Eigval(A));
  EvecS = Eigvec(S);
  EvalS = diag(Eigval(S));
  try1 = Evec*Eval*Evec`;
  center = xbar;
  F = finv(&conf/100, p, n-p);
  one = (p*(n-1));
  two = (n*(n-p));
  diff = ((p*(n-1))/(n*(n-p)))*F;
  diffT = sqrt(((p*(n-1))/(n-p))*finv(&conf/100, p, n-p));
  ss = sqrt(diag(S)/n);
  distances = sqrt(diag(EvalS))*sqrt(((p*(n-1))/(n*(n-p)))*finv(&conf/100, p, n-p));
  distance = sqrt((n-1)*p*finv(&conf/100, p, n-p) /(n-p)); 
  T2distminus   = xbar - sqrt(((p*(n-1))/(n-p))*finv(&conf/100, p, n-p))*sqrt(diag(S)/n);
  T2distplus   = xbar + sqrt(((p*(n-1))/(n-p))*finv(&conf/100, p, n-p))*sqrt(diag(S)/n);
  print xbar distance distances center EvecS EvalS F one two diff diffT S T2distminus T2distplus ss; 
  

npoints = 1000;
free xbig;
do r = 1 to npoints;
    angle = 2*3.14159265 * (r/npoints); 
    w1 = sin(angle);
    w2 = cos(angle);
    w = w1//w2;
    x = Evec*sqrt(Eval)*distance*w + center;  
    xbig = xbig//x`;
end;
create plotdata from xbig;
append from xbig;
quit;
goptions ftext=SWISS ctext=BLACK htext=1 cells;                                                                                         
axis1 width=1 offset=(3 pct) label=(a=90 r=0) ;                                                                                          
axis2 width=1 offset=(3 pct) ;                                                                                                           
symbol1 c=BLUE ci=BLUE v=none height=1 cells                                                                                            
        interpol=spline l=1 w=1;                                                                                                        
proc gplot data=Work.Plotdata(rename=(Col1=&var1 Col2=&var2)) ;    
   title "&conf% Confidence Ellipse for the (&var1, &var2) Mean Vector"; 
   plot &var2 * &var1  /                                                                                                                                                                                                                                                                                                                            
      caxis = BLACK                                                                                                                     
      ctext = BLACK                                                                                                                     
      cframe = CXF7E1C2 
      href=0   
      vref=0                                                                                                                  
      hminor = 0                                                                                                                 
      vminor = 0                                                                                                                        
      vaxis = axis1                                                                                                                     
      haxis = axis2                                                                                                                     
      ;                                                                                                                                 
      run;                                                                                                                              
quit;                                                                                                                                   
goptions ftext= ctext= htext=;                                                                                                          
symbol1;                                                                                                                                
axis1; axis2;      
title;

/* 6.6a */

proc iml;
	y1 = {3 3, 1 6, 2 3};
	y2 = {2 3, 5 1, 3 1, 2 3};
	x1 = mean(y1);
	x2 = mean(y2);
	n1 = nrow(y1);
	n2 = nrow(y2);
	s1 = cov(y1);
	s2 = cov(y2);
	spool = (((n1-1)/(n1+n2-2))*s1) + (((n2-1)/(n1+n2-2))*s2);
	print y1 y2 x1 x2 s1 s2 n1 n2 spool; quit;
run;

/* 6.6b */

proc iml;
	y1 = {3 3, 1 6, 2 3};
	y2 = {2 3, 5 1, 3 1, 2 3};
	x1t = mean(y1);
	x2t = mean(y2);
	x1 = (x1t)`;
	x2 = (x2t)`;
	n1 = nrow(y1);
	n2 = nrow(y2);
	s1 = cov(y1);
	s2 = cov(y2);
	spool = (((n1-1)/(n1+n2-2))*s1) + (((n2-1)/(n1+n2-2))*s2);
	t2 = (x1-x2)`*inv(((1/n1)+(1/n2))*spool)*(x1-x2);
	print spool t2; quit;
run;

/* 6.6c */
