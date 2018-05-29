### run.R --- 
##----------------------------------------------------------------------
## Author: Brice Ozenne
## Created: apr 17 2018 (16:24) 
## Version: 
## Last-Updated: apr 17 2018 (16:31) 
##           By: Brice Ozenne
##     Update #: 5
##----------------------------------------------------------------------
## 
### Commentary: 
## 
### Change Log:
##----------------------------------------------------------------------
## 
### Code:

path <- "c:/Users/hpl802/Documents/GitHub/BuyseTest/inst/TestCpp11" ## change path here
setwd(path)

## source function
sourceCpp("fct.cpp")

## run function
useInitLists() ## output: "larry" "curly" "moe"

args(install.packages)
install.packages(pkgs = file.path(path,"BuyseTest_1.2.3.zip"),
                 repos = NULL,
                 type = "source")

######################################################################
### run.R ends here
