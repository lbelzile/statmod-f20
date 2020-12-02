/* Exercise 5.1 */

data renergie;
set statmod.renergie;
marg = ave-min;
run;

/* Spaghetti plot for longitudinal data */
proc sgplot data=renergie;
series x=date y=marg / group=region;
run;

/* Model with no correlation */
proc mixed data=renergie method=reml;
class date region(ref="11");
model marg=region / solution ddfm=satterth;
run;

/* Model with AR(1) correlation */
proc mixed data=renergie method=reml;
class date region(ref="11");
model marg=region / solution ddfm=satterth;
repeated date / subject=region type=ar(1);
run;

/* Model with AR(1) correlation
  Different parameters for each region */
proc mixed data=renergie method=reml;
ods output Mixed.Diffs=diffs;
class date region(ref="11");
model marg= region / solution ddfm=satterth;
repeated date / group=region subject=region type=ar(1);
/* Compute mean difference, but only relative to Gaspé */
lsmeans region / diff=control("11");
run;

/* Adjusted p-values - Stepdown Sidak */
data unadjustpvals;
set diffs;
keep probt;
rename probt=raw_p;
run;
proc multtest inpvalues=unadjustpvals stepsid;
run;



/* Exercise 5.3 */
/* Descriptive statistics */
proc means data=statmod.tolerance(where=(age=11));
var sex exposure;
run;

proc means data=statmod.tolerance;
var tolerance;
run;

proc sgplot data=statmod.tolerance; 
title 'tolerance by sex';
vbox tolerance/ category = sex; 
run;

proc sgplot data=statmod.tolerance; 
title 'tolerance vs. exposure';
scatter y=tolerance x=exposure;
run;

proc sgplot data=statmod.tolerance; 
title 'tolerance vs. age';
vbox tolerance/ category = age;
run;

proc sgplot data=statmod.tolerance; 
title 'Spaghetti plot of tolerance';
series x=age y=tolerance / group=id; 
run;

proc mixed data=statmod.tolerance method=reml;
class id;
model tolerance = sex exposure age / solution;
repeated / subject=id type=cs;	
run;

data tolerance;
set statmod.tolerance;
time = age;
run;

proc mixed data=tolerance method=reml;
class id time;
model tolerance = sex exposure age / solution;
repeated time / subject=id type=ar(1);	
run;

proc mixed data=tolerance method=reml;
class id time;
model tolerance = sex exposure age / solution;
run;

