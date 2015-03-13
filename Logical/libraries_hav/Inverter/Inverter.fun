(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Invertor
 * File: Invertor.fun
 * Author: daaneh
 * Created: March 15, 2011
 ********************************************************************
 * Functions and function blocks of library Invertor
 ********************************************************************)

FUNCTION_BLOCK ACPinverter (*TODO: Add your comment here*)
	VAR_INPUT
		bRun : BOOL;
		bRunReverse : BOOL;
		bResetFault : BOOL;
		iSpeed : INT;
	END_VAR
	VAR_OUTPUT
		InverterState_ : enumINV_ST;
	END_VAR
	VAR_IN_OUT
		MotorStruc : AcpInverter_typ;
	END_VAR
	VAR
		tonTimeOut : TON;
		_InverterCommand : enumINV_CMD;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK
