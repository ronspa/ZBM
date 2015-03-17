(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: BU_1
 * File: BU_1Init.st
 * Author: jorkes
 * Created: September 17, 2014
 ********************************************************************
 * Implementation of program BU_1
 ********************************************************************)

PROGRAM _INIT

	i := 0;
	
	FOR i := 0 TO 9 DO
		BU[i].typInterface.Status := BU_ST_DISABLED;
		BU[i].usChainPos := SHFTREG.uiBunchUnitPosition[i];
	
		// For TESTING RSP 23-12-2014
	
		//Enable 'FI'
		BU[i].typBunchBelts.command.bEnabledStop := TRUE;
		//Bepaal draairichting
		BU[i].typBunchBelts.command.bRunReverse := FALSE;
	END_FOR
		
	
	i := 0;
	BU[i].typSettings.usTimingBU16 := 10; // Pos=12
END_PROGRAM

 
