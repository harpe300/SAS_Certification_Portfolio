
/* merge everything */

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data\avg';

data alltogether;
	merge mylib.st81_GNG_the29_avg_ENROI_61_MV mylib.st81_GNG_the29_avg_N2ROI_61_MV mylib.st81_GNG_the29_avg_FNROI_61_MV;
	by subname;
run;

libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data mylib.s81_gng_t29_avg_ROI_ERNFNN2_mv;
	set alltogether;
run;
