(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Package: Servo
 * File: ServoReset.st
 * Author: ronspa
 * Created: January 27, 2015
 *******************************************************************)


FUNCTION ServoReset 
	(* Insert code here *)
	//ThisBU.
	IF ThisBU.typServo.bOnLine THEN
		ThisBU.typServo.enumServoCmd := SERVO_CMD_RESET;
		ServoReset := TRUE;
	ELSE
		ServoReset := FALSE;
	END_IF	
END_FUNCTION

