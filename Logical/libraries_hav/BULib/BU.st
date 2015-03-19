(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: BU
 * File: Lift.st
 * Author: ronspa
 * Created: September 25, 2014
 ********************************************************************
 * Implementation of program BU
 ********************************************************************) 

(*Operate Elevator*)
FUNCTION Elevator
	IF (ThisBU.typServo.status.VAL2.diPosition >= ThisBU.typSettings.iSafeElevatorPosStart) AND 
		(ThisBU.typServo.status.VAL2.diPosition <= ThisBU.typSettings.iSafeElevatorPosEnd) AND
		(ThisBU.typServo.status.VAL2.diPosition <= ThisBU.typSettings.iSafeElevatorPosStartVak OR
		ThisBU.typServo.status.VAL2.diPosition >= ThisBU.typSettings.iSafeElevatorPosEndVak) THEN
		ThisBU.typOUT.bElevator := DINT_TO_BOOL(bElevator);
		Elevator := TRUE;
	ELSE
		IF NOT DINT_TO_BOOL(bElevator) THEN
			ThisBU.typOUT.bElevator := FALSE;
		ELSE
		// Move Servo to save position
		// There should be a LOG here, this can not happen!!!!!!!!
		IF ThisBU.typInterface.iReleasePos < ThisBU.typSettings.iSafeElevatorPosStart THEN
			ThisBU.typInterface.iReleasePos := ThisBU.typSettings.iSafeElevatorPosStart + 10;
		ELSE
			IF ThisBU.typInterface.iReleasePos > ThisBU.typSettings.iSafeElevatorPosEnd THEN
				ThisBU.typInterface.iReleasePos := ThisBU.typSettings.iSafeElevatorPosEnd - 10;
			ELSE
				IF (ThisBU.typInterface.iReleasePos < ThisBU.typSettings.iSafeElevatorPosEndVak) AND (ThisBU.typInterface.iReleasePos > ThisBU.typSettings.iSafeElevatorPosStartVak) THEN
					IF ThisBU.typInterface.iReleasePos > (ThisBU.typSettings.iSafeElevatorPosStartVak + (ThisBU.typSettings.iSafeElevatorPosEndVak - ThisBU.typSettings.iSafeElevatorPosStartVak) /2) THEN
						ThisBU.typInterface.iReleasePos := ThisBU.typSettings.iSafeElevatorPosEndVak + 10;
					ELSE
						ThisBU.typInterface.iReleasePos := ThisBU.typSettings.iSafeElevatorPosStartVak - 10;
					END_IF
				END_IF
			END_IF
		END_IF
			ServoMovePosition(ThisBU, ThisBU.typInterface.iReleasePos, 45);
		END_IF
	END_IF
END_FUNCTION

FUNCTION CheckTimers	
	tonElevator(IN := (ThisBU.typOUT.bElevator AND NOT ThisBU.typIN.bElevatorUp) OR (ThisBU.typOUT.bElevator AND NOT ThisBU.typIN.bElevatorDown), PT := T#1s);

	IF (tonElevator.Q) THEN
		// Time out
		CheckTimers := BU_ST_TIMEOUT_LIFT;
		RETURN;
	END_IF
	CheckTimers := Status;
END_FUNCTION

FUNCTION DefaultSettingsBU	
	ThisBU.typSettings.usHomeSpeed 			:= iHS;
	ThisBU.typSettings.iMaxPosDev2UseLift 	:= iMPD2UL;
	ThisBU.typSettings.iReceivePos 			:= iRP;
	ThisBU.typSettings.iReleasePos 			:= iRlP;
	ThisBU.typSettings.usSpeed 				:= iSPD;
	ThisBU.typSettings.usFastSpeed 			:= iFSPD;
	ThisBU.typSettings.tiDropDelay 			:= tiDD;
	ThisBU.typSettings.tiDropReadyDelay 	:= tiDRD;
	ThisBU.typSettings.uiNextChainDelay 	:= uiNCD;
	ThisBU.typSettings.iSafeElevatorPosStart	:= iSEPStart;
	ThisBU.typSettings.iSafeElevatorPosStartVak	:= iSEPStartVak;
	ThisBU.typSettings.iSafeElevatorPosEndVak	:= iSEPEndVak;
	ThisBU.typSettings.iSafeElevatorPosEnd	:= iSEPEnd;
	ThisBU.typSettings.tiBunchBeltPulse	:= tiBBP;
END_FUNCTION

//Function call in IOpolling program (2ms)
FUNCTION ElevatorCil
	bElevatorUp_SR(SET1 := bUp, RESET := bMid OR bDown);
		
	//ThisBU.typIN.bElevatorUp := bElevatorUp_SR.Q1;
	
	bElevatorMid_SR(SET1 := bMid, RESET := bUp OR bDown);
		
	ThisBU.typIN.bElevatorMid := bElevatorMid_SR.Q1;
	
	bElevatorDown_SR(SET1 := bDown, RESET := bUp OR bMid);
		
	ThisBU.typIN.bElevatorDown := bElevatorDown_SR.Q1;
END_FUNCTION
