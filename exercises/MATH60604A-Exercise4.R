library(ggplot2)
library(patchwork)

###############################
#######  Exercise 4.1  ########
###############################

data(profsalary, package = "hecstatmod")
profsalary$salbi <- profsalary$salary > 105000
mod1p1 <- glm(salbi ~ degree + sex + yr + yd, 
            data = profsalary, 
            family=binomial(link="logit"))
summary(mod1p1)
mod1p2 <- glm(salbi ~ degree + sex + yr + yd + factor(rank), 
            data = profsalary, 
            family=binomial(link="logit"))

library(ggplot2)
ggplot(data.frame(pred = fitted(mod1p2), 
                  rank = profsalary$rank),
       aes(x = rank, y = pred)) +
  geom_boxplot() + 
  labs(x = "academic rank", 
       y = "fitted probability")


###############################
#######  Exercise 4.2  ########
###############################

data(awards, package = "hecstatmod")
mod2p1 <- glm(nawards ~ prog + math, data = awards, family=poisson(link="log"))
mod2p2 <- MASS::glm.nb(nawards ~ prog + math, data = awards, link='log')
#Testing for overdispersion - don't use deviance, as these are not comparable
pchisq(2*as.numeric(logLik(mod2p2) - logLik(mod2p1)), 
       df = 1, lower.tail = FALSE)/2
# Reject null that k=0
khat <- 1/mod2p2$theta
#Checking adequacy - LRT comparing with saturated model
deviance(mod2p1) / mod2p1$df.residual
#df residuals not taking into account the k parameter
pchisq(deviance(mod2p1), df = mod2p1$df.residual, lower.tail = FALSE)
summary(mod2p1)
# Pearson chi-square statistic for Poisson model
PearsonX2 <- sum(residuals(mod2p1, type = "pearson")^2)
# sum((awards$nawards - fitted(mod2p1))^2/fitted(mod2p1))

###############################
#######  Exercise 4.3  ########
###############################
data(ceb, package = "hecstatmod")
# par(mfrow= c(1,2),mar = c(4,4,1,1), bty = "l", pch = 20)
# with(ceb, plot(log(nwom), log(nceb), 
#                xlab = "number of women per group (log)",
#                ylab = "number of children ever born (log)"))
# with(ceb, plot(nceb/nwom, var, 
#                xlab = "mean number of children ever born",
#                ylab = "variance of number of children"))


g1 <- ggplot(data = ceb, 
             aes(x = log(nwom), y =log(nceb))) +
  geom_point() +
  labs(x="number of women per group (log)",
       y ="number of children ever born (log)")
g2 <- ggplot(data = ceb, 
             aes(x = nceb/nwom, y =var)) +
  geom_point() +
  labs(x = "mean number of children ever born",
       y = "variance of number of children")
g1 + g2

mod3p1 <- glm(nceb ~ dur + res + educ + offset(log(nwom)), data = ceb, family = poisson)

mod3p2 <- glm(nceb ~ dur + res + educ + log(nwom), data = ceb, family = poisson)

# Coefficients
summary(mod3p1)
# Profile likelihood confidence intervals for betas
confint(mod3p1)
# Type 3 LRT for covariates
car::Anova(mod3p1, type = 3)
# Diagnostic plots for residuals
boot::glm.diag.plots(mod3p1)
# LRT test for deviance - versus saturated model
pchisq(deviance(mod3p1), df = mod3p1$df.residual, lower.tail = FALSE)
mod3p3 <- glm(nceb ~ dur * educ + res  + offset(log(nwom)), data = ceb, family = poisson)
anova(mod3p1, mod3p3, test = "LRT")

###############################
#######  Exercise 4.4  ########
###############################
data(bixi, package = "hecstatmod")

mod4p1 <- glm(nusers ~ weekend, data = bixi, family = poisson(link="log")) 
mod4p2 <- glm(nusers ~ weekend + temp + relhumid, data = bixi, family = poisson(link="log")) 
anova(mod4p1, mod4p2)

