# Exercise 5.1 
# 
library(nlme)
data(renergie, package = "hecstatmod")
cols <- c(gray.colors(n = 16), 2)[c(1:10,17,11:16)]

# Plot the time series using interaction plots 
par(mar = c(5,6,1,1), mfrow = c(1,2), bty = "l", pch = 20)
with(renergie,
     interaction.plot(response = ave, 
                      trace.factor = factor(region), 
                      x.factor = as.factor(date),
                      col = cols, lty = 1, legend = FALSE,
                      xlab = "date", ylab = "weekly average price (in CAD)")
)
with(renergie,
     interaction.plot(response = ave-min, 
                      trace.factor = factor(region), 
                      x.factor = as.factor(date),
                      col = cols, lty = 1, legend = FALSE,
                      xlab = "date", ylab = "weekly average of retailer\n margin of profit (in CAD)")
)

# Produce prettier plots (using time series package!)
library(xts)
par(mar = c(3,3,1,1), mfrow = c(1,2), bty = "l", pch = 20)
plot(xts(x = ren[,19:35], order.by = ren$date), main =  "Average retailers margin of profit")
plot(xts(x = ren[,2:18], order.by = ren$date), main =  "Average sale price")


# Transform from long to wide format
ren <- renergie
ren$marg <- renergie$ave - ren$min
ren$min <- NULL
ren <- tidyr::pivot_wider(data = ren, values_from = c("ave","marg"), names_from = region)



rener_mod1 <- nlme::gls(I(ave-min) ~ factor(region), data = renergie, 
                        correlation = corAR1(form=~1 | date))
plot(ACF(rener_mod1, resType = "normalized"))
likH0 <- logLik(rener_mod1)

# assessing the hypothesis requires essentially 
# fitting 17 different models and adding their REML
likH1 <- sum(sapply(1:17, function(i){
  logLik(nlme::gls(I(ave-min) ~ 1, data = renergie[renergie$region==i,],
                   correlation = corAR1(form=~1 | date)))}))
pchisq(2*as.numeric(likH0-likH1), df = 32, lower.tail = FALSE)

# Exercise 5.3

data(tolerance, package = "hecstatmod")
tolerance$sex <- factor(tolerance$sex, labels = c("female","male"))
# EDA plots
library(ggplot2)
library(patchwork)
g1 <- ggplot(data = tolerance) + 
  geom_boxplot(aes(y = tolerance, x = sex))
g2 <- ggplot(data = tolerance) + 
  geom_point(aes(y = tolerance, x = exposure))
g3 <- ggplot(data = tolerance) + 
  geom_boxplot(aes(y = tolerance, x = factor(age))) + 
  xlab("age (in years)")
g1 + g2 + g3

ggplot(data = tolerance, aes(x = age, y = tolerance, group = id, color=id)) +
  geom_line() + theme(legend.position="none")

## Base R plots
# par(mfrow = c(1,3), mar = c(4,4,0.5,0.5), bty = "l")
# boxplot(tolerance ~ sex, data = tolerance)
# plot(tolerance ~ exposure, data = tolerance)
# boxplot(tolerance ~ factor(age), xlab = "age (in years)", data = tolerance)
# dev.off()
# Spaghetti plot
# with(tolerance,
#      interaction.plot(x.factor = age,
#                  trace.factor = id,
#                  response = tolerance,
#                  xlab = "age (in years)", 
#                  ylab = "tolerance score",
#                  col = 1:16,
#                  legend=FALSE, bty = "l")
# )
mod1 <- gls(tolerance ~ sex + exposure + age, data = tolerance, 
    correlation = corCompSymm(form= ~ 1 | id))
mod2 <- gls(tolerance ~ sex + exposure + age, data = tolerance, 
    correlation = corAR1(form= ~ 1 | id))
mod3 <- gls(tolerance ~ sex + exposure + age, data = tolerance)
anova(mod1, mod3)
anova(mod2, mod3)
cbind("AIC" = c(AIC(mod1), AIC(mod2), AIC(mod3)), 
      "BIC" = c(BIC(mod1), BIC(mod2), BIC(mod3)))


