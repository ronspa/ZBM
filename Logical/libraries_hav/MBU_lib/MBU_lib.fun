(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: MBU_lib
 * File: MBU_lib.fun 
 * Author: jorkes
 * Created: December 01, 2014
 ********************************************************************
 * Functions and function blocks of library MBU_lib
 ********************************************************************)

FUNCTION fbShiftBelt : BOOL
	VAR_INPUT
		ThisMBU : MainbeltUnit;
		enable : BOOL;
	END_VAR
	VAR
		idx : USINT;
		size : USINT;
		overflow : UDINT;
	END_VAR
END_FUNCTION

FUNCTION fbCheckBUReadyForDrop : BOOL
	VAR_INPUT
		BU : ARRAY[0..9] OF BunchUnit;
		size : USINT;
	END_VAR
	VAR
		idx : USINT;
		sum : USINT;
	END_VAR
END_FUNCTION

FUNCTION fbCheckBelt : BOOL
	VAR_INPUT
		ThisMBU : MainbeltUnit;
	END_VAR
	VAR
		idx : USINT;
		sum : USINT;
		size : USINT;
	END_VAR
END_FUNCTION

FUNCTION fbHasFlowersOnIndex : BOOL
	VAR_INPUT
		ThisMBU : MainbeltUnit;
		idx : USINT;
	END_VAR
	VAR
		uiMask : UDINT;
		uiOut : UDINT;
	END_VAR
END_FUNCTION

FUNCTION fbSetFlowersOnIndex : BOOL
	VAR_INPUT
		ThisMBU : MainbeltUnit;
		idx : USINT;
		bHasFlower : BOOL;
	END_VAR
	VAR
		uiMask : USINT;
		uiOut : USINT;
	END_VAR
END_FUNCTION
