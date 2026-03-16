#include "CU.hpp"
#include "ADD.hpp"


CU::CU()
{
	status = "idle";
}

CU::CU(string theStatus)
{
	status = theStatus;
}

Instruction CU::fetch(Program theProgram, int thePosition)
{
	return theProgram.getInstruction(thePosition);
}

int CU::decode(Instruction* theInstruction)
{

	return theInstruction->getCode();
}

void CU::execute(int theCode)
{

	switch (theCode) {
		
		case 50:
			cout << "Inicio del programa" << endl;
			break;

		case 51:
			cout << "Fin de ejecucion del programa" << endl;
			break;

		case 80:
			cout << "Sumar" << endl;
			break;

		default:
			break;
	}
 }

