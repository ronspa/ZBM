(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: BeltControl
 * File: BeltControl.typ
 * Author: jorkes
 * Created: November 28, 2014
 ********************************************************************
 * Local data types of program BeltControl
 ********************************************************************)

TYPE
	InterfaceMBU : 	STRUCT 
		bEnabled : BOOL; (*Enable MBU*)
	END_STRUCT;
	MainBeltControl : 	STRUCT 
		typeInterface : InterfaceMBU;
	END_STRUCT;
END_TYPE
