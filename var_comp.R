library(insight)
library(lme4)
data(sleepstudy)
m <- lmer(Reaction ~ Days + (1 + Days | Subject), data = sleepstudy)

get_variance(m)

https://cran.r-project.org/web/packages/VCA/vignettes/VCA_package_vignette.html  
library(vca)

library(specr)
library(ggplot2)
library(dplyr)

library(lme4)

# Estimate model
m1 <- lmer(estimate ~ 1 + (1|x) + (1|y) + (1|controls) + (1|subsets), data = results)

# Check model summary
summary(m1)
plot_variance(m1) +
  ylim(0, 100)

results
