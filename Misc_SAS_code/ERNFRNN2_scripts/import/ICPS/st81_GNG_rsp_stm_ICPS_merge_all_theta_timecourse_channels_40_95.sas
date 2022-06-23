
/* merge everything */

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data\ICPS\channels_40_95';

data alltogether;
	merge mylib.st81_GNG_t29_ICPS_ENROI_61LP_MV mylib.st81_GNG_t29_ICPS_N2ROI_61LP_MV mylib.st81_GNG_t29_ICPS_FNROI_61LP_MV;
	by subname;
run;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2_RT\data';

data mylib.s81_gng_t29_ICPS_ROI_ERNN2FNLPmv;
	set alltogether;
run;
