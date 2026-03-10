#ifndef INSTRUCTIONSET_HPP
#define INSTRUCTIONSET_HPP

#include "Instruction.hpp"

using namespace std;

class InstructionSet
{
	private:
		Instruction set[10];
		short int index;
	
	public:
		InstructionSet();
		void addInstruction(Instruction theInstruction);
		Instruction getInstruction(short int pos);
};

#endif








