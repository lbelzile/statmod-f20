data newdata;
   set infe.intention(obs=1);
   do fixation=0 to 6;
      output;
   end;
run;

proc glm data=infe.intention noprint;
class sex educ revenue;
model intention= fixation emotion 
    sex age revenue educ / ss3 solution;
store modelinfo; 
run;

proc plm restore=modelinfo; 
score data=newdata out=prediction predicted 
    lclm uclm lcl ucl; 
run;

proc sgplot data=prediction;
band x=fixation upper=ucl lower=lcl / 
        fill transparency=.5 
        legendlabel="individual";
band x=fixation upper=uclm lower=lclm / 
        fill transparency=.1 legendlabel="mean";
series x=fixation y=predicted;
yaxis label="intention score";
xaxis label="fixation time (in seconds)";
run;
