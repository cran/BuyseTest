### test-BuyseTest-iid.R --- 
##----------------------------------------------------------------------
## Author: Brice Ozenne
## Created: jan  8 2019 (11:54) 
## Version: 
## Last-Updated: Apr  9 2021 (11:19) 
##           By: Brice Ozenne
##     Update #: 166
##----------------------------------------------------------------------
## 
### Commentary: 
## 
### Change Log:
##----------------------------------------------------------------------
## 
### Code:

if(FALSE){
    library(testthat)
    library(BuyseTest)
    library(data.table)
}

## options("stringsAsFactors" = TRUE)
context("Check correct computation of the variance \n")
var2 <- function(x){var(x)*(length(x)-1)/length(x)}
cov2 <- function(x,y){cov(x,y)*(length(x)-1)/length(x)}

## * Settings
BuyseTest.options(check = TRUE,
                  keep.pairScore = FALSE,
                  method.inference = "u-statistic",
                  trace = 0)

## * iid average
## data binary
d <- data.table(id = 1:4, group = c("C","C","T","T"), toxicity = c(1,0,1,0))
d2 <- rbind(cbind(d, strata = 1),
            cbind(d, strata = 2),
            cbind(d, strata = 3))

## data continue,TTE
n <- 5
set.seed(10)
dt <- simBuyseTest(n)
dtS <- rbind(cbind(S = 1, dt), cbind(S = 2, dt), cbind(S = 3, dt))
dtS$score1 <- dtS$score
dtS$score2 <- dtS$score
dtS[S == 1, score1 := 1]
dtS[S > 1, score2 := 1]

## ** 1 binary variable
## *** no strata
## equal number in each group

