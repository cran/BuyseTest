### BuyseTest-check.R --- 
##----------------------------------------------------------------------
## Author: Brice Ozenne
## Created: apr 27 2018 (23:32) 
## Version: 
## Last-Updated: maj 23 2018 (12:25) 
##           By: Brice Ozenne
##     Update #: 60
##----------------------------------------------------------------------
## 
### Commentary: 
## 
### Change Log:
##----------------------------------------------------------------------
## 
### Code:

## * testArgs
##' @title Check Arguments Passed to BuyseTest
##' @description Check the validity of the argument passed the BuyseTest function by the user.
##'
##' @keywords internal
testArgs <- function(alternative,
                     name.call,
                     censoring,
                     correction.tte,
                     cpus,
                     data,
                     endpoint,
                     formula,
                     keep.comparison,
                     method.tte,
                     method.inference,
                     n.resampling,
                     neutral.as.uninf,
                     operator,
                     seed,
                     strata,
                     threshold,
                     trace,
                     treatment,
                     type,
                     ...){

    ## ** data
    if (!data.table::is.data.table(data)) {
        if(inherits(data,"function")){
            stop("Argument \'data\' is mispecified \n",
                 "\'data\' cannot be a function \n")
        }
        data <- data.table::as.data.table(data)
    }else{
        data <- data.table::copy(data)
    }

    ## ** extract usefull quantities
    argnames <- c("treatment", "endpoint", "type", "threshold", "censoring", "strata")

    D <- length(endpoint) 
    D.TTE <- sum(type == 3) # number of time to event endpoints
    level.treatment <- levels(as.factor(data[[treatment]])) 
    if(is.null(strata)){
        n.strata <- 1
    }else{
        indexT <- which(data[[treatment]] == level.treatment[2])
        indexC <- which(data[[treatment]] == level.treatment[1])

        strataT <- interaction(data[indexT,strata,with=FALSE], drop = TRUE, lex.order=FALSE,sep=".") 
        strataC <- interaction(data[indexC,strata,with=FALSE], drop = TRUE, lex.order=FALSE,sep=".") 
        level.strata <- levels(strataT)
        n.strata <- length(level.strata)
    }

    
    ## ** alternative
    validCharacter(alternative,
                   valid.length = 1,
                   valid.values = c("two.sided", "less", "greater"),
                   method = "BuyseTest")

    ## ** censoring
    if(D.TTE==0){
        if(!is.null(censoring)){
            stop("BuyseTest : \'censoring\' must be NULL when there are no TTE endpoints \n",
                 "propose value : ",paste(censoring,collapse=" "),"\n")
        }
        
    }else{
        
        
        if(length(censoring) != D.TTE){
            stop("BuyseTest : \'censoring\' does not match \'endpoint\' size \n",
                 "length(censoring) : ",length(censoring),"\n",
                 "length(endpoint) : ",D,"\n")
            
        }

        if(any(is.na(censoring)) ){
            stop("BuyseTest : wrong specification of \'censoring\' \n",
                 "\'censoring\' must indicate a variable in data for TTE endpoints \n",
                 "TTE endoints : ",paste(endpoint[type==3],collapse=" "),"\n",
                 "proposed \'censoring\' for these endoints : ",paste(censoring,collapse=" "),"\n")
        }
        
    }

    ## ** cpus
    if(cpus>1){
        validInteger(cpus,
                     valid.length = 1,
                     valid.values = 1:parallel::detectCores(),
                     method = "BuyseTest")
    }

    ## ** data (endpoints)
    ## *** binary endpoints
    index.Bin <- which(type==1)
    if(length(index.Bin)>0){
        for(iBin in index.Bin){ ## iterY <- 1
            if(length(unique(na.omit(data[[endpoint[iBin]]])))>2){
                stop("Binary endpoint cannot have more than 2 levels \n",
                     "endpoint: ",endpoint[iBin],"\n")
            }
            if(any(is.na(data[[endpoint[iBin]]]))){                
                warning("BuyseTest : endpoint ",endpoint[iBin]," contains NA \n")
            }
        }
    }

    ## *** continuous endpoints
    index.Cont <- which(type==2)
    if(length(index.Cont)>0){
        for(iCont in index.Cont){
            validNumeric(data[[endpoint[iCont]]],
                         name1 = endpoint[iCont],
                         valid.length = NULL,
                         refuse.NA =  FALSE,
                         method = "BuyseTest")

            if(any(is.na(data[[endpoint[iCont]]]))){                
                warning("BuyseTest : endpoint ",endpoint[iCont]," contains NA \n")
            }
        }
    }

    ## *** time to event endpoint
    index.TTE <- which(type==3)
    if(length(index.TTE)>0){
        validNames(data,
                   name1 = "data",
                   required.values = censoring,
                   valid.length = NULL,
                   refuse.NULL = FALSE,
                   method = "BuyseTest")

        for(iTTE in index.TTE){
            validNumeric(data[[endpoint[iTTE]]],
                         name1 = endpoint[iTTE],
                         valid.length = NULL,
                         refuse.NA = TRUE,
                         method = "BuyseTest")
            validNumeric(data[[censoring[which(index.TTE == iTTE)]]],
                         name1 = censoring[which(index.TTE == iTTE)],
                         valid.values = c(0,1),
                         valid.length = NULL,
                         method = "BuyseTest")
        }
    }

    ## ** endpoint
    validNames(data,
               required.values = endpoint,
               valid.length = NULL,
               method = "BuyseTest")

    ## ** formula
    if(!is.null(formula) && any(name.call %in% argnames)){
        txt <- paste(name.call[name.call %in% argnames], collapse = "\' \'")
        warning("BuyseTest : argument",if(length(txt)>1){"s"}," \'",txt,"\' ha",if(length(txt)>1){"ve"}else{"s"}," been ignored \n",
                "when specified, only argument \'formula\' is used \n")
    }

    ## ** keep.comparison
    validLogical(keep.comparison,
                 valid.length = 1,
                 method = "BuyseTest")
 
    ## ** method.tte
    if(is.na(method.tte)){
        stop("BuyseTest: wrong specification of \'method.tte\' \n",
             "valid values: \"Gehan\" \"Gehan corrected\" \"Peron\" \"Peron corrected\" \n")
    }

    ## ** correction.tte
    validLogical(correction.tte,
                 valid.length = 1,
                 method = "BuyseTest")

    ## ** method.inference
    validCharacter(method.inference,
                   valid.length = 1,
                   valid.values = c("none","asymptotic","bootstrap","permutation","stratified bootstrap","stratified permutation"),
                   method = "BuyseTest")

    ## ** n.resampling
    if(method.inference %in% c("bootstrap","permutation","stratified bootstrap","stratified permutation")){
        validInteger(n.resampling,
                     valid.length = 1,
                     min = 1,
                     method = "BuyseTest")
    }
    
    ## ** neutral.as.uninf
    validLogical(neutral.as.uninf,
                 valid.length = 1,
                 method = "BuyseTest")

    ## ** operator
    validCharacter(operator,
                   valid.values = c("<0",">0"),
                   valid.length = D,
                   method = "BuyseTest")

    n.operatorPerEndpoint <- tapply(operator, endpoint, function(x){length(unique(x))})
    if(any(n.operatorPerEndpoint>1)){
        stop("Cannot have different operator for the same endpoint used at different priorities \n")
    }

    ## ** seed
    validInteger(seed,
                 valid.length = 1,
                 refuse.NULL = FALSE,
                 min = 1,
                 method = "BuyseTest")


     ## ** strata
    if (!is.null(strata)) {
        validNames(data,
                   name1 = "strata",
                   required.values = strata,
                   valid.length = NULL,
                   method = "BuyseTest")

       
        if(length(level.strata) != length(levels(strataC)) || any(level.strata != levels(strataC))){
            stop("BuyseTest : wrong specification of \'strata\' \n",
                 "different levels between Control and Treatment \n",
                 "levels(strataT) : ",paste(levels(strataT),collapse=" "),"\n",
                 "levels(strataC) : ",paste(levels(strataC),collapse=" "),"\n")
        }
    
    }

    ## ** threshold
    ## check numeric and no NA
    validNumeric(threshold,
                 valid.length = D,
                 min = 0,
                 refuse.NA = TRUE,
                 method = "BuyseTest")

    ## check threshold at 1/2 for binary endpoints
    if(any(threshold[type==1]!=1/2)){
        stop("BuyseTest : wrong specification of \'threshold\' \n",
             "\'threshold\' must be 1/2 for binary endpoints (or equivalently NA) \n",
             "proposed \'threshold\' : ",paste(threshold[type==1],collapse=" "),"\n",
             "binary endpoint(s) : ",paste(endpoint[type==1],collapse=" "),"\n")
    }
    
    ## Check that the thresholds related to the same endoints are strictly decreasing
    ## is.unsorted(rev(2:1))
    ## is.unsorted(rev(1:2))

    vec.test <- tapply(threshold,endpoint, function(x){
        test.unsorted <- is.unsorted(rev(x))
        test.duplicated <- any(duplicated(x))
        return(test.unsorted+test.duplicated)
    })
    
    if(any(vec.test>0)){   
        stop("BuyseTest : wrong specification of \'endpoint\' or \'threshold\' \n",
             "endpoints must be used with strictly decreasing threshold when re-used with lower priority \n",
             "problematic endpoints: \"",paste0(names(vec.test)[vec.test>0], collapse = "\" \""),"\"\n")        
    }

    ## ** trace
    validInteger(trace,
                 valid.length = 1,
                 valid.values = 0:2,
                 method = "BuyseTest")

    ## ** treatment
    validCharacter(treatment,
                   valid.length = 1,
                   method = "BuyseTest")

    validNames(data,
               required.values = treatment,
               valid.length = NULL,
               method = "BuyseTest")

    if (length(level.treatment) != 2) {
        stop("BuyseTest : wrong specification of \'treatment\' \n",
             "the corresponding column in \'data\' must have exactly 2 levels \n",
             "proposed levels : ",paste(level.treatment,collapse = " "),"\n")
    }

    ## ** type
    if(any(type %in% 1:3 == FALSE)){
        txt <- type[type %in% 1:3 == FALSE]
        stop("BuyseTest: wrong specification of \'type\' \n",
             "valid values: \"binary\" \"continuous\" \"timetoevent\" \n",
             "incorrect values: \"",paste(txt, collapse = "\" \""),"\" \n")
    }
    
    n.typePerEndpoint <- tapply(type, endpoint, function(x){length(unique(x))})
    if(any(n.typePerEndpoint>1)){
        message <- paste0("several types have been specified for endpoint(s) ",
                          paste0(unique(endpoint)[n.typePerEndpoint>1],collapse = ""),
                          "\n")        
        stop("BuyseTest: wrong specification of \'endpoint\' or \'type\' \n",message)
    }
    
    ## ** export
    return(invisible(TRUE))
}



##----------------------------------------------------------------------
### BuyseTest-check.R ends here