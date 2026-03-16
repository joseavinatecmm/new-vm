#include "RegularExpression.hpp"

RegularExpression::RegularExpression(Pattern* p) {
    pattern = p;
}

RegularExpression::~RegularExpression() {
    delete pattern;
    pattern = nullptr;
}

Pattern* RegularExpression::getPattern() const {
    return pattern;
}