test_that("iid: binary and no strata (balanced groups)", {
    ## first order
    BuyseTest.options(order.Hprojection = 1)
    e.BT <- BuyseTest(group ~ bin(toxicity),
                      data = d, 
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(group ~ bin(toxicity),
                       data = d, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")

    expect_equal(e.BT@covariance, e2.BT@covariance)
    expect_equal(as.double(e.BT@covariance), c(1/16,1/16,-1/16, 1/4, 4) )

    expect_equal(as.double(getIid(e.BT, statistic = "favorable")), c(-1/8,1/8,1/8,-1/8))
    expect_equal(as.double(getIid(e.BT, statistic = "unfavorable")), c(1/8,-1/8,-1/8,1/8))

    ## second order
    BuyseTest.options(order.Hprojection = 2)
    e.BT <- BuyseTest(group ~ bin(toxicity),
                      data = d, keep.pairScore = FALSE,
                      method.inference = "u-statistic")
    e1.BT <- BuyseTest(group ~ bin(toxicity),
                     data = d, keep.pairScore = TRUE,
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(group ~ bin(toxicity),
                       data = d, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")

    expect_equal(e.BT@covariance, e1.BT@covariance) ## assumes vs. does not assumes binary score when computing second order terms
    expect_equal(e.BT@covariance, e2.BT@covariance) 
    expect_equal(as.double(e.BT@covariance), c(5/64, 5/64, -3/64, 1/4, 4) )
})

## unequal number in each group
d.bis <- data.table(id = 1:4, group = c("C","T","T","T"), toxicity = c(1,1,1,0))

test_that("iid: binary and no strata (unbalanced groups)", {
    ## first order
    BuyseTest.options(order.Hprojection = 1)
    suppressWarnings(e.BT <- BuyseTest(group ~ bin(toxicity),
                                       data = d.bis, 
                                       method.inference = "u-statistic"))
    suppressWarnings(e2.BT <- BuyseTest(group ~ bin(toxicity),
                       data = d.bis, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu"))
    
    expect_equal(e.BT@covariance, e2.BT@covariance)
    expect_equal(as.double(e.BT@covariance), c(0, 2/27, 0, 2/27, 0) )

    expect_equal(as.double(getIid(e.BT, statistic = "favorable")), c(0,0,0,0))
    expect_equal(as.double(getIid(e.BT, statistic = "unfavorable")), c(0,-1/9,-1/9,2/9))

    ## second order
    BuyseTest.options(order.Hprojection = 2)
    suppressWarnings(e.BT <- BuyseTest(group ~ bin(toxicity),
                      data = d.bis, keep.pairScore = FALSE,
                      method.inference = "u-statistic"))
    suppressWarnings(e1.BT <- BuyseTest(group ~ bin(toxicity),
                       data = d.bis, keep.pairScore = TRUE,
                       method.inference = "u-statistic"))
    suppressWarnings(e2.BT <- BuyseTest(group ~ bin(toxicity),
                       data = d.bis, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu"))
    
    expect_equal(e.BT@covariance, e1.BT@covariance) ## assumes vs. does not assumes binary score when computing second order terms
    expect_equal(e.BT@covariance, e2.BT@covariance) 
    expect_equal(as.double(e.BT@covariance), c(0, 2/27, 0, 2/27, 0) )
})


## *** strata
test_that("iid: binary with strata (balanced groups)", {
    ## first order
    BuyseTest.options(order.Hprojection = 1)
    e.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                      data = d2, 
                      method.inference = "u-statistic", keep.pairScore = TRUE)
    e2.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                       data = d2, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")

    expect_equal(e.BT@covariance, e2.BT@covariance)
    expect_equal(as.double(e.BT@covariance), c(1/16, 1/16, -1/16, 1/4, 4)/3 )

    expect_equal(as.double(getIid(e.BT, statistic = "favorable")), rep(c(-1/8,1/8,1/8,-1/8),3)/3)
    expect_equal(as.double(getIid(e.BT, statistic = "unfavorable")), rep(c(1/8,-1/8,-1/8,1/8),3)/3)

    ## second order
    BuyseTest.options(order.Hprojection = 2)
    e.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                      data = d2, keep.pairScore = FALSE,
                      method.inference = "u-statistic")
    e1.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                       data = d2, keep.pairScore = TRUE,
                       method.inference = "u-statistic")
    e2.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                       data = d2, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")
    
    expect_equal(e.BT@covariance, e1.BT@covariance) ## assumes vs. does not assumes binary score when computing second order terms
    expect_equal(e.BT@covariance, e2.BT@covariance)
    
    expect_equal(as.double(e.BT@covariance), c(5/64, 5/64, -3/64, 1/4, 4)/3 )
})

d2.bis <- rbind(cbind(d.bis, strata = 1),
                cbind(d.bis, strata = 2),
                cbind(d.bis, strata = 3))

test_that("iid: binary and no strata (unbalanced groups)", {
    ## first order
    BuyseTest.options(order.Hprojection = 1)
    e.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                      data = d2.bis, 
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                       data = d2.bis, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")
    
    expect_equal(e.BT@covariance, e2.BT@covariance)
    expect_equal(as.double(e.BT@covariance), c(0, 2/27, 0, 2/27, 0)/3 )

    expect_equal(as.double(getIid(e.BT, statistic = "favorable")), rep(c(0,0,0,0),3)/3)
    expect_equal(as.double(getIid(e.BT, statistic = "unfavorable")), rep(c(0,-1/9,-1/9,2/9),3)/3)

    ## second order
    BuyseTest.options(order.Hprojection = 2)
    e.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                      data = d2.bis, keep.pairScore = FALSE,
                      method.inference = "u-statistic")
    e1.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                       data = d2.bis, keep.pairScore = TRUE,
                       method.inference = "u-statistic")
    e2.BT <- BuyseTest(group ~ bin(toxicity) + strata,
                       data = d2.bis, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")
    
    expect_equal(e.BT@covariance, e1.BT@covariance) ## assumes vs. does not assumes binary score when computing second order terms
    expect_equal(e.BT@covariance, e2.BT@covariance)
    
    expect_equal(as.double(e.BT@covariance), c(0, 2/27, 0, 2/27, 0)/3 )
})

## ** 1 continuous variable
test_that("Manual calculation of second order H projection (no strata)",{

    BuyseTest.options(order.Hprojection = 1)
    e.BT_c1 <- BuyseTest(treatment ~ cont(score),
                         data = dt, trace = 0, 
                         method.inference = "u-statistic")
    BuyseTest.options(order.Hprojection = 2)
    e.BT_c2 <- BuyseTest(treatment ~ cont(score),
                         data = dt, trace = 0, 
                         method.inference = "u-statistic")
    e.BT_c3 <- BuyseTest(treatment ~ cont(score),
                         data = dt, trace = 0, keep.pairScore = TRUE, 
                         method.inference = "u-statistic")

    ## manual calculation
    dt.pair <- getPairScore(e.BT_c3)[,.(index.C,index.T,favorable,unfavorable)]
    dt.pair[, H1C.favorable := mean(favorable), by = index.C]
    dt.pair[, H1T.favorable := mean(favorable), by = index.T]
    dt.pair[, H1C.favorable := H1C.favorable - mean(favorable)]
    dt.pair[, H1T.favorable := H1T.favorable - mean(favorable)]

    dt.pair[, H1C.unfavorable := mean(unfavorable), by = index.C]
    dt.pair[, H1T.unfavorable := mean(unfavorable), by = index.T]
    dt.pair[, H1C.unfavorable := H1C.unfavorable - mean(unfavorable)]
    dt.pair[, H1T.unfavorable := H1T.unfavorable - mean(unfavorable)]

    dt.pair[, H2.favorable := favorable - H1C.favorable - H1T.favorable]
    dt.pair[, H2.unfavorable := unfavorable - H1C.unfavorable - H1T.unfavorable]

    ## check H1
    expect_true(all(abs(dt.pair[!duplicated(index.C),.(H1C.favorable/.N,H1C.unfavorable/.N)]-getIid(e.BT_c3, statistic = c("favorable","unfavorable"))[1:n,])<1e-6))
    expect_true(all(abs(dt.pair[!duplicated(index.T),.(H1T.favorable/.N,H1T.unfavorable/.N)]-getIid(e.BT_c3, statistic = c("favorable","unfavorable"))[(n+1):(2*n),])<1e-6))
        
    ## check H2
    manual <- dt.pair[,.(favorable = var2(H2.favorable)/.N,
                         unfavorable = var2(H2.unfavorable)/.N,
                         covariance = cov2(H2.favorable,H2.unfavorable)/.N)]
    expect_equal(as.double(manual), as.double((e.BT_c2@covariance - e.BT_c1@covariance)[1,c("favorable","unfavorable","covariance")]))
    expect_equal(as.double(manual), c(0.00256, 0.00256, -0.00256), tol = 1e-5)   
})

test_that("Manual calculation of second order H projection (strata)",{
    BuyseTest.options(order.Hprojection = 1)
    e.BT_c1 <- BuyseTest(treatment ~ cont(score) + S,
                         data = dtS, trace = 0, 
                         method.inference = "u-statistic")
    BuyseTest.options(order.Hprojection = 2)
    e.BT_c2 <- BuyseTest(treatment ~ cont(score) + S,
                         data = dtS, trace = 0, 
                         method.inference = "u-statistic")
    e.BT_c3 <- BuyseTest(treatment ~ cont(score) + S,
                         data = dtS, trace = 0, keep.pairScore = TRUE, 
                         method.inference = "u-statistic")

    ## manual calculation
    dt.pair <- getPairScore(e.BT_c3)[,.(strata,index.C,index.T,favorable,unfavorable)]
    dt.pair[, H1C.favorable := mean(favorable), by = index.C]
    dt.pair[, H1T.favorable := mean(favorable), by = index.T]
    dt.pair[, H1C.favorable := H1C.favorable - mean(favorable), by = "strata"]
    dt.pair[, H1T.favorable := H1T.favorable - mean(favorable), by = "strata"]

    dt.pair[, H1C.unfavorable := mean(unfavorable), by = index.C]
    dt.pair[, H1T.unfavorable := mean(unfavorable), by = index.T]
    dt.pair[, H1C.unfavorable := H1C.unfavorable - mean(unfavorable), by = "strata"]
    dt.pair[, H1T.unfavorable := H1T.unfavorable - mean(unfavorable), by = "strata"]

    dt.pair[, H2.favorable := favorable - H1C.favorable - H1T.favorable]
    dt.pair[, H2.unfavorable := unfavorable - H1C.unfavorable - H1T.unfavorable]

    ## check H1
    expect_true(all(abs(dt.pair[!duplicated(index.C),.(H1C.favorable/.N,H1C.unfavorable/.N)]-getIid(e.BT_c3, statistic = c("favorable","unfavorable"))[which(dtS$treatment=="C"),])<1e-6))
    expect_true(all(abs(dt.pair[!duplicated(index.T),.(H1T.favorable/.N,H1T.unfavorable/.N)]-getIid(e.BT_c3, statistic = c("favorable","unfavorable"))[which(dtS$treatment=="T"),])<1e-6))
        
    ## check H2
    manual <- dt.pair[,.(favorable = var2(H2.favorable)/.N,
                         unfavorable = var2(H2.unfavorable)/.N,
                         covariance = cov2(H2.favorable,H2.unfavorable)/.N)]
    expect_equal(as.double(manual), as.double((e.BT_c2@covariance - e.BT_c1@covariance)[1,c("favorable","unfavorable","covariance")]))
    expect_equal(as.double(manual), c(0.00085333, 0.00085333, -0.00085333), tol = 1e-5)
})

## ** 1 TTE variable
test_that("iid: TTE and no strata",{
    BuyseTest.options(order.Hprojection = 1)

    e.BT_tte1 <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1),
                           data = dt, trace = 0, 
                           keep.pairScore = TRUE,
                           scoring.rule = "Gehan",
                           method.inference = "u-statistic")
    e.BT_tte2 <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1e5) + tte(eventtime, status, threshold = 1-1e-5),
                           data = dt, trace = 0, 
                           keep.pairScore = TRUE,
                           scoring.rule = "Gehan",
                           method.inference = "u-statistic")
    e.BT_tte3 <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1) + tte(eventtime, status, threshold = 1-1e-5),
                           data = dt, trace = 0,
                           keep.pairScore = TRUE,
                           scoring.rule = "Gehan",
                           method.inference = "u-statistic")

    expect_equal(confint(e.BT_tte1)[1,],
                 confint(e.BT_tte2)[2,],
                 tol = 1e-6)
    expect_equal(confint(e.BT_tte1)[1,],
                 confint(e.BT_tte3)[1,],
                 tol = 1e-6)
    expect_equal(confint(e.BT_tte3)[1,],
                 confint(e.BT_tte3)[2,],
                 tol = 1e-6)
})

