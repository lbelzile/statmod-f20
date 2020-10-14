proc genmod data=statmod.sweden;
class year(ref="1961") day;
model death = limit year day / dist=poisson link=log lrci type3;
run;

proc genmod data=statmod.birthwgt;
class premature race smoker hypertension irrit;
model low(ref="0")= premature race smoker hypertension 
			irrit wgtmother / dist=binomial link=logit lrci type3;
run;

proc logistic data=statmod.birthwgt;
class premature race smoker hypertension irrit / param=glm;
model low(ref="0")= premature race smoker hypertension 
			irrit wgtmother / expb plrl;
run;

