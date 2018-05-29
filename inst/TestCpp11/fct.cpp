#include <Rcpp.h>

// Enable C++11 via this plugin (Rcpp 0.10.3 or later)
// [[Rcpp::plugins(cpp11)]]

// [[Rcpp::export]]

std::vector<std::string> useInitLists() {
    std::vector<std::string> vec = {"larry", "curly", "moe"};
    return vec;
}
