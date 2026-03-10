
#ifndef INSTRUCTION_HPP
#define INSTRUCTION_HPP

#include <string>

using namespace std;
class Instruction 
{
	private: 
		string name;
		short int code;
		short int length;
	public:
		Instruction();
		Instruction(string theName, short int theCode, short int theLength);
		void display();
		int getCode();
		string getName();
};
#endif










