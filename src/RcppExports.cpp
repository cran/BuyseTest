// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// GPC_cpp
List GPC_cpp(const arma::mat& Treatment, const arma::mat& Control, const NumericVector& threshold, const LogicalVector& survEndpoint, const arma::mat& delta_Treatment, const arma::mat& delta_Control, const int D, const bool returnIndex, const std::vector< arma::uvec >& strataT, const std::vector< arma::uvec >& strataC, const int n_strata, const int n_TTE, const arma::mat& Wscheme, const IntegerVector index_survivalM1, const NumericVector threshold_TTEM1, const std::vector< arma::mat >& list_survivalT, const std::vector< arma::mat >& list_survivalC, const int methodTTE, const bool correctionTTE, const bool neutralAsUninf, const bool keepComparison);
RcppExport SEXP _BuyseTest_GPC_cpp(SEXP TreatmentSEXP, SEXP ControlSEXP, SEXP thresholdSEXP, SEXP survEndpointSEXP, SEXP delta_TreatmentSEXP, SEXP delta_ControlSEXP, SEXP DSEXP, SEXP returnIndexSEXP, SEXP strataTSEXP, SEXP strataCSEXP, SEXP n_strataSEXP, SEXP n_TTESEXP, SEXP WschemeSEXP, SEXP index_survivalM1SEXP, SEXP threshold_TTEM1SEXP, SEXP list_survivalTSEXP, SEXP list_survivalCSEXP, SEXP methodTTESEXP, SEXP correctionTTESEXP, SEXP neutralAsUninfSEXP, SEXP keepComparisonSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type Treatment(TreatmentSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type Control(ControlSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type threshold(thresholdSEXP);
    Rcpp::traits::input_parameter< const LogicalVector& >::type survEndpoint(survEndpointSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type delta_Treatment(delta_TreatmentSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type delta_Control(delta_ControlSEXP);
    Rcpp::traits::input_parameter< const int >::type D(DSEXP);
    Rcpp::traits::input_parameter< const bool >::type returnIndex(returnIndexSEXP);
    Rcpp::traits::input_parameter< const std::vector< arma::uvec >& >::type strataT(strataTSEXP);
    Rcpp::traits::input_parameter< const std::vector< arma::uvec >& >::type strataC(strataCSEXP);
    Rcpp::traits::input_parameter< const int >::type n_strata(n_strataSEXP);
    Rcpp::traits::input_parameter< const int >::type n_TTE(n_TTESEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type Wscheme(WschemeSEXP);
    Rcpp::traits::input_parameter< const IntegerVector >::type index_survivalM1(index_survivalM1SEXP);
    Rcpp::traits::input_parameter< const NumericVector >::type threshold_TTEM1(threshold_TTEM1SEXP);
    Rcpp::traits::input_parameter< const std::vector< arma::mat >& >::type list_survivalT(list_survivalTSEXP);
    Rcpp::traits::input_parameter< const std::vector< arma::mat >& >::type list_survivalC(list_survivalCSEXP);
    Rcpp::traits::input_parameter< const int >::type methodTTE(methodTTESEXP);
    Rcpp::traits::input_parameter< const bool >::type correctionTTE(correctionTTESEXP);
    Rcpp::traits::input_parameter< const bool >::type neutralAsUninf(neutralAsUninfSEXP);
    Rcpp::traits::input_parameter< const bool >::type keepComparison(keepComparisonSEXP);
    rcpp_result_gen = Rcpp::wrap(GPC_cpp(Treatment, Control, threshold, survEndpoint, delta_Treatment, delta_Control, D, returnIndex, strataT, strataC, n_strata, n_TTE, Wscheme, index_survivalM1, threshold_TTEM1, list_survivalT, list_survivalC, methodTTE, correctionTTE, neutralAsUninf, keepComparison));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_BuyseTest_GPC_cpp", (DL_FUNC) &_BuyseTest_GPC_cpp, 21},
    {NULL, NULL, 0}
};

RcppExport void R_init_BuyseTest(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}