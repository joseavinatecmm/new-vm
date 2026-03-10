#include "InstructionSet.hpp"

InstructionSet::InstructionSet()
{
	index = 0;
}


void InstructionSet::addInstruction(Instruction theInstruction)
{
	set[index++] = theInstruction;
}


Instruction InstructionSet::getInstruction(short int pos)
{
	return set[pos];
}

