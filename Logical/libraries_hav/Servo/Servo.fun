(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Servo
 * File: Servo.fun
 * Author: jorkes
 * Created: October 30, 2014
 ********************************************************************
 * Functions and function blocks of library Servo
 ********************************************************************)

FUNCTION ServoMovePosition : BOOL
	VAR_INPUT
		ThisBU : BunchUnit;
		NewPosition : INT;
		Speed : USINT;
	END_VAR
END_FUNCTION

FUNCTION ServoReset : BOOL
	VAR_INPUT
		ThisBU : BunchUnit;
	END_VAR
END_FUNCTION

FUNCTION ServoHome : BOOL
	VAR_INPUT
		ThisBU : BunchUnit;
	END_VAR
END_FUNCTION
