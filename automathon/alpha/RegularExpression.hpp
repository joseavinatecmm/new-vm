#ifndef REGULAR_EXPRESSION_HPP
#define REGULAR_EXPRESSION_HPP

#include "Pattern.hpp"
#include <string>

class RegularExpression {
protected:
    Pattern* pattern;

public:
    RegularExpression(Pattern* p);
    virtual ~RegularExpression();

    Pattern* getPattern() const;

    virtual bool isValid(const std::string& input) const = 0;
};

#endif