## ** Two endpoints
## *** no strata
test_that("iid: two endpoints (no strata - first order)", {
    
    ## different endpoints
    BuyseTest.options(order.Hprojection = 1)
    e.BT <- BuyseTest(treatment ~  bin(toxicity) + cont(score, threshold = 1),
                      data = dtS,
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(treatment ~  bin(toxicity) + cont(score, threshold = 1),
                       data = dtS, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")

    expect_equal(e.BT@covariance, e2.BT@covariance)
    GS <- matrix(c(0.01066667, 0.01258667, 0, 0.00085333, 0, -0.00138667, 0.01066667, 0.01621333, NaN, 136.66666667), 
                 nrow = 2, 
                 ncol = 5, 
                 dimnames = list(c("toxicity_0.5", "score_1"),c("favorable", "unfavorable", "covariance", "netBenefit", "winRatio")) 
                 ) 

    expect_equal(e.BT@covariance, GS, tol = 1e-6 )

    ## same endpoint
    e.BT <- BuyseTest(treatment ~  cont(score, threshold = 2) + cont(score, threshold = 1),
                      data = dtS,
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(treatment ~  cont(score, threshold = 2) + cont(score, threshold = 1),
                       data = dtS, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")

    expect_equal(e.BT@covariance, e2.BT@covariance)
    GS <- matrix(c(0.01194667, 0.01408, 0, 0.00085333, 0, -0.00149333, 0.01194667, 0.01792, NaN, 108), 
                 nrow = 2, 
                 ncol = 5, 
                 dimnames = list(c("score_2", "score_1"),c("favorable", "unfavorable", "covariance", "netBenefit", "winRatio")) 
                 ) 
    expect_equal(e.BT@covariance, GS, tol = 1e-6 )

    ## same endpoint tte
    e.BT <- BuyseTest(treatment ~  tte(eventtime, threshold = 1, status = status) + tte(eventtime, threshold = 0, status = status),
                                       data = dtS, scoring.rule = "Gehan",
                                       method.inference = "u-statistic")
    e2.BT <- BuyseTest(treatment ~  tte(eventtime, threshold = 1, status = status) + tte(eventtime, threshold = 0, status = status),
                                        data = dtS, keep.pairScore = TRUE, scoring.rule = "Gehan",
                                        method.inference = "u-statistic-bebu")

    expect_equal(e.BT@covariance, e2.BT@covariance)
    GS <- matrix(c(0, 0.00234667, 0.00234667, 0.00832, 0, 0.00064, 0.00234667, 0.00938667, 0, 0.04938272), 
                 nrow = 2, 
                 ncol = 5, 
                 dimnames = list(c("eventtime_1", "eventtime_1e-12"),c("favorable", "unfavorable", "covariance", "netBenefit", "winRatio")) 
                 ) 
    expect_equal(e.BT@covariance, GS, tol = 1e-6 )

    ## cluster argument
    expect_equal(unname(getIid(e.BT, cluster = 1:NROW(dtS))), unname(getIid(e.BT)), tol = 1e-6)
    expect_equal(confint(e.BT, cluster = 1:NROW(dtS)),  confint(e.BT), tol = 1e-6)
})

test_that("iid: two endpoints (no strata - second order)", {

    BuyseTest.options(order.Hprojection = 2)
    ## different endpoints
    e.BT <- BuyseTest(treatment ~  bin(toxicity) + cont(score, threshold = 1),
                      data = dtS, keep.pairScore = FALSE,
                      method.inference = "u-statistic")
    e1.BT <- BuyseTest(treatment ~  bin(toxicity) + cont(score, threshold = 1),
                      data = dtS, keep.pairScore = TRUE,
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(treatment ~  bin(toxicity) + cont(score, threshold = 1),
                       data = dtS, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")

    remaining.pairs <- e1.BT@tablePairScore[[2]]$index.pair
    expect_equal(e1.BT@tablePairScore[[1]][index.pair %in% remaining.pairs,.(index.C,index.T)],
                 e1.BT@tablePairScore[[2]][,.(index.C,index.T)])
    expect_equal(e.BT@covariance, e1.BT@covariance)
    expect_equal(e.BT@covariance, e2.BT@covariance)

    GS <- matrix(c(0.01066667, 0.01284267, 0, 0.00096711, 0, -0.00139378, 0.01066667, 0.01659733, NaN, 150.88888889), 
                 nrow = 2, 
                 ncol = 5, 
                 dimnames = list(c("toxicity_0.5", "score_1"),c("favorable", "unfavorable", "covariance", "netBenefit", "winRatio")) 
                 ) 
    expect_equal(e.BT@covariance, GS, tol = 1e-6 )

    ## same endpoint
    e.BT <- BuyseTest(treatment ~  cont(score, threshold = 2) + cont(score, threshold = 1),
                      data = dtS, keep.pairScore = FALSE,
                      method.inference = "u-statistic")
    e1.BT <- BuyseTest(treatment ~  cont(score, threshold = 2) + cont(score, threshold = 1),
                      data = dtS, keep.pairScore = TRUE,
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(treatment ~  cont(score, threshold = 2) + cont(score, threshold = 1),
                       data = dtS, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")

    expect_equal(e.BT@covariance, e1.BT@covariance)
    expect_equal(e.BT@covariance, e2.BT@covariance)
    remaining.pairs <- e1.BT@tablePairScore[[2]]$index.pair
    expect_equal(e1.BT@tablePairScore[[1]][index.pair %in% remaining.pairs,.(index.C,index.T)],
                 e1.BT@tablePairScore[[2]][,.(index.C,index.T)])

    GS <- matrix(c(0.01211733, 0.01425067, 0, 0.00096711, 0, -0.00147911, 0.01211733, 0.018176, NaN, 118.13333333), 
                 nrow = 2, 
                 ncol = 5, 
                 dimnames = list(c("score_2", "score_1"),c("favorable", "unfavorable", "covariance", "netBenefit", "winRatio")) 
                 ) 
    expect_equal(e.BT@covariance, GS, tol = 1e-6 )

    ## same endpoint tte
    e.BT <- BuyseTest(treatment ~  tte(eventtime, threshold = 1, status = status) + tte(eventtime, threshold = 0, status = status),
                      data = dtS, scoring.rule = "Gehan", keep.pairScore = FALSE,
                      method.inference = "u-statistic")
    e1.BT <- BuyseTest(treatment ~  tte(eventtime, threshold = 1, status = status) + tte(eventtime, threshold = 0, status = status),
                      data = dtS, scoring.rule = "Gehan", keep.pairScore = TRUE,
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(treatment ~  tte(eventtime, threshold = 1, status = status) + tte(eventtime, threshold = 0, status = status),
                       data = dtS, keep.pairScore = TRUE, scoring.rule = "Gehan",
                       method.inference = "u-statistic-bebu")

    expect_equal(e.BT@covariance, e1.BT@covariance)
    expect_equal(e.BT@covariance, e2.BT@covariance)
    remaining.pairs <- e1.BT@tablePairScore[[2]]$index.pair
    expect_equal(e1.BT@tablePairScore[[1]][index.pair %in% remaining.pairs,.(index.C,index.T)],
                 e1.BT@tablePairScore[[2]][,.(index.C,index.T)])

    GS <- matrix(c(0, 0.00251733, 0.00251733, 0.008576, 0, 0.000512, 0.00251733, 0.01006933, 0, 0.05432099), 
                 nrow = 2, 
                 ncol = 5, 
                 dimnames = list(c("eventtime_1", "eventtime_1e-12"),c("favorable", "unfavorable", "covariance", "netBenefit", "winRatio")) 
                 ) 
    expect_equal(e.BT@covariance, GS, tol = 1e-6 )
})

## *** strata
test_that("iid: two endpoints (strata)", {

    ## first order
    BuyseTest.options(order.Hprojection = 1)
    e0.BT <- BuyseTest(treatment ~ cont(score, threshold = 1) + S,
                       data = dtS,
                       method.inference = "u-statistic")
    e.BT <- BuyseTest(treatment ~ cont(score1, threshold = 1) + cont(score2, threshold = 1) + S,
                      data = dtS,
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(treatment ~ cont(score1, threshold = 1) + cont(score2, threshold = 1) + S,
                       data = dtS, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu")

    expect_equal(as.double(e0.BT@covariance), as.double(e.BT@covariance[2,]))
    expect_equal(e.BT@covariance, e2.BT@covariance)
    expect_equal(as.double(e0.BT@covariance),
                 c(0.01408, 0.00085333, -0.00149333, 0.01792, 108), tol = 1e-6 )
    
    ## cluster argument
    expect_equal(unname(getIid(e.BT, cluster = 1:NROW(dtS))), unname(getIid(e.BT)), tol = 1e-6)
    expect_equal(confint(e.BT, cluster = 1:NROW(dtS)),  confint(e.BT), tol = 1e-6)

    ## second order
    BuyseTest.options(order.Hprojection = 2)
    e.BT <- BuyseTest(treatment ~ cont(score1, threshold = 1) + cont(score2, threshold = 1) + S,
                      data = dtS,
                      method.inference = "u-statistic") ## neglect some terms
    e1.BT <- BuyseTest(treatment ~ cont(score1, threshold = 1) + cont(score2, threshold = 1) + S,
                      data = dtS, keep.pairScore = TRUE,
                      method.inference = "u-statistic")
    e2.BT <- BuyseTest(treatment ~ cont(score1, threshold = 1) + cont(score2, threshold = 1) + S,
                       data = dtS, keep.pairScore = TRUE,
                       method.inference = "u-statistic-bebu") ## neglect some terms

    ## expect_equal(e.BT@covariance, e1.BT@covariance, tol = 1e-4) ## imperfect match
    expect_equal(e.BT@covariance, e2.BT@covariance)
    remaining.pairs <- e1.BT@tablePairScore[[2]]$index.pair

    expect_equal(e1.BT@tablePairScore[[1]][index.pair %in% remaining.pairs,.(index.C,index.T)],
                 e1.BT@tablePairScore[[2]][,.(index.C,index.T)])
    expect_equal(as.double(e1.BT@covariance["score2_1",]),
                 c(0.014592, 0.00119467, -0.00145067, 0.018688, 138.4), tol = 1e-6 )


})

## * iid Peron

## ** 1 TTE variable
n <- 5
set.seed(10)
dt <- simBuyseTest(n)
dt$X0 <- 0
dt$treatment2 <- as.numeric(dt$treatment=="C")
## data.table("treatment" = c("C", "C", "C", "C", "C", "T", "T", "T", "T", "T"), 
##            "eventtime" = c(0.60539304, 0.31328027, 0.03946623, 0.32147489, 1.57044952, 0.29069131, 0.19522131, 0.04640668, 0.05277335, 0.43062009), 
##            "status" = c(0, 1, 0, 1, 0, 0, 0, 0, 1, 1), 
##            "toxicity" = c("yes", "yes", "yes", "yes", "yes", "no", "yes", "yes", "yes", "yes"), 
##            "score" = c(-1.85374045, -0.07794607,  0.96856634,  0.18492596, -1.37994358,  1.10177950,  0.75578151, -0.23823356,  0.98744470,  0.74139013), 
##            "X0" = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0), 
##            "treatment2" = c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0))

test_that("iid with nuisance parameters: 1 TTE",{
    BuyseTest.options(order.Hprojection = 1)

    e.BT_tte1 <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1),
                           data = dt, trace = 0, 
                           keep.pairScore = TRUE,
                           method.inference = "u-statistic")
    e.BT_tte1.bis <- BuyseTest(treatment2 ~ tte(eventtime, status, threshold = 1),
                               data = dt, trace = 0, 
                               keep.pairScore = TRUE,
                               method.inference = "u-statistic")
        
    e.BT_tte2 <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1e5) + tte(eventtime, status, threshold = 1-1e-5),
                           data = dt, trace = 0, 
                           keep.pairScore = TRUE,
                           method.inference = "u-statistic")

    e.BT_tte3 <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1) + tte(eventtime, status, threshold = 1-1e-5),
                           data = dt, trace = 0,
                           keep.pairScore = TRUE,
                           method.inference = "u-statistic")

    e.BT_tte4 <- BuyseTest(treatment ~ bin(X0) + tte(eventtime, status, threshold = 1),
                           data = dt, trace = 0, 
                           keep.pairScore = TRUE,
                           method.inference = "u-statistic")

    e.BT_tte5 <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 2) + bin(X0) + tte(eventtime, status, threshold = 1),
                           data = dt, trace = 0, 
                           keep.pairScore = TRUE,
                           method.inference = "u-statistic")
    e.BT_tte5.bis <- BuyseTest(treatment2 ~ tte(eventtime, status, threshold = 2) + bin(X0) + tte(eventtime, status, threshold = 1),
                               data = dt, trace = 0, 
                               keep.pairScore = TRUE,
                               method.inference = "u-statistic")

    ## unchanged when switching around the groups
    expect_equal(e.BT_tte1@count.unfavorable,e.BT_tte1.bis@count.favorable)
    expect_equal(e.BT_tte1@covariance["unfavorable"],e.BT_tte1.bis@covariance["favorable"])

    expect_equal(e.BT_tte5@count.unfavorable,e.BT_tte5.bis@count.favorable)
    expect_equal(e.BT_tte5@covariance["unfavorable"],e.BT_tte5.bis@covariance["favorable"])

    ## results does not depend on previously used thresholds
    expect_equal(confint(e.BT_tte1)[1,],
                 confint(e.BT_tte2)[2,],
                 tol = 1e-6)
    expect_equal(confint(e.BT_tte1)[1,],
                 confint(e.BT_tte3)[1,],
                 tol = 1e-6)
    expect_equal(confint(e.BT_tte2)[2,],
                 confint(e.BT_tte3)[2,],
                 tol = 1e-6)
    expect_equal(confint(e.BT_tte3)[1,],
                 confint(e.BT_tte3)[2,],
                 tol = 1e-6)
    expect_equal(confint(e.BT_tte1)[1,],
                 confint(e.BT_tte4)[2,],
                 tol = 1e-6)
    expect_equal(confint(e.BT_tte1)[1,],
                 confint(e.BT_tte5)[3,],
                 tol = 1e-6)
    
})


## ** 1 TTE variable and 1 binary
n <- 5
set.seed(10)
dt <- simBuyseTest(n, argsTTE = list(scale.T = 2, scale.Censoring.T = 1))
## data.table("treatment" = c("C", "C", "C", "C", "C", "T", "T", "T", "T", "T"), 
##            "eventtime" = c(0.60539304, 0.98681219, 0.03946623, 1.28589957, 1.57044952, 0.29069131, 0.19522131, 0.04640668, 0.21109340, 0.69214123), 
##            "status" = c(0, 0, 0, 1, 0, 0, 0, 0, 1, 0), 
##            "toxicity" = c("yes", "yes", "yes", "yes", "yes", "no", "yes", "yes", "yes", "yes"), 
##            "score" = c(-1.85374045, -0.07794607,  0.96856634,  0.18492596, -1.37994358,  1.10177950,  0.75578151, -0.23823356,  0.98744470,  0.74139013))

test_that("iid with nuisance parameters: 1 TTE + 1 binary",{
    BuyseTest.options(order.Hprojection = 1)

    e.BT_ttebin <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1) + bin(toxicity),
                             data = dt, 
                             keep.pairScore = TRUE,
                             method.inference = "u-statistic")

    test <- confint(e.BT_ttebin)
    attr(test,"n.resampling") <- NULL
    GS <- matrix(c(-0.33333333, -0.13333333, 0.24130536, 0.36004622, -0.70573842, -0.69241599, 0.18339631, 0.52579681, 0.20172157, 0.7144262), 
                 nrow = 2, 
                 ncol = 5, 
                 dimnames = list(c("eventtime_1", "toxicity_0.5"),c("estimate", "se", "lower.ci", "upper.ci", "p.value")) 
                 ) 
    expect_equal(test, GS, tol = 1e-6)

    ## exponential approximation of the survival when computing the influence function
    e.TTEM <- BuyseTTEM(Hist(eventtime,status)~treatment, data = dt, iid=TRUE, iid.surv="prodlim")
    attr(e.TTEM, "iidNuisance") <- TRUE
    
    e.BT_ttebin <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1) + bin(toxicity),
                             data = dt, 
                             keep.pairScore = TRUE,
                             model.tte = e.TTEM,
                             method.inference = "u-statistic")

    test <- confint(e.BT_ttebin)
    attr(test,"n.resampling") <- NULL
    GS <- matrix(c(-0.33333333, -0.13333333, 0.23587679, 0.35518499, -0.69967949, -0.68733243, 0.17180423, 0.51874253, 0.19153767, 0.71069249), 
                 nrow = 2, 
                 ncol = 5, 
                 dimnames = list(c("eventtime_1", "toxicity_0.5"),c("estimate", "se", "lower.ci", "upper.ci", "p.value")) 
                 ) 
    expect_equal(test, GS, tol = 1e-6)

    ## GS <- BuyseTest(treatment ~ tte(eventtime, status, threshold = 1) + bin(toxicity),
                    ## data = dt, 
                    ## keep.pairScore = TRUE,
                    ## method.inference = "bootstrap")
})

