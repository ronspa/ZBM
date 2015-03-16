(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: BULib
 * File: BULib.fun
 * Author: ronspa
 * Created: September 29, 2014
 ********************************************************************
 * Functions and function blocks of library BULib
 ********************************************************************)

FUNCTION ElevatorCil : BOOL
	VAR_INPUT
		ThisBU : BunchUnit;
		bUp : BOOL;
		bMid : BOOL;
		bDown : BOOL;
	END_VAR
	VAR
		bElevatorUp_SR : SR;
		bElevatorMid_SR : SR;
		bElevatorDown_SR : SR;
	END_VAR
END_FUNCTION

FUNCTION DefaultSettingsBU : BOOL
	VAR_INPUT
		ThisBU : BunchUnit;
		iHS : USINT;
		iMPD2UL : INT;
		iRP : INT;
		iRlP : INT;
		iSPD : USINT;
		iFSPD : USINT;
		tiDD : TIME;
		tiDRD : TIME;
		uiNCD : UINT;
		iSEPStart : INT := 92;
		iSEPStartVak : INT := 246;
		iSEPEndVak : INT := 443;
		iSEPEnd : INT := 530;
		tiBBP : TIME;
	END_VAR
END_FUNCTION

FUNCTION Elevator : BOOL (*Operate Lift*) (*$GROUP=User*)
	VAR_INPUT
		ThisBU : BunchUnit;
		bElevator : DINT;
	END_VAR
END_FUNCTION

FUNCTION CheckTimers : BU_Status_enum
	VAR_INPUT
		ThisBU : BunchUnit;
		Status : BU_Status_enum;
	END_VAR
	VAR
		tonElevator : TON;
	END_VAR
END_FUNCTION