mod4p3 <- MASS::glm.nb(nusers ~ weekend + temp + relhumid, data = bixi)
# Overdispersion
# Likelihood ratio test: compare neg. binom (Ha) versus Poisson (H0)
# Null distribution is 0.5 chi-square(1). This means we proceed as usual, but halve the p-value
pchisq(q = as.numeric(2*(logLik(mod4p3) - logLik(mod4p2))), df = 1, lower.tail = FALSE)/2
# Rejette H0: Modèle Poisson n'est pas une "simplification adéquate" du modèle binom nég
mod4p4 <- MASS::glm.nb(nusers ~ factor(weekday) + temp + relhumid, data = bixi)
# Compare model with daily effect (Ha) versus model with we/weekdays (H0)
anova(mod4p4, mod4p3)

###############################
#######  Exercice 4.5  ########
###############################

# Data from Bishop, Y. M. M. ; Fienberg, S. E. and Holland, P. W. (1975) 
# Discrete Multivariate Analysis: Theory and Practice. MIT Press, Cambridge
data(cancer, package = "hecstatmod")

print(cancer)
# Some categories have small counts, so asymptotic result

cancer.m0 <- glm(cbind(yes, no) ~ 1, family = "binomial", data = cancer)
cancer.m1 <- glm(cbind(yes, no) ~ age, family = "binomial", data = cancer)
cancer.m2 <- glm(cbind(yes, no) ~ malignant, family = "binomial", data = cancer)
cancer.m3 <- glm(cbind(yes, no) ~ age + malignant, family = "binomial", data = cancer)
cancer.m4 <- glm(cbind(yes, no) ~ age * malignant, family = "binomial", data = cancer)


data.frame("model" = paste0("M",0:3), 
           "deviance" = round(c(deviance(cancer.m0), deviance(cancer.m1), deviance(cancer.m2), deviance(cancer.m3)), 2),
           "p" = c(length(coef(cancer.m0)), length(coef(cancer.m1)),length(coef(cancer.m2)),length(coef(cancer.m3))))
# library(xtable)
# devtab <- data.frame("model" = c("$M_0$","$M_1$","$M_2$","$M_3$"), 
#                      "deviance" = round(c(deviance(cancer.m0), deviance(cancer.m1), deviance(cancer.m2), deviance(cancer.m3)), 2),
#       "p" = c(length(coef(cancer.m0)), length(coef(cancer.m1)),length(coef(cancer.m2)),length(coef(cancer.m3))))
# xtab <- xtable(devtab, caption = "Analysis of deviance for the \\texttt{smoking} data set")
# names(xtab) <- c("model", "deviance (binom.)", "deviance (Poisson)", "$p$")
# print(xtab, booktabs = TRUE, sanitize.text.function = identity, include.rownames = FALSE)
## Analysis of deviance
# Saturated model vs additive model
 1- pchisq(deviance(cancer.m3), df = nrow(cancer) - length(cancer.m3$coef))
# p-value of 0.78, fail to reject null that additive model is adequate
# Try further simplification
# Fail to reject null that model with only "malignant" is adequate simplification
 1- pchisq(2*(c(logLik(cancer.m3) - logLik(cancer.m2))), df = (length(cancer.m3$coef) - length(cancer.m2$coef)))
  # Alternatively 
 anova(cancer.m2, cancer.m3, test = "LRT") #Delta Deviance and #Delta DF in last two columns
 
 1- pchisq(2*(c(logLik(cancer.m3) - logLik(cancer.m1))), df = (length(cancer.m3$coef) - length(cancer.m1$coef)))

# Reject null that model with only intercept is adequate
 1- pchisq(2*(c(logLik(cancer.m2) - logLik(cancer.m0))), df = (length(cancer.m2$coef) - length(cancer.m0$coef)))

# If Model is adequate, Deviance approx JK-p 
deviance(cancer.m2) / (nrow(cancer) - length(coef(cancer.m2)))
pchisq(deviance(cancer.m2), df = nrow(cancer) - length(coef(cancer.m2)), lower.tail = FALSE)

