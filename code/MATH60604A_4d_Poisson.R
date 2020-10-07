data(intention, package = "hecstatmod")
# Fitting Poisson model
form <- "nitem ~ sex + age + revenue + educ + marital + fixation + emotion"
m2 <- glm(form, data=intention, family=poisson)
# Coefficients table with Wald tests
summary(m2)
# Type 3 effects - likelihood ratio tests
car::Anova(m2, 3)
# Likelihood-based 95% confidence intervals for parameters
confint(m2)
AIC(m2); BIC(m2); deviance(m2); df.residual(m2)
# The Pearson chi-square statistic is obtained
# by summing the Pearson residuals
sum(residuals(m2, type = "pearson")^2)
