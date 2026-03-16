#include <iostream>
#include "FiniteStateAutomata.hpp"
#include "AlphabeticExpression.hpp"
#include "Pattern.hpp"

int main(int argc, char* argv[]) {

    Pattern* pattern = new Pattern("[A-Za-z]+");

    RegularExpression* regex =
        new AlphabeticExpression(pattern);

    FiniteStateAutomata* automata =
        new FiniteStateAutomata(regex);

    std::string input = argv[1];

    //std::cout << "Enter a string: ";
    std::cout << argv[0] << "\n";
    //std::getline(std::cin,input);

    if(automata->process(input))
        std::cout << "ACCEPTED\n";
    else
        std::cout << "REJECTED\n";

    delete automata;

    return 0;
}
