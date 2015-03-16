(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Package: Servo
 * File: ServoHome.st
 * Author: ronspa
 * Created: January 27, 2015
 *******************************************************************)

FUNCTION ServoHome
	IF ThisBU.typServo.bOnLine THEN
		ThisBU.typServo.enumServoCmd := SERVO_CMD_HOME;
		ThisBU.typServo.command.PARA1.usVelocity := 10;
		ServoHome := TRUE;
	ELSE
		ServoHome := FALSE;
	END_IF
END_FUNCTION
