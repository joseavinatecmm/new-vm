#include "Pattern.hpp"

Pattern::Pattern(const std::string& p) {
    pattern = p;
}

Pattern::~Pattern() {
}

void Pattern::setPattern(const std::string& p) {
    pattern = p;
}

std::string Pattern::getPattern() const {
    return pattern;
}
