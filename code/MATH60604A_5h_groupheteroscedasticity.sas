
 /* Group heteroscedasticity */
proc mixed data=statmod.college plots=studentpanel;
class field rank sex;
model salary = sex field rank;
repeated / group = rank;
run;


/* Other examples with ANOVA models 
(i.e., linear reg with one or two categorical variables. 
We could estimate a different variance in each group/sub-group */
proc mixed data=statmod.servqual;
class bank;
model reliability=bank / ddfm=satterth;
repeated / group=bank;
lsmeans bank / pdiff;
run; 

/* Two-way anova with interaction */
proc mixed data=statmod.delay;
class stage delay;
model time=stage|delay / ddfm=satterth; 
repeated / group=stage * delay;
lsmeans stage*delay / pdiff; 
/* Compute all pairwise difference 
(Welch t-tests with Satterthwaite approximation
 for DOF of the Student dist) */
run;
