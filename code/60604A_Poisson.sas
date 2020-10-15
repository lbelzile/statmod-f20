proc genmod data=statmod.sweden;
class year(ref="1961") day;
model death = limit year day / dist=poisson link=log lrci type3;
run;

