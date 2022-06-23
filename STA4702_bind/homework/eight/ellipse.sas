data example;
	merge t41 t45;
	x1trans = x1**(1/4);
	x141trans = x141**(1/4);
run;

/* Program to graph the confidence ellipse for the mean vector */
%let inputdata = example;  /* this line must be edited */
%let var1      = x141trans  ;           /* this line must be edited */
%let var2      = x1trans    ;           /* this line must be edited */
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
  try1 = Evec*Eval*Evec`;
  center = xbar;
  distance = sqrt((n-1)*p*finv(&conf/100, p, n-p) /(n-p));   
  

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
      
