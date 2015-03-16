(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Serial
 * File: Serial.fun
 * Author: jorkes
 * Created: November 26, 2014
 ********************************************************************
 * Functions and function blocks of library Serial
 ********************************************************************)

FUNCTION_BLOCK fbSerial
	VAR_INPUT
		enable : BOOL := TRUE;
		text : STRING[80];
	END_VAR
	VAR CONSTANT
		BUSY : UINT := 65535; (*Functionblock BUSY status*)
	END_VAR
	VAR
		Sender : Sender_typ := (0); (*Structure with all instances and variables*)
	END_VAR
END_FUNCTION_BLOCK
