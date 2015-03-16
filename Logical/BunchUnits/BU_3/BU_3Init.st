(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: BU_1
 * File: BU_1Init.st
 * Author: ronspa
 * Created: Januari 12, 2015
 ********************************************************************
 * Implementation of program BU_1
 ********************************************************************)

PROGRAM _INIT

	i := 2;
	
	BU[i].typInterface.Status := BU_ST_DISABLED;
	BU[i].usChainPos := SHFTREG.uiBunchUnitPosition[i] - 1; // Because position is 0!!!

	// For TESTING RSP 23-12-2014

	//Enable 'FI'
	BU[i].typBunchBelts.command.bEnabledStop := TRUE;
	//Bepaal draairichting
	BU[i].typBunchBelts.command.bRunReverse := FALSE;
	BU[i].typSettings.usTimingBU16 := 14; // Pos=0 -> 

END_PROGRAM

 
