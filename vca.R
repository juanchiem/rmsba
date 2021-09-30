library(VCA)
# simulate some data with N=500,000 observations
  set.seed(23)
  dat <- data.frame(y=10+rep(rnorm(5,,3), rep(1e5,5)) + rep(rnorm(250,,2), rep(2000, 250)) + rep(rnorm(500,,2), rep(1000, 500)) + rnorm(5e5,,1.5))
  dat$fac1 <- rep(LETTERS[1:5], rep(1e5,5))
  dat$fac2 <- rep(rep(1:50, rep(2000, 50)), 5)
  dat$fac3 <- rep(rep(1:2, c(1000, 1000)), 250)
  dim(dat)
[1] 500000 4
# use ANOVA-estimation, which is now done using a FORTRAN-implementation of # the SWEEP-operator
system.time(fit1 <- anovaVCA(y~fac1/fac2/fac3, dat))
Convert variable fac1 from "character" to "factor"!
  user system elapsed
25.58 11.55 37.27
> fit1
Result Variance Component Analysis:
  -----------------------------------
  Name DF SS MS VC %Total SD CV[%]
1 total 29.754649 15.740646 100 3.967448 32.658888
2 fac1 4 2288723.003035 572180.750759 5.6111 35.647205 2.368776 19.49908
3 fac1:fac2 245 2712327.007202 11070.722478 3.182573 20.218821 1.783977 14.685181
4 fac1:fac2:fac3 250 1176394.113069 4705.576452 4.703333 29.880177 2.168717 17.852251
5 error 499500 1120697.976915 2.24364 2.24364 14.253796 1.497878 12.330102
Mean: 12.14814 (N = 500000)
Experimental Design: balanced | Method: ANOVA
# extract the covariance matrix of variance components
> vcovVC(fit1)
fac1 fac1:fac2 fac1:fac2:fac3 error
fac1 1.636964e+01 -5.002486e-03 -3.129716e-19 8.194873e-28
fac1:fac2 -5.002486e-03 2.944092e-01 -8.856980e-02 -2.185300e-24
fac1:fac2:fac3 -3.129716e-19 -8.856980e-02 1.771396e-01 -2.015583e-08
error 8.194873e-28 -2.185300e-24 -2.015583e-08 2.015583e-05
attr(,"method")
[1] "scm"
# now use REML-estimation with R-package "lme4". For large data sets REML- estimation
# implemented in the VCA-package does not work, the problem size is too large. There
# might be an option in the future to just fit models via REML and extract the VCA-table
# as shown below without getting the covariance-matrix of the variance components.
> system.time(fit2 <- lmer(y~(1|fac1) + (1|fac1:fac2) + (1|fac1:fac2:fac3), dat))
user system elapsed
14.02 5.53 19.61
# use function "lmerSummary" from the VCA-package to get the VCA-table
> lmerSummary(fit2, tab.only=TRUE)
VC %Total SD CV[%]
total 15.740239 100.00000 3.967397 32.65847
fac1:fac2:fac3 4.703249 29.88042 2.168697 17.85209
fac1:fac2 3.182545 20.21917 1.783969 14.68512
fac1 5.610805 35.64625 2.368714 19.49857
error 2.243640 14.25416 1.497878 12.33010
attr(,"Mean")
[1] 12.14814