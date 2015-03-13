(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: InitSettings
 * File: InitSettingsInit.st
 * Author: jorkes
 * Created: October 03, 2014
 ********************************************************************
 * Implementation of program InitSettings
 ********************************************************************)

PROGRAM _INIT
	
	FOR i := 0 TO 9 BY 1 DO
		DefaultSettingsBU
		(
			BU[i], 	//Bunchunit number
			10, 	//Homespeed	
			10,		//MaxPosDev2UseElevator
			50, 	//ReceivePos
			450, 	//ReleasePos
			50, 	//Normal Operation speed
			90, 	//Fast Operation speed
			T#1ms, 	//Drop delay
			T#500ms,//Drop release delay
			0,		//Next chain delay
			92,		//Safe elevator pos start
			246,	//Safe elevator pos start vak
			443,	//Safe elevator pos end vak
			530,	//Safe elevator pos end
			T#500ms	//Bunchbelt pulse
		);
		
		//Set init _parameters bunchbelts
		BU[i].typBunchBelts.command.iSetSpeed := BU[i].typInterface.iSpeedBunchbelt;
		BU[i].typBunchBelts.command.bEnabledStop := TRUE;
	END_FOR
	
END_PROGRAM

