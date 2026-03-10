#ifndef CU_HPP
#define CU_HPP
#include <string>
#include <iostream>
#include "Instruction.hpp"
#include "ALU.hpp"
#include "ADD.hpp"
#include "Program.hpp"

using namespace std;
class CU 
{
	private:
		string status;

	public:
		CU();
		CU(string theStatus);
		Instruction fetch(Program theProgram, int thePosition);
		int decode(Instruction* theInstruction);
		void execute(int theCode);
};
#endif
