PROC IMPORT OUT= WORK.behorg 
            DATAFILE= "\\psf\Home\Documents\University\Statistics\st0081
\gonogo\TF-energy\output_data\sbjtrls_GoNogo_RESP_128_timeV.dat" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data behraw;
	set behorg;
	drop elecnum elecname correct accept var12 tbin T1 response;
	if ttype = 2 then ttype = 1;
	else if ttype = 4 then ttype = 3;
run;

proc sort data = behraw;
	by subname ttype;
run;

proc means data = behraw noprint;
	var acc;
	by subname ttype;
	output out = trlavgacc mean = meanacc sum = Ncorrect;
run;	

data acc;
	set trlavgacc;
	Nincorrect = _freq_ - Ncorrect;
	totaln = _freq_;
	drop _freq_ _type_;
run;

proc sort data = acc;
	by subname ttype;
run;

proc transpose data = acc out = acctrans prefix = meanacc;
	by subname;
	id ttype; 
	var meanacc;
run;

proc transpose data = acc out = ncorrecttrans prefix = Ncorrect;
	by subname;
	id ttype; 
	var Ncorrect;
run;

proc transpose data = acc out = totalntrans prefix = totaln;
	by subname;
	id ttype; 
	var totaln;
run;

proc transpose data = acc out = nincorrecttrans prefix = Nincorrect;
	by subname;
	id ttype; 
	var Nincorrect;
run;

data final;
	merge acctrans totalntrans ncorrecttrans nincorrecttrans;
	by subname;
	drop _name_;
	totalperGocorrect     = Ncorrect1   / (totaln1 + totaln3);
	totalperNogocorrect   = Ncorrect3   / (totaln1 + totaln3);
	totalperGoincorrect   = Nincorrect1 / (totaln1 + totaln3);
	totalperNogoincorrect = Nincorrect3 / (totaln1 + totaln3);
	correctedGocorrect    = Ncorrect1 / 3;
	correctedGoincorrect  = Nincorrect1 / 3;
	verify = totalperGocorrect + totalperNogocorrect + totalperGoincorrect + totalperNogoincorrect;
run;	

proc print data = final;
	var subname totalperGocorrect totalperNogocorrect totalperGoincorrect totalperNogoincorrect Ncorrect1 Ncorrect3 Nincorrect1 Nincorrect3 totaln1 totaln3 correctedGocorrect correctedGoincorrect meanacc1 meanacc3;
run;

proc univariate data = final;
	var totalperGocorrect totalperNogocorrect totalperGoincorrect totalperNogoincorrect meanacc1 meanacc3;
run;

proc univariate data = final;
	var Ncorrect1 Ncorrect3 Nincorrect1 Nincorrect3;
run;

proc ttest data = final;
	paired correctedGocorrect*Ncorrect3;
run;

proc ttest data = final;
	paired meanacc1*meanacc3;
run;

proc ttest data = final;
	paired correctedGoincorrect*Nincorrect3;
run;

/* RT analysis */

proc sort data = behraw;
	by subname ttype acc;
run;

proc means data = behraw noprint;
	var rt;
	by subname ttype acc;
	output out = trlavgrt mean = meanrt;
run;	

proc transpose data = trlavgrt out = trlavgrttrans prefix = meanrt;
	by subname;
	id ttype acc; 
	var meanrt;
run;

proc univariate data = trlavgrttrans;
	var meanrt10 meanrt11 meanrt30 meanrt31;
run;

proc ttest data = trlavgrttrans;
	paired meanrt11*meanrt30;
run;
