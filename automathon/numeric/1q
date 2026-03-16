#include <iostream>
#include <string>
#include "FiniteStateAutomata.hpp"
#include "AlphabeticExpression.hpp"
#include "NumericExpression.hpp"
#include "Pattern.hpp"

int main() {
    int option = 0;
    std::string input;

    do {
        std::cout << "==========================================\n";
        std::cout << " Deterministic Finite State Automata (FSA)\n";
        std::cout << " 1. Validate alphabetic string [A-Za-z]+\n";
        std::cout << " 2. Validate numeric string [0-9]+\n";
        std::cout << " 3. Exit\n";
        std::cout << "==========================================\n";
        std::cout << "Choose an option: ";
        std::cin >> option;
        std::cin.ignore();

        if (option == 1) {
            Pattern* pattern = new Pattern("[A-Za-z]+");
            RegularExpression* expression = new AlphabeticExpression(pattern);
            FiniteStateAutomata* automata = new FiniteStateAutomata(expression);

            std::cout << "Enter an alphabetic string: ";
            std::getline(std::cin, input);

            if (automata->process(input)) {
                std::cout << "Result: ACCEPTED\n";
            } else {
                std::cout << "Result: REJECTED\n";
            }

            std::cout << "Final state: q" << automata->getCurrentState() << "\n\n";
            delete automata;
        }
        else if (option == 2) {
            Pattern* pattern = new Pattern("[0-9]+");
            RegularExpression* expression = new NumericExpression(pattern);
            FiniteStateAutomata* automata = new FiniteStateAutomata(expression);

            std::cout << "Enter a numeric string: ";
            std::getline(std::cin, input);

            if (automata->process(input)) {
                std::cout << "Result: ACCEPTED\n";
            } else {
                std::cout << "Result: REJECTED\n";
            }

            std::cout << "Final state: q" << automata->getCurrentState() << "\n\n";
            delete automata;
        }
        else if (option != 3) {
            std::cout << "Invalid option.\n\n";
        }

    } while (option != 3);

    std::cout << "Program finished.\n";
    return 0;
}
