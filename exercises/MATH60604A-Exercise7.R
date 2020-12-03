library(survival)
# Exercise 7.1
data(breastfeeding, package = "hecstatmod")
mod1 <- survfit(Surv(duration, delta) ~ smoke, 
                type="kaplan-meier", 
                conf.type="log", data = breastfeeding)

plot(mod1, col = c(2,4))
# Estimated survival up to 36
mod1$surv[mod1$time == 36]
summary(mod1)
# Mean and median
quantile(mod1, 0.5)$quantile
print(mod1, print.rmean=TRUE)
# Here, restricted mean but both estimators are correct
# because largest observations in each group are 
# observed and not censored times

# Test for equality of survival function
survdiff(Surv(duration, delta) ~ smoke, data = breastfeeding)

mod2 <- coxph(Surv(duration, delta) ~ poverty + agemth + smoke + yschool, 
      data = breastfeeding, ties = "exact")
summary(mod2)

# Exercise 7.2
data(shoes, package = "hecstatmod")
# In R, you give a vector with FALSE=right-censored, TRUE=observed
mod3 <- survfit(Surv(time, status == "0") ~ 1, 
               type="kaplan-meier", 
               conf.type="log", data = shoes)
quantile(mod3)$quantile
plot(mod3)
summary(mod3)

mod4 <- coxph(Surv(time, status == "0") ~ gender + price, data = shoes)
summary(mod4)
  
/* Exercise 7.1 */
  proc lifetest data=statmod.breastfeeding method=km plots=(s(cl));
  time duration*delta(0);
  strata smoke;
  run;
  
  proc phreg data=statmod.breastfeeding;
  model duration*delta(0) =  poverty smoke yschool / ties=exact;
  run;
  
  
  /* Exercise 7.2 */
    proc lifetest data=statmod.shoes method=km plots=(s(cl));
    /* You can have multiple values as right-censored indicators */
      time time*status(1,2);
    /* Exclude the 6807+ lines table */
      ods exclude ProductLimitEstimates;
    run;
    
    proc phreg data=statmod.shoes;
    model time*status(1,2) = gender price / ties=exact;
    run;
    
    /* This code is not related to a question, 
    but shows you how to obtain survival curves
    from the Cox proportional hazard model */
      
      /* Create sets of covariates for which you want the curve */
      data shoes_prof;
    input price gender;
    datalines;
    120 0
    120 1
    ;
    run;
    
    /* Add plots for the profiles in "covariates=shoes_prof"
    save estimated survival in variable s of work.shoes_sp */
      proc phreg data=statmod.shoes plots(overlay)=survival;
    model time*status(1,2)=gender price / ties=exact;
    baseline out=shoes_sp covariates=shoes_prof survival=s; 
    run;
    
    