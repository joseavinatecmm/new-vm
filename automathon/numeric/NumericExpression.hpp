#ifndef NUMERIC_EXPRESSION_HPP
#define NUMERIC_EXPRESSION_HPP

#include "RegularExpression.hpp"

class NumericExpression : public RegularExpression {
public:
    NumericExpression(Pattern* p);
    virtual ~NumericExpression();

    virtual bool isValid(const std::string& input) const override;
    virtual bool isAcceptedSymbol(char symbol) const override;
};

#endif
