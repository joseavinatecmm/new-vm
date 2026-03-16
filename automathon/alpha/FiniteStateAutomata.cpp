#include "FiniteStateAutomata.hpp"
#include <cctype>

FiniteStateAutomata::FiniteStateAutomata(RegularExpression* expr) {
    initialState = 0;
    acceptState = 1;
    currentState = initialState;
    expression = expr;
}

FiniteStateAutomata::~FiniteStateAutomata() {
    delete expression;
    expression = nullptr;
}

void FiniteStateAutomata::reset() {
    currentState = initialState;
}

bool FiniteStateAutomata::transition(char symbol) {
    switch (currentState) {
        case 0:
            if (std::isalpha(static_cast<unsigned char>(symbol))) {
                currentState = 1;
                return true;
            }
            return false;

        case 1:
            if (std::isalpha(static_cast<unsigned char>(symbol))) {
                currentState = 1;
                return true;
            }
            return false;

        default:
            return false;
    }
}

bool FiniteStateAutomata::process(const std::string& input) {
    reset();

    if (input.empty()) {
        return false;
    }

    for (size_t i = 0; i < input.length(); i++) {
        if (!transition(input[i])) {
            return false;
        }
    }

    return isAcceptingState() && expression->isValid(input);
}

bool FiniteStateAutomata::isAcceptingState() const {
    return currentState == acceptState;
}

int FiniteStateAutomata::getCurrentState() const {
    return currentState;
}