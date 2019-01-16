
rm(list=ls())

# chemins vers les deux versions de BuyseTest
path.1.1="C:/Prog/R-3.1.0/library"
path.1.0="C:/Prog/R/R-3.2.5/library"


# data avec 6 patients donc 9 paires
dat=data.frame(
	ttt=c(rep(0,3),rep(1,3)),
	timeOS = c(10,20,30,15,20,35),
	eventOS= c(1,1,0,0,1,1),
	moins.grade.tox = -c(1,2,3,2,4,2))

# test v 1.0
library("BuyseTest",lib.loc=path.1.0)
packageVersion("BuyseTest")

res.1.0 = BuyseTest(
	data=dat,
	endpoint=c("timeOS","moins.grade.tox"),
	treatment="ttt",
	strata=NULL,
	type=c("timeToEvent","continuous"),
	censoring=c("eventOS",NA),
	threshold=c(0,0),
	n.bootstrap=0,
	method="Peron",
	cpus="all")
	
res.1.0	

# detache v 1.0
detach("package:BuyseTest", unload=TRUE)

# test v 1.1 neutralAsUninf=TRUE
library("BuyseTest",lib.loc=path.1.1)
packageVersion("BuyseTest")

res.1.1.nauTRUE=BuyseTest(
	data=dat,
	formula=ttt~TTE(timeOS,threshold=0,censoring=eventOS) + cont(moins.grade.tox,threshold=0),
	n.bootstrap=0,
	method="Peron",
	cpus="all",
	neutralAsUninf=TRUE)

res.1.1.nauTRUE	

# test v 1.1 neutralAsUninf=FALSE
res.1.1.nauFALSE=BuyseTest(
	data=dat,
	formula=ttt~TTE(timeOS,threshold=0,censoring=eventOS) + cont(moins.grade.tox,threshold=0),
	n.bootstrap=0,
	method="Peron",
	cpus="all",
	neutralAsUninf=FALSE)

res.1.1.nauFALSE