###############################
#######  Exercise 4.6  ########
###############################
data(smoking, package = "hecstatmod")
smoking.p.m0 <- glm(dead ~ offset(log(pop)), family = poisson, data = smoking)
smoking.p.m1 <- glm(dead ~ offset(log(pop)) + smoke, family = poisson, data = smoking)
smoking.p.m2 <- glm(dead ~ offset(log(pop)) + age, family = poisson, data = smoking)
smoking.p.m3 <- glm(dead ~ offset(log(pop)) + smoke + age, family = poisson, data = smoking)
#Define quantities
n <- nrow(smoking)
p0 <- length(coef(smoking.p.m0)); D0p <- deviance(smoking.p.m0)
p1 <- length(coef(smoking.p.m1)); D1p <- deviance(smoking.p.m1)
p2 <- length(coef(smoking.p.m2)); D2p <- deviance(smoking.p.m2)
p3 <- length(coef(smoking.p.m3)); D3p <- deviance(smoking.p.m3)


1 - pchisq(D3p, df = n - p3) # Interaction not stat. significative
1 - pchisq(D2p - D3p, df = p3 - p2) # smoke significative
1 - pchisq(D1p - D3p, df = p3 - p1) # smoke significative
#If Model is correct, D3 approx chisq(n - p3)
summary(smoking.p.m3)

#Same with binomial model
smoking.b.m0 <- glm(cbind(dead, pop - dead) ~ 1, family = binomial, data = smoking)
smoking.b.m1 <- glm(cbind(dead, pop - dead) ~ smoke, family = binomial, data = smoking)
smoking.b.m2 <- glm(cbind(dead, pop - dead) ~ age, family = binomial, data = smoking)
smoking.b.m3 <- glm(cbind(dead, pop - dead) ~ smoke + age, family = binomial, data = smoking)
#Define quantities
n <- nrow(smoking)
D0b <- deviance(smoking.b.m0)
D1b <- deviance(smoking.b.m1)
D2b <- deviance(smoking.b.m2)
D3b <- deviance(smoking.b.m3)

1 - pchisq(D3b, df = n - p3) # Interaction not stat. significative
1 - pchisq(D2b - D3b, df = p3 - p2) # smoking group significative
1 - pchisq(D1b - D3b, df = p3 - p1) # smoking group significative
#If Model is correct, D3 approx n - p3
summary(smoking.b.m3)
# Output deviance table


data.frame("model" = paste0("M",0:3),
                      "deviance binom." =round(c(D0p, D1p, D2p, D3p), 2),
                      "deviance Poisson" =round(c(D0b, D1b, D2b, D3b), 2),
                      "p" = c(p0, p1, p2, p3))

# devtab <- data.frame("model" = c("$M_0$","$M_1$","$M_2$","$M_3$"), 
#                      "deviance binom." =round(c(D0p, D1p, D2p, D3p), 2),
#                      "deviance Poisson" =round(c(D0b, D1b, D2b, D3b), 2),
#                      "p" = c(p0, p1, p2, p3))
# xtab <- xtable(devtab, caption = "Analysis of deviance for the \\texttt{smoking} data set")
# print(xtab, booktabs = TRUE, sanitize.text.function = identity, include.rownames = FALSE, )
# 
# Compare fitted probabilities
ggplot(data.frame(x = fitted(smoking.b.m3),
                  y = fitted(smoking.b.m3) - fitted(smoking.p.m3)/fumeurs$pop),
       aes(x = x, y = y)) + 
  geom_point() + 
  xlab("Fitted probability of death\n from logistic model") + 
  ylab("Difference in fitted probability of death \nbetween logistic and Poisson models")

## Base R plots 
# par(mar = c(6,6,3,2), bty = "l")
# plot(fitted(smoking.b.m3), fitted(smoking.b.m3) - fitted(smoking.p.m3)/smoking$pop,
#      xlab = "Fitted probability of death\n from logistic model",
#      ylab = "Difference in fitted probability of death \nbetween Poisson and logistic models",
#      main = "Smoking cancer dataset")
#Differ most for last categories in which the Poisson approximation is dubious
