### transform.R --- 
##----------------------------------------------------------------------
## Author: Brice Ozenne
## Created: feb 13 2025 (11:44) 
## Version: 
## Last-Updated: feb 18 2025 (15:47) 
##           By: Brice Ozenne
##     Update #: 25
##----------------------------------------------------------------------
## 
### Commentary: 
## 
### Change Log:
##----------------------------------------------------------------------
## 
### Code:

library(BuyseTest)
library(data.table)
library(survival)

## * prodige
argsSurv <- list(name = c("OS","PFS"),
                 name.censoring = c("statusOS","statusPFS"),
                 scale.C = c(9.995655, 4.265128),
                 scale.T = c(13.16543, 7.884477),
                 shape.C = c(1.28993, 1.391015),
                 shape.T = c(1.575269, 1.327461),
                 scale.censoring.C = c(34.30562, 20.748712),
                 scale.censoring.T = c(27.88519, 17.484281),
                 shape.censoring.C = c(1.369449, 1.463876),
                 shape.censoring.T = c(1.490881, 1.835526))

argsTox <- list(name = "toxicity",
                p.C =  c(16.09, 15.42, 33.26, 26.18, 8.38, 0.67)/100,
                p.T = c(8.21, 13.09, 31.29, 30.87, 12.05, 4.49)/100,
                rho.T = 1, rho.C = 1)
## c(sum(argsTox$p.C),sum(argsTox$p.C[3:6]))
## c(sum(argsTox$p.T),sum(argsTox$p.T[3:6]))
set.seed(1)
prodige <- simBuyseTest(n.T = 421, n.C = 402,
                        argsBin = argsTox,
                        argsCont = NULL,
                        argsTTE = argsSurv,
                        level.strata = c("M","F"), names.strata = "sex")[, c("OS") := .(OS/2)]

## max follow-up: 36 months
prodige[PFS > 36, c("PFS","statusPFS") := .(36,0)]
prodige[OS > 36, c("OS","statusOS") := .(36,0)]
## if censored PFS after OS then PFS is censored at OS time
prodige[PFS > OS & statusPFS == 0,PFS := OS]
## if PFS after OS then PFS occured during the last month
prodige[PFS > OS & statusPFS == 1, c("PFS","statusPFS") := .(OS,0)]
## prodige[PFS > OS]
prodige[, OS := pmax(round(OS,4),0.0001)]
prodige[, PFS := round(PFS,4)]
## toxicity
prodige[, toxicity := as.numeric(toxicity)]
## any(duplicated(setdiff(prodige$OS,36)))
## any(duplicated(setdiff(prodige$PFS,36)))
## library(prodlim)
## plot(prodlim(Hist(OS,statusOS)~treatment, data = prodige))
## plot(prodlim(Hist(PFS,statusPFS)~treatment, data = prodige))
## coxph(Surv(OS, statusOS) ~ treatment, data = prodige)
## model.tables(BuyseTest(treatment ~ tte(OS, statusOS), data = prodige, trace = FALSE))
## model.tables(BuyseTest(treatment ~ cont(toxicity, operator = "<0"), data = prodige, trace = FALSE))
## exact2x2::uncondExact2x2(n1 = 402, x1 = sum(prodige[treatment == "C",toxicity>=3]), n2 = 421, x2 = sum(prodige[treatment == "T",toxicity>=3]))
save(prodige, file = "data/prodige.rda")
## write.csv(prodige, "../tutorial-DagStat2025-GPC/data/prodige.csv", row.names = FALSE)


## * CHARM
CHARM <- read.csv("inst/source/CHARM_sim.csv", header = TRUE, na.string = ".")
CHARM <- cbind(id = 1:NROW(CHARM), CHARM)
## CHARM[CHARM$statusHospitalization == 1 & CHARM$statusMortality == 1,]
## any(CHARM$Hospitalization > CHARM$Mortality)
## range(CHARM$Composite - pmin(CHARM$Mortality,CHARM$Hospitalization))
## range(CHARM$statusComposite - pmax(CHARM$statusMortality,CHARM$statusHospitalization))
save(CHARM, file = "data/CHARM.rda")
## write.csv(CHARM, "../tutorial-DagStat2025-GPC/data/CHARM.csv", row.names = FALSE)

## * EB
EB <- read.csv("inst/source/EB.csv", header = TRUE, na.string = c(".","NA"))
save(EB, file = "data/EB.rda")
## write.csv(EB, "../tutorial-DagStat2025-GPC/data/EB.csv", row.names = FALSE)

##----------------------------------------------------------------------
### transform.R ends here
