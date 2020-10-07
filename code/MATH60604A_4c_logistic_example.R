data(intention, package = "hecstatmod")
# Logistic regression
form <- "buy ~ sex + age + revenue + educ + marital + fixation + emotion"
m4 <- glm(form, data=intention, family=binomial(link="logit"))  
summary(m4)
car::Anova(m4, type = "3")
# 95% confidence intervals for odds (i.e., exp(beta))
exp(cbind(coef(m4), confint(m4)))
