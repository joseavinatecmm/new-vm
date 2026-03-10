#include "Instruction.hpp"

#ifndef MOV_HPP
#define MOV_HPP
#include <string>

using namespace std;

class MOV: public Instruction
{
	private:
		string regist;
		string address;
		int value;
	public:
		MOV();
		MOV(string name, short int code,short int length, string theRegister, string theAddress);
		MOV(string name, int theValue, string theRegister);
		int getValue();
		void display();
};

#endif


