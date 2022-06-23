
libname mylib 'Z:\Documents\University\Statistics\st0081\gonogo\ERNFNN2\time_course\data';

data all;
	merge mylib.s81_gng_t29_ICPS_ROI_ERNFNN2_mv mylib.s81_gng_t29_ITPS_ROI_ERNFNN2_mv mylib.s81_gng_t29_avg_ROI_ERNFNN2_mv;
	by subname;
run;
title;

title 'Raw FN Association';
proc corr data = all pearson spearman;
	var TITFNFNm61NF T61refFNFNmLPFNF TavgFNFNm61NF;
run;

title 'Raw ERN Association';
proc corr data = all pearson spearman;
	var TITENERNm61E T61refENERNmLPFE TavgENERNm61E;
run;

title 'Raw N2 Association';
proc corr data = all pearson spearman;
	var TITN2N2m61N T61refN2N2mLPFN TavgN2N2m61N;
run;

title 'FN-Post Diff Association';
proc corr data = all pearson spearman;
	var TITFNm61NFdiff T61refFNmLPFNFdiff TavgFNm61NFdiff;
run;

title 'ERN-Post Diff Association';
proc corr data = all pearson spearman;
	var TITENm61Ediff T61refENmLPFEdiff TavgENm61Ediff;
run;

title 'N2-Post Diff Association';
proc corr data = all pearson spearman;
	var TITN2m61diff T61refN2mLPFNdiff TavgN2m61diff;
run;
