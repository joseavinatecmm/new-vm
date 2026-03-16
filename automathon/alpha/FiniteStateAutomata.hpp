#ifndef FINITE_STATE_AUTOMATA_HPP
#define FINITE_STATE_AUTOMATA_HPP

#include <string>
#include "RegularExpression.hpp"

class FiniteStateAutomata {
private:
    int currentState;
    int initialState;
    int acceptState;

    RegularExpression* expression;

public:
    FiniteStateAutomata(RegularExpression* expr);
    ~FiniteStateAutomata();

    void reset();
    bool transition(char symbol);
    bool process(const std::string& input);
    bool isAcceptingState() const;

    int getCurrentState() const;
};

#endif