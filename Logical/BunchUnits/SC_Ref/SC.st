(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: ServoControl
 * File: ServoControl.st
 * Author: jorkes
 * Created: July 30, 2014
 ********************************************************************
 * Implementation of program ServoControl
 ********************************************************************)

PROGRAM _CYCLIC
	//=========================================Servo variables===========================================
	
	//Write back to CPOS
	BU[i].typServo.command.CPOS.bHALT := FALSE;
	BU[i].typServo.command.CPOS.bSTART := FALSE;
	BU[i].typServo.command.CPOS.bHOM := FALSE;
	BU[i].typServo.command.CPOS.bJOGP := FALSE;
	BU[i].typServo.command.CPOS.bJOGN := FALSE;
	BU[i].typServo.command.CPOS.bTEACH := FALSE;
	BU[i].typServo.command.CPOS.bCLEAR := FALSE;
	BU[i].typServo.command.CPOS.bNU := FALSE;
	
	//Write back to CCON
	BU[i].typServo.command.CCON.bENABLE := FALSE;
	BU[i].typServo.command.CCON.bSTOP := FALSE;
	BU[i].typServo.command.CCON.bBRAKE := FALSE;
	BU[i].typServo.command.CCON.bRESET := FALSE;
	BU[i].typServo.command.CCON.bNU := FALSE;
	BU[i].typServo.command.CCON.bLOCK := FALSE;
	BU[i].typServo.command.CCON.bOPM1 := FALSE;
	BU[i].typServo.command.CCON.bOPM2 := FALSE;
	
	//Velocity in %
	BU[i].typServo.status.VAL1.usVelocity := BU[i].typServo.packed.VAL1;
	//Position
	BU[i].typServo.status.VAL2.diPosition := BU[i].typServo.packed.VAL2;

	BU[i].typServo.status.SPOS.uiSPOS 	:= BU[i].typServo.packed.SPOS AND 16#FF;	// Mask the SPOS status word 
	BU[i].typServo.status.SPOS.bHALT 	:= BU[i].typServo.status.SPOS.uiSPOS.0;	// bit 0 = Halt
	BU[i].typServo.status.SPOS.bACK		:= BU[i].typServo.status.SPOS.uiSPOS.1;	// bit 1 = Acknowledge start
	BU[i].typServo.status.SPOS.bMC 		:= BU[i].typServo.status.SPOS.uiSPOS.2;	// bit 2 = Motion complete
	BU[i].typServo.status.SPOS.bTEACH	:= BU[i].typServo.status.SPOS.uiSPOS.3;	// bit 3 = Acknowledge teach/sampling
	BU[i].typServo.status.SPOS.bMOV		:= BU[i].typServo.status.SPOS.uiSPOS.4;	// bit 4 = Axis is moving
	BU[i].typServo.status.SPOS.bDEV		:= BU[i].typServo.status.SPOS.uiSPOS.5;	// bit 5 = Drag (deviation) error
	BU[i].typServo.status.SPOS.bSTILL	:= BU[i].typServo.status.SPOS.uiSPOS.6;	// bit 6 = Standstill control
	BU[i].typServo.status.SPOS.bREF		:= BU[i].typServo.status.SPOS.uiSPOS.7;	// bit 7 = Axis is referencend

	BU[i].typServo.status.SCON.uiSCON 	:= BU[i].typServo.packed.SCON AND 16#FF;	// Mask the SCON status word 
	BU[i].typServo.status.SCON.bENABLED	:= BU[i].typServo.status.SCON.uiSCON.0;	// bit 0 = Drive enabled
	BU[i].typServo.status.SCON.bOPEN 	:= BU[i].typServo.status.SCON.uiSCON.1;	// bit 1 = Operation enabled
	BU[i].typServo.status.SCON.bWARN 	:= BU[i].typServo.status.SCON.uiSCON.2;	// bit 2 = Warning
	BU[i].typServo.status.SCON.bFAULT 	:= BU[i].typServo.status.SCON.uiSCON.3;	// bit 3 = Fault
	BU[i].typServo.status.SCON.b24VL 	:= BU[i].typServo.status.SCON.uiSCON.4;	// bit 4 = Supply voltage is applied
	BU[i].typServo.status.SCON.bLOCK 	:= BU[i].typServo.status.SCON.uiSCON.5;	// bit 5 = Drive control by software
	BU[i].typServo.status.SCON.bOPM1	:= BU[i].typServo.status.SCON.uiSCON.6;	// bit 6 = Display operating mode
	BU[i].typServo.status.SCON.bOPM2 	:= BU[i].typServo.status.SCON.uiSCON.7;	// bit 7 = Display operating mode
	
	//==================================
	//ServoControl
	//==================================
	
