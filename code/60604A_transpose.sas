/* Transform from wide to long format 
https://stats.idre.ucla.edu/sas/modules/how-to-reshape-data-wide-to-long-using-proc-transpose
*/
proc print data=statmod.dental(where=(id LE 5));
run;

proc transpose data=statmod.dental
	out = dental_long(rename=(col1=dist)) /* Rename response */
	name = y;
var y1-y4; /* Variables to stack */
by id gender; /* Variables to keep */
run;

data dental_long;
  set dental_long;
  time=input(substr(y, 2), 1.);
  drop _label_ y;
run; 

data dental;
set statmod.dental;
   dist=y1; age=8;  t=1; output;
   dist=y2; age=10; t=2; output;
   dist=y3; age=12; t=3; output;
   dist=y4; age=14; t=4; output;
   drop y1 y2 y3 y4;
run;


