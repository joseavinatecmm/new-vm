#include "Program.hpp"

Program::Program(){}

void Program::addInstruction(Instruction theInstruction, int thePosition)
{
	instructions[thePosition] = theInstruction;
}

Instruction Program::getInstruction(int thePosition)
{
	return instructions[thePosition];

}