//	CASE BU[i].typServo.gCommand OF
	CASE BU[i].typServo.enumServoCmd OF
		SERVO_CMD_HOME:
			ControllerState := 10;
			IF BU[i].typServo.status.SCON.bENABLED AND BU[i].typServo.status.SCON.bOPEN AND BU[i].typServo.status.SCON.b24VL THEN
				IF BU[i].typServo.status.SPOS.bHALT THEN
					BU[i].typServo.command.CPOS.bHOM := TRUE;
				END_IF
			END_IF
			IF BU[i].typServo.status.SPOS.bREF THEN	
				BU[i].typServo.enumServoCmd := SERVO_CMD_READY;
			END_IF		
		SERVO_CMD_RUN: 
			ControllerState := 10;
			IF BU[i].typServo.status.SPOS.bMC THEN
				CASE SetServo OF
					0:	
						tiMusecStart := clock_ms();
						SetServo := 1;
					1: 
						//Store stop time (us)			
						tiMusecStop := clock_ms();
						tiMusecDiff := tiMusecStop - tiMusecStart;
						IF tiMusecDiff > T#100ms THEN
							//'Start position task'
							BU[i].typServo.command.CPOS.bSTART := 1;
							BU[i].typServo.enumServoCmd := SERVO_CMD_READY;
							SetServo := 0;
						END_IF				
				END_CASE
			END_IF
		SERVO_CMD_RESET: 
			BU[i].typServo.command.CCON.bRESET := TRUE;
			BU[i].typServo.enumServoCmd := SERVO_CMD_READY;
		SERVO_CMD_READY:
			// Ready to receive new command
	END_CASE
	
	//==================================
	//State
	//==================================
	
	CASE ControllerState OF
		10:	//CCON
			BU[i].typServo.command.CCON.bENABLE := TRUE;
			BU[i].typServo.command.CCON.bSTOP := TRUE;
			BU[i].typServo.command.CCON.bOPM1 := TRUE;						
			//CPOS
			BU[i].typServo.command.CPOS.bHALT := TRUE;
	END_CASE
	
	IF BU[i].typServo.status.SPOS.bREF THEN	
		IF BU[i].typServo.status.SPOS.bMOV THEN
			BU[i].typServo.enumServoState := SERVO_RUNNING;
		ELSE
			BU[i].typServo.enumServoState := SERVO_READY;
		END_IF							
	ELSIF NOT BU[i].typServo.status.SPOS.bREF THEN
		IF BU[i].typServo.status.SPOS.bMOV THEN
			BU[i].typServo.enumServoState := SERVO_IS_HOMING;
		ELSE
			BU[i].typServo.enumServoState := SERVO_HOMING_NOT_COMPLETED;
		END_IF
	END_IF
	IF NOT BU[i].typServo.status.SCON.bENABLED THEN
		BU[i].typServo.enumServoState := SERVO_DISABLED;
	END_IF
	IF BU[i].typServo.status.SCON.bFAULT THEN
		BU[i].typServo.enumServoState := SERVO_FAULT;
	END_IF
				
	//Write back to CPOS
	BU[i].typServo.packed.CPOS.0 := BU[i].typServo.command.CPOS.bHALT;
	BU[i].typServo.packed.CPOS.1 := BU[i].typServo.command.CPOS.bSTART;
	BU[i].typServo.packed.CPOS.2 := BU[i].typServo.command.CPOS.bHOM;
	BU[i].typServo.packed.CPOS.3 := BU[i].typServo.command.CPOS.bJOGP;
	BU[i].typServo.packed.CPOS.4 := BU[i].typServo.command.CPOS.bJOGN;
	BU[i].typServo.packed.CPOS.5 := BU[i].typServo.command.CPOS.bTEACH;
	BU[i].typServo.packed.CPOS.6 := BU[i].typServo.command.CPOS.bCLEAR;
	BU[i].typServo.packed.CPOS.7 := BU[i].typServo.command.CPOS.bNU;
	
	//Write back to CCON
	BU[i].typServo.packed.CCON.0 := BU[i].typServo.command.CCON.bENABLE;
	BU[i].typServo.packed.CCON.1 := BU[i].typServo.command.CCON.bSTOP;
	BU[i].typServo.packed.CCON.2 := BU[i].typServo.command.CCON.bBRAKE;
	BU[i].typServo.packed.CCON.3 := BU[i].typServo.command.CCON.bRESET;
	BU[i].typServo.packed.CCON.4 := BU[i].typServo.command.CCON.bNU;
	BU[i].typServo.packed.CCON.5 := BU[i].typServo.command.CCON.bLOCK;
	BU[i].typServo.packed.CCON.6 := BU[i].typServo.command.CCON.bOPM1;
	BU[i].typServo.packed.CCON.7 := BU[i].typServo.command.CCON.bOPM2;	
	
	//Write back to PARA1 and PARA2
	BU[i].typServo.packed.PARA1 := BU[i].typServo.command.PARA1.usVelocity;
	BU[i].typServo.packed.PARA2 := BU[i].typServo.command.PARA2.diPosition;
	
END_PROGRAM
