(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: PulsGen
 * File: PulsGen.fun
 * Author: jorkes
 * Created: July 18, 2014
 ********************************************************************
 * Functions and function blocks of library PulsGen
 ********************************************************************)

FUNCTION_BLOCK fbTriggerBuf
	VAR_INPUT
		CamPos : INT;
		reset : BOOL;
		trigger : BOOL;
		tiPuls : TIME;
		tiDelay : TIME;
		tiExtraLight : TIME;
	END_VAR
	VAR_OUTPUT
		outLight : BOOL;
		outCam : BOOL;
	END_VAR
	VAR
		tpPulsLight : TP;
		tpPulsCam : TP;
		tiOffset : TIME := T#30ms;
		tiActual : TIME;
		tiTime : TIME;
		tiStart : ARRAY[0..1] OF TIME;
		idx_1 : USINT;
		idx : USINT;
		idx_0 : USINT;
		zzEdge00000 : BOOL;
		zzEdge00001 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK PulsGenerator
	VAR_INPUT
		tInit : BOOL;
		enable : BOOL;
		sysTim : DINT;
		tiHigh : TIME;
		tiLow : TIME;
	END_VAR
	VAR_OUTPUT
		bOutput : BOOL := FALSE;
	END_VAR
	VAR
		counter : USINT;
		time : DINT;
		state : USINT := 0;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK
