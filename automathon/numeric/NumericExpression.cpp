#include "NumericExpression.hpp"
#include <cctype>

NumericExpression::NumericExpression(Pattern* p)
    : RegularExpression(p) {
}

NumericExpression::~NumericExpression() {
}

bool NumericExpression::isValid(const std::string& input) const {
    if (input.empty()) {
        return false;
    }

    for (char c : input) {
        if (!std::isdigit(static_cast<unsigned char>(c))) {
            return false;
        }
    }

    return true;
}

bool NumericExpression::isAcceptedSymbol(char symbol) const {
    return std::isdigit(static_cast<unsigned char>(symbol)) != 0;
}
