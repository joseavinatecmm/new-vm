#ifndef ALPHABETIC_EXPRESSION_HPP
#define ALPHABETIC_EXPRESSION_HPP

#include "RegularExpression.hpp"

class AlphabeticExpression : public RegularExpression {
public:
    AlphabeticExpression(Pattern* p);
    virtual ~AlphabeticExpression();

    virtual bool isValid(const std::string& input) const override;
    virtual bool isAcceptedSymbol(char symbol) const override;
};

#endif