## ** 2 TTE variables
n.patients <- c(20,20)
set.seed(10)
dt.sim <- simBuyseTest(n.T = n.patients[1],
                       n.C = n.patients[2],
                       argsBin = list(p.T = list(c(0.5,0.5),c(0.25,0.75))),
                       argsCont = list(mu.T = 1:3, sigma.T = rep(1,3)),
                       argsTTE = list(scale.T = 1:3, scale.Censoring.T = rep(1,3)))
setkeyv(dt.sim,c("treatment","eventtime1"))
## dt.sim[,status1.bis := c(status1[1:(.N-1)],1),by="treatment"] ## make sure last observation is a case

test_that("iid with nuisance parameters: 2 TTE",{


    ## plot(prodlim(Hist(eventtime1,status1.bis) ~ treatment, data = dt.sim))
    e.BT_tte1 <- BuyseTest(treatment ~ tte(eventtime2, status2, threshold = 1),
                           data = dt.sim, 
                           method.inference = "u-statistic")
    ## e.BT_tte2 <- BuyseTest(treatment ~ tte(eventtime1, status1.bis, threshold = 1e5) + tte(eventtime2, status2, threshold = 1),
                           ## data = dt.sim, 
                           ## method.inference = "u-statistic")
    e.BT_tte3 <- BuyseTest(treatment ~ tte(eventtime1, status1, threshold = 1e5) + tte(eventtime2, status2, threshold = 1),
                           data = dt.sim, 
                           method.inference = "u-statistic")

    expect_equal(e.BT_tte1@count.favorable[1], e.BT_tte3@count.favorable[2])
    expect_equal(e.BT_tte1@count.unfavorable[1], e.BT_tte3@count.unfavorable[2])
    expect_equal(e.BT_tte1@count.neutral[1], e.BT_tte3@count.neutral[2])
    expect_equal(e.BT_tte1@count.uninf[1], e.BT_tte3@count.uninf[2])

    ## expect_equal(e.BT_tte1@covariance[1,],e.BT_tte3@covariance[2,], tol = 1e-6)

    e.BT_tte <- BuyseTest(treatment ~ tte(eventtime1, status1, threshold = 1) + tte(eventtime2, status2, threshold = 1) + bin(toxicity1),
                          data = dt.sim,
                          method.inference = "u-statistic")
    test <- confint(e.BT_tte)
    attr(test,"n.resampling") <- NULL
    GS <- matrix(c(0.26401345, 0.179801, 0.00853608, 0.19937703, 0.2148585, 0.2408939, -0.14852611, -0.24811831, -0.43304747, 0.59828277, 0.54900838, 0.4468153, 0.20703017, 0.41296871, 0.97173422), 
                 nrow = 3, 
                 ncol = 5, 
                 dimnames = list(c("eventtime1_1", "eventtime2_1", "toxicity1_0.5"),c("estimate", "se", "lower.ci", "upper.ci", "p.value")) 
                 ) 

    expect_equal(test, GS, tol = 1e-3)

    ## exponential approximation of the survival when computing the influence function
    e.TTEM <- list(BuyseTTEM(Hist(eventtime1,status1)~treatment, data = dt.sim, iid=TRUE, iid.surv="prodlim"),
                   BuyseTTEM(Hist(eventtime2,status2)~treatment, data = dt.sim, iid=TRUE, iid.surv="prodlim"))
    attr(e.TTEM, "iidNuisance") <- TRUE

    e.BT_tte <- BuyseTest(treatment ~ tte(eventtime1, status1, threshold = 1) + tte(eventtime2, status2, threshold = 1) + bin(toxicity1),
                          data = dt.sim,
                          model.tte = e.TTEM,
                          method.inference = "u-statistic")
    test <- confint(e.BT_tte)
    attr(test,"n.resampling") <- NULL
    GS <- matrix(c(0.26401345, 0.179801, 0.00853608, 0.17433724, 0.19140473, 0.21888023, -0.09657678, -0.20304112, -0.39734512, 0.5633411, 0.51495999, 0.41162398, 0.14902033, 0.35809689, 0.96889279), 
                 nrow = 3, 
                 ncol = 5, 
                 dimnames = list(c("eventtime1_1", "eventtime2_1", "toxicity1_0.5"),c("estimate", "se", "lower.ci", "upper.ci", "p.value")) 
                 ) 

    expect_equal(test, GS, tol = 1e-3)
})

## * normalization iid
n <- 200
set.seed(10)
dt <- simBuyseTest(n, n.strata = 3)

test_that("iid - remove normalization", {

    e.all <- BuyseTest(treatment~bin(toxicity)+cont(score)+strata,
                       method.inference = "u-statistic",
                       data = dt, trace = 0)
    
    e.strata <- BuyseTest(treatment~bin(toxicity)+cont(score)+strata,
                          method.inference = "u-statistic",
                          data = dt[strata=="a"], trace = 0)

    iid.all <- getIid(e.all, normalize = FALSE)[which(dt$strata=="a"),]
    iid.strata <- as.double(getIid(e.strata, normalize = FALSE))

    expect_equal(unname(iid.all),unname(iid.strata), tol = 1e-9)
})

######################################################################
### test-BuyseTest-iid.R ends here
