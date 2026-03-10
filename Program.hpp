
#ifndef PROGRAM_HPP
#define PROGRAM_HPP

#include "Instruction.hpp"
#include <string>

class Program 
{
	public:
		Instruction instructions[10];
		Program();
		void addInstruction(Instruction theInstruction, int position);
		Instruction getInstruction(int position);
};

#endif
