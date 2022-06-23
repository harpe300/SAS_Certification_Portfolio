
/* merge everything */

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\ICPS';

data alltogether;
	merge mylib.st81_GNG_the29_ICPS_ENROI_61_MV mylib.st81_GNG_the29_ICPS_FNROI_61_MV mylib.st81_GNG_the29_ICPS_N2ROI_61_MV;
	by subname;
run;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data mylib.s81_gng_t29_ICPS_ROI_ERNFNN2_mv;
	set alltogether;
run;
