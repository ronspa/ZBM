(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Chain
 * File: Chain.fun
 * Author: jorkes
 * Created: November 18, 2014
 ********************************************************************
 * Functions and function blocks of library Chain
 ********************************************************************)

FUNCTION_BLOCK fbAverage
	VAR_INPUT
		enable : BOOL;
		index : USINT;
		tiMeasure : TIME;
	END_VAR
	VAR_OUTPUT
		tiAverage : TIME;
	END_VAR
	VAR
		_tiMusecDiff1 : ARRAY[0..9] OF TIME;
		idx : USINT := 0;
		size : USINT := 0;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION fbChainlength : REAL
	VAR_INPUT
		ThisSHIFTREG : Shiftregister;
	END_VAR
END_FUNCTION

FUNCTION fbGripperSpeed : REAL
	VAR_INPUT
		ThisSHIFTREG : Shiftregister;
	END_VAR
END_FUNCTION

FUNCTION fbEncoderDistance : REAL
	VAR_INPUT
		ThisSHIFTREG : Shiftregister;
	END_VAR
END_FUNCTION

FUNCTION fbGripperDistance : REAL
	VAR_INPUT
		ThisSHIFTREG : Shiftregister;
	END_VAR
END_FUNCTION

FUNCTION fbEncoderBetween : TIME
	VAR_INPUT
		ThisSHIFTREG : Shiftregister;
		tiBetween : TIME;
	END_VAR
END_FUNCTION

FUNCTION fbResetGripper : BOOL
	VAR_INPUT
		ThisGripper : _gripper;
	END_VAR
END_FUNCTION
