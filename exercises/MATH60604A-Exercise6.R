# Exercise 6.2
data(gsce, package = "hecstatmod")
library(nlme)
# Compound symmetry model within center
mod1 <- gls(result ~ coursework + sex, 
    data = gsce, 
    correlation = corCompSymm(form = ~1 | center))
# Model with main effect for factor center
mod2 <- gls(result ~ coursework + sex + center, 
            data = gsce)
# Linear mixed model with random intercept per center
mod3 <- lme(fixed = result ~ coursework + sex, 
            data = gsce,
            random = ~1 | center)
# Covariance of errors epsilon
getVarCov(mod3, levels = rep(1,3), type = "conditional")
# Covariance of Y
getVarCov(mod3, levels = rep(1,3), type = "marginal")
# Predictions - level=0 for marginal, level=1 includes random effect (conditional)
predict(mod3, newdata = data.frame(coursework = 91, center = 2, sex=1), 
        level = 0:1)
predict(mod3, newdata = data.frame(coursework = 100, sex=1),
        level = 0)

