(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: SensContr
 * File: SensContr.fun
 * Author: jorkes
 * Created: December 01, 2014
 ********************************************************************
 * Functions and function blocks of library SensContr
 ********************************************************************)

FUNCTION_BLOCK fbSensControl
	VAR_INPUT
		IN : BOOL;
		tiSensDelay : TIME;
		tiSensPuls : TIME;
	END_VAR
	VAR_OUTPUT
		Q : BOOL;
	END_VAR
	VAR
		tiTreinDelay : TIME := T#50ms; (*2 x 50ms*)
		tpSensPuls_0 : TP;
		tpSensPuls_1 : TP;
		tpTreinPuls_0 : TP;
		tpTreinPuls_1 : TP;
		zzEdge00000 : BOOL;
		zzEdge00001 : BOOL;
		zzEdge00002 : BOOL;
		zzEdge00003 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK fbSensDelay
	VAR_INPUT
		IN : BOOL;
		tiSensDelay : TIME;
		tiSensPuls : TIME;
	END_VAR
	VAR_OUTPUT
		Q : BOOL;
	END_VAR
	VAR
		tpSensPuls_0 : TP;
		tpSensPuls_1 : TP;
		zzEdge00000 : BOOL;
		zzEdge00001 : BOOL;
	END_VAR
END_FUNCTION_BLOCK
