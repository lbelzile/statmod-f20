/* Table 7.3 from Agresti's Introduction to Categorical Data Analysis
Survey conducted by the Wright State University School of
Medicine and the United Health Services in Dayton, Ohio. 
The survey asked students in their final year of a high
school near Dayton, Ohio whether they had ever used alcohol,
cigarettes, or marijuana.
*/
data drug;
input alc $ cig $ mar $ count;
cards;
yes yes yes 911
yes yes no 538
yes no yes 44
yes no no 456
no yes yes 3
no yes no 43
no no yes 2
no no no 279
;
run;

proc genmod data=drug;
class alc cig mar;
model count = alc cig mar alc|cig alc|mar cig|mar / dist=poisson link=log type3;
store model_output;
run;
/* Prediction, just exp(betahat*x) */
proc plm restore=model_output;
score data=drug out=preds pred=pred / ilink;
run;


/* Measures to deal with AIDS */
data aids;
input gender $ info $ opinion $ count;
cards;
male support support 76
male support oppose 160
male oppose support 6
male oppose oppose 25
female support support 114
female support oppose 181
female oppose support 11
female oppose oppose 48
;
run;

proc genmod data=aids;
class gender info opinion;
model count = gender info opinion gender*info gender*opinion opinion*info / dist=poisson link=log type3;
run;

/* Format so that data is suitable for binomial regression */
data aids2;
input gender $ info $ support oppose;
cards;
male support 76 160
male oppose 6 25
female support 114 181
female oppose 11 48
;
run;
data aids2;
set aids2;
total = support + oppose;
run;
/* Binomial data - relative to the poisson model, we lose some parameters because we condition on the sum */
proc genmod data=aids2;
class gender info ;
model support/total = gender info / dist=binom link=logit type3;
run;

