#include "AlphabeticExpression.hpp"
#include <cctype>

AlphabeticExpression::AlphabeticExpression(Pattern* p)
    : RegularExpression(p) {
}

AlphabeticExpression::~AlphabeticExpression() {
}

bool AlphabeticExpression::isValid(const std::string& input) const {
    if (input.empty()) {
        return false;
    }

    for (char c : input) {
        if (!std::isalpha(static_cast<unsigned char>(c))) {
            return false;
        }
    }

    return true;
}

bool AlphabeticExpression::isAcceptedSymbol(char symbol) const {
    return std::isalpha(static_cast<unsigned char>(symbol)) != 0;
}
