
/* merge everything */

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data\isf';

data alltogether;
	merge mylib.st81_GNG_the29_isf_ENROI_61_MV mylib.st81_GNG_the29_isf_N2ROI_61_MV;
	by subname;
run;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data';

data mylib.s81_gng_t29_isf_ROI_ERNN2_mv;
	set alltogether;
run;
