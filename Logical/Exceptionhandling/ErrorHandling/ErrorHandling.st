(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: ErrorHandling
 * File: ErrorHandling.st
 * Author: jorkes
 * Created: July 21, 2014
 ********************************************************************
 * Implementation of program ErrorHandling
 ********************************************************************)

PROGRAM _INIT


(* TODO : Add your code here *)


END_PROGRAM


PROGRAM _CYCLIC
	tonHeartBeat( IN:= NOT(EDGE(bHeartBeat)), PT:= INT_TO_TIME(Settings.HeartBeatTime));
	IF EDGE(tonHeartBeat.Q ) THEN
		// LOG
		IF(tonHeartBeat.Q) THEN
			AsArLogWrite_Failed(enable := TRUE, ident := arlogBASE_USER_LOG_IDENT, logLevel := 1, errornr := 50001, mem := 0, len := 0, asciiString :=  ADR('Heart beat failed!!!!'));	
		ELSE
			AsArLogWrite_Restored(enable := TRUE, ident := arlogBASE_USER_LOG_IDENT, logLevel := 1, errornr := 50001, mem := 0, len := 0, asciiString :=  ADR('Heart beat active again'));	
		END_IF
	END_IF
	
	IF MCU.typIN.bEmergencyStop THEN
		ErrorState := EMERGENCYSTOP;
	ELSIF MCU.typIN.bDoorOpen THEN
		ErrorState := DOOROPEN;
	ELSIF MCU.typIN.bServiceMode THEN
		ErrorState := SERVICEMODE;
	ELSIF MCU.typIN.bAirpressure THEN
		ErrorState := AIRPRESSURE;
	ELSIF MCU.typIN.bBinder THEN
		ErrorState := BINDER;
	ELSE
		ErrorState := OK;
	END_IF
	
	//enumError
	CASE ErrorState OF
		0: bGblRun := FALSE;//EmergencyStop
		1: //AirPressure
		2: //DoorOpen
		3: //MotorMalfunction
		4: //Communication
		5: //Binder
		6: //ServiceMode
	END_CASE
	
	
END_PROGRAM
