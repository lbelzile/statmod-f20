
/* Exercise 6.2 */
/* Model 1 */

proc mixed data=statmod.gsce;
class center;
model result = coursework sex / solution;
repeated / subject=center type=cs;
run;

/* Model 2 */
proc mixed data=statmod.gsce;
class center;
model result = coursework sex center / solution;
run;

/* Model 3 */
proc mixed data=statmod.gsce;
class center;
model result = coursework sex / solution;
random intercept / subject=center solution;
run;

