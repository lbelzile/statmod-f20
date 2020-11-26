library(lme4)
data(chicken, package = "hecstatmod")
# Fit a model with diet as fixed effect
# Correlated random effects
mod1 <- lme4::lmer(weight ~ time + diet + (1 + time | chick),
           data = chicken)
# Diagonal covariance matrix for random effects (variance components)
mod2 <- lme4::lmer(weight ~  time + diet + 
                     (1 | chick) +
                     (time - 1 | chick),
           data = chicken)
# Test if the correlation between random intercept/slope is null
# H0: omega_{12}=0 versus H1: omega_{12} NEQ 0
anova(mod1, mod2)

# Fit alternative with a random effect for diet 
# chick is nested within diet
mod3 <- lme4::lmer(weight ~ time +
                     (1 + time | diet:chick) + 
                     (1 | diet),
                   data = chicken)

# Function from StackOverflow
# https://stackoverflow.com/questions/45650548/get-residual-variance-covariance-matrix-in-lme4/45655597#45655597
rescov <- function(model, data) {
  var.d <- crossprod(getME(model,"Lambdat"))
  Zt <- getME(model,"Zt")
  vr <- sigma(model)^2
  var.b <- vr*(t(Zt) %*% var.d %*% Zt)
  sI <- vr * Diagonal(nrow(data))
  var.y <- var.b + sI
  invisible(var.y)
}
# Print the covariance matrix of the nested models
rc3 <- rescov(mod3, chicken)
image(cov2cor(rc3), sub = "", xlab = "", ylab = "")


