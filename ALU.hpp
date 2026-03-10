#ifndef ALU_HPP
#define ALU_HPP

class ALU 
{
	private:
		short int operand1;
		short int operand2;

	public:
		ALU();
		ALU(short int theOperand1, short int theOperand2);
		short int add(short int theOperand1, short int theOperand2);
};

#endif

