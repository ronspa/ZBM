(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: Festo_Ref
 * File: FestoFun.st
 * Author: ronspa
 * Created: September 29, 2014
 *******************************************************************)

FUNCTION ServoMovePosition 
	IF ThisBU.typServo.bOnLine AND ThisBU.typServo.enumServoCmd = SERVO_CMD_READY THEN
		IF ThisBU.typServo.command.PARA2.diPosition <> NewPosition THEN
			ThisBU.typServo.status.SPOS.bMC := FALSE;
		END_IF
		ThisBU.typServo.command.PARA2.diPosition := NewPosition;
		ThisBU.typServo.command.PARA1.usVelocity := Speed;
		ThisBU.typServo.enumServoCmd := SERVO_CMD_RUN;
		ServoMovePosition := TRUE;
		IF NOT ThisBU.typInterface.bManualCmd THEN
			ThisBU.typInterface.iManualPosition := NewPosition;
			ThisBU.typInterface.usManualSpeed := Speed;
		END_IF
	ELSE
		ServoMovePosition := FALSE;
	END_IF
END_FUNCTION