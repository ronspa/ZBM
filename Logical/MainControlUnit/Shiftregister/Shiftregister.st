(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: Shiftregister
 * File: ShiftregisterCyclic.st
 * Author: jorkes
 * Created: July 08, 2014
 ********************************************************************
 * Implementation of program Shiftregister
 ********************************************************************)

PROGRAM _INIT
	SHFTREG.typCounters.usChainCounter := 0;
	SHFTREG.typCounters.uiChainCnt16x16 := 0;
	SHFTREG.typCounters.usStartUpCntr := 0;
	SHFTREG.typCounters.bStartChainCntr := FALSE;
	bStartCnt := TRUE;
	
	//Preset
	SHFTREG.typCounters.usChainCounter := 0;
END_PROGRAM
	
PROGRAM _CYCLIC
	//==============================================================
	//Software met 2 x puls/grijper
	//Encoderpuls 1
	//==============================================================
	bEncPuls1 := FALSE;
	
	IF EDGENEG(MCU.typChain.status.bSetSpeedReached) THEN
		idxCntr := 0;
		bEncActive1 := FALSE;
	END_IF
	
	IF MCU.typChain.status.bSetSpeedReached OR TRUE THEN	
		//#1
		IF EDGEPOS(MCU.typIN.bEncPuls1) AND NOT bEncActive1 THEN
			tiStop1 := T#0ms;
			tiStart1 := clock_ms();
			//Wacht weer op een volgende trigger. -> #2
			bEncActive1 := TRUE;
			
			//IF SHFTREG.typCounters.bStartChainCntr THEN
				//ringcounter 0-74			
				//SHFTREG.typCounters.usChainCounter := (SHFTREG.typCounters.usChainCounter + 1) MOD (SHFTREG.uiGripperCnt);
			//END_IF
			
			//Meten van de gemiddelde tijd tussen twee grijpers.
//			IF NOT(bSubCounter) THEN
//				tiStart3 := tiStart1;
//				bSubCounter := TRUE;
//			ELSE
//				tiStop3 := tiStart1;			
//				tiDiff3[idx_Diff3] := tiStop3 - tiStart3;
//				
//				idx_Diff3 := (idx_Diff3 + 1) MOD 10;
//				
//				tiDiff3Total := T#0ms;
//				
//				FOR idx := 0 TO 9 DO
//					tiDiff3Total := tiDiff3Total + tiDiff3[idx];
//				END_FOR
//				
//				tiDiff3Total := tiDiff3Total / 10;
//				
//				IF idxCntr > 9 THEN
//					tiMusecSub := tiDiff3Total / 16;
//				ELSE 
//					idxCntr := idxCntr + 1;
//					tiMusecSub := SHFTREG.tiDistanceBetweenGrippers / 16;
//				END_IF
//					
//				bSubCounter := FALSE;			
//			END_IF
		END_IF
	
		//Sla actuele tijd op.
		tiActual1 := clock_ms();
		
		//#2
		IF bEncActive1 THEN
			tiCheck1[idx_Diff1] := tiActual1 - tiStart1;
			//Controleer of de tweede puls van dezelfde grijper is en niet van de volgende.
			IF NOT(tiCheck1[idx_Diff1] > T#300ms) THEN
				//Als de volgende trigger binnen de 300ms valt dan is het dezelfde grijper.
				//IF EDGEPOS(MCU.typIN.bEncPuls1) THEN
				//	bStartEnc := TRUE;
				//END_IF
				//Controleer de trigger op de afgaande flank en sla de tijd op.				
//				IF EDGENEG(MCU.typIN.bEncPuls1) THEN
//					tiStop1 := clock_ms();
//					tiDiff1 := tiStop1 - tiStart1;
//					//Als de tijd tussen opgaande en de afgaande flank groter is dan (100ms) genereer een puls met dubbele tijd.
//					IF tiDiff1 > T#100ms THEN
//						//Dubbele puls tijd.
//						//tpPulsEnc1.PT := T#10ms;
//						//Activeer puls.
//						//tpPulsEnc1.IN := TRUE;
//						//Wacht weer op een volgende trigger. -> #1
//						bEncActive1 := FALSE;
//						//Start de chaincounter bij de lange puls! -> #1			
//						SHFTREG.typCounters.bStartChainCntr := TRUE;
//						//SHFTREG.typCounters.usChainCounter := 0;
//					END_IF
				IF EDGEPOS(MCU.typIN.bEncPuls1) THEN
					tiStop1 := clock_ms();
					tiDiff1 := tiStop1 - tiStart1;
					//Als de tijd tussen de twee triggerpulsen groter is dan (100ms) genereer een puls van 5ms.
					IF tiDiff1 > T#50ms THEN
						bEncPuls1 := TRUE;
						//Wacht weer op een volgende trigger. -> #1
						bEncActive1 := FALSE;
					END_IF
					idx_Diff1 := (idx_Diff1 + 1) MOD 75;
				ELSIF (tiCheck1[idx_Diff1] >= (T#149ms - T#30ms)) AND (tiStop1 = T#0ms) THEN //(T#149ms - T#30ms)) THEN
					// generate puls
					bEncPuls1 := TRUE;
					//Wacht weer op een volgende trigger. -> #1
					bEncActive1 := FALSE;
					//Start de chaincounter bij de lange puls! -> #1			
					SHFTREG.typCounters.bStartChainCntr := TRUE;
					SHFTREG.typCounters.usChainCounter := 0;
					idx_Diff1 := (idx_Diff1 + 1) MOD 75;
				END_IF
			ELSE
				//Wacht weer op een volgende trigger. -> #1
				bEncActive1 := FALSE;	
			END_IF
		END_IF
	END_IF
	
	IF EDGEPOS(bEncPuls1) THEN		
		
		IF NOT(bSubCounter) THEN
			tiStart3 := clock_ms();
			bSubCounter := TRUE;
		ELSE
			tiStop3 := clock_ms();			
			tiDiff3[idx_Diff3] := tiStop3 - tiStart3;
				
			idx_Diff3 := (idx_Diff3 + 1) MOD 10;
				
			tiDiff3Total := T#0ms;
				
			FOR idx := 0 TO 9 DO
				tiDiff3Total := tiDiff3Total + tiDiff3[idx];
			END_FOR
				
			tiDiff3Total := tiDiff3Total / 10;
				
			IF idxCntr > 9 THEN
				tiMusecSub := tiDiff3Total / 16;
			ELSE 
				idxCntr := idxCntr + 1;
				tiMusecSub := SHFTREG.tiDistanceBetweenGrippers / 16;
			END_IF
					
			bSubCounter := FALSE;			
		END_IF
		
		SHFTREG.typCounters.usChainCounter := (SHFTREG.typCounters.usChainCounter + 1) MOD (SHFTREG.uiGripperCnt);
	END_IF
		//#3
	IF EDGEPOS(MCU.typIN.bEncPuls2) AND NOT bEncActive2 THEN
		tiStart2 := clock_ms();
		//Wacht weer op een volgende trigger. -> #4
		bEncActive2 := TRUE;	
	END_IF

	//Sla actuele tijd op.
	tiActual2 := clock_ms();
	
	//#4
	IF bEncActive2 THEN
		tiCheck2 := tiActual2 - tiStart2;
		//Controleer of de tweede puls van dezelfde grijper is en niet van de volgende.
		IF NOT(tiCheck2 > T#300ms) THEN
			//Als de volgende trigger binnen de 300ms valt dan is het dezelfde grijper.
			//Controleer de trigger op de afgaande flank en sla de tijd op.				
			IF EDGENEG(MCU.typIN.bEncPuls2) THEN
				tiStop2 := clock_ms();
				tiDiff2 := tiStop2 - tiStart2;
				//Als de tijd tussen opgaande en de afgaande flank groter is dan (150ms) genereer een puls met dubbele tijd.
				IF tiDiff2 > T#100ms THEN
					//Dubbele puls tijd.
					tpPulsEnc2.PT := T#200ms;
					//Activeer puls.
					tpPulsEnc2.IN := TRUE;
					//Wacht weer op een volgende trigger. -> #3
					bEncActive2 := FALSE;
				END_IF
			ELSIF EDGEPOS(MCU.typIN.bEncPuls2) THEN
				tiStop2 := clock_ms();
				tiDiff2 := tiStop2 - tiStart2;
				//Als de tijd tussen de twee triggerpulsen groter is dan (50ms) genereer een puls van 100ms.
				IF tiDiff2 > T#50ms THEN
					//Dubbele puls tijd.
					tpPulsEnc2.PT := T#100ms;
					//Activeer puls.
					tpPulsEnc2.IN := TRUE;
					//Wacht weer op een volgende trigger. -> #3
					bEncActive2 := FALSE;
				END_IF						
		END_IF		ELSE
			//Wacht weer op een volgende trigger. -> #3
			bEncActive2 := FALSE;	
		END_IF
	END_IF

	
	PulsGenerator_0(tInit := bEncPuls1, enable := bGblSimulation OR MCU.typChain.status.bSetSpeedReached, sysTim := systemTime, tiHigh := T#1ms, tiLow := tiMusecSub);	
	
	IF bEncPuls1 THEN
		SHFTREG.typCounters.uiChainCnt16x16 := SHFTREG.typCounters.uiChainCnt16x16 AND 240;
	END_IF

	IF EDGENEG(PulsGenerator_0.bOutput) THEN
		SHFTREG.typCounters.uiChainCnt16x16 := (SHFTREG.typCounters.uiChainCnt16x16 + 1) MOD 256;
		IF (SHFTREG.typCounters.uiChainCnt16x16 = 0) THEN
			SHFTREG.typCounters.usChainOffset := SHFTREG.typCounters.usChainCounter;
		END_IF			
	END_IF
	
	//4 x cam & light triggers
	//	CamTrig_0(CamPos := 5, reset := MCU.typIN.bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := T#30ms, tiDelay := T#15ms); //tiDelay = zie excel berekening Beschrijving software.xlsx
	//	CamTrig_1(CamPos := 10, reset := MCU.typIN.bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := T#30ms, tiDelay := T#7ms);
	//	CamTrig_2(CamPos := 12, reset := MCU.typIN.bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := T#30ms, tiDelay := T#11ms);
	//	CamTrig_3(CamPos := 2, reset := MCU.typIN.bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := T#30ms, tiDelay := T#26ms);
	CamTrig_0(CamPos := Settings.CamPosition1, reset := bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := INT_TO_TIME(Settings.CamPulseLength), tiDelay := INT_TO_TIME(Settings.CamDelay1), tiExtraLight := INT_TO_TIME(Settings.FlitsBefore)); //tiDelay = zie excel berekening Beschrijving software.xlsx
	CamTrig_1(CamPos := Settings.CamPosition2, reset := bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := INT_TO_TIME(Settings.CamPulseLength), tiDelay := INT_TO_TIME(Settings.CamDelay2), tiExtraLight := INT_TO_TIME(Settings.FlitsBefore));
	CamTrig_2(CamPos := Settings.CamPosition3, reset := bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := INT_TO_TIME(Settings.CamPulseLength), tiDelay := INT_TO_TIME(Settings.CamDelay3), tiExtraLight := INT_TO_TIME(Settings.FlitsBefore));
	CamTrig_3(CamPos := Settings.CamPosition4, reset := bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := INT_TO_TIME(Settings.CamPulseLength), tiDelay := INT_TO_TIME(Settings.CamDelay4), tiExtraLight := INT_TO_TIME(Settings.FlitsBefore));

	
	MCU.typOUT.bLightTrigger1 := CamTrig_0.outLight;
	MCU.typOUT.bCamTrigger1 := CamTrig_0.outCam;
	MCU.typOUT.bLightTrigger2 := CamTrig_1.outLight;
	MCU.typOUT.bCamTrigger2 := CamTrig_1.outCam;
	MCU.typOUT.bLightTrigger3 := CamTrig_2.outLight;
	MCU.typOUT.bCamTrigger3 := CamTrig_2.outCam;
	MCU.typOUT.bLightTrigger4 := CamTrig_3.outLight;
	MCU.typOUT.bCamTrigger4 := CamTrig_3.outCam;

	
	//===============================
	//Software met kettingplaatjes
	//===============================
	//bEncPuls1 := MCU.typIN.bEncPuls1
	
	//Afhandelen van encodertrigger 1
//	IF EDGEPOS(bEncPuls1) AND NOT bFall_1 THEN
//		tiMusecStart4 := clock_ms();
//		IF toggle THEN
//			toggle := FALSE;
//			tiMusecStop3 := clock_ms();
//			tiMusecDiff3 := tiMusecStop3 - tiMusecStart1;
//			tiMusecSub := tiMusecDiff3 / 16;
//		END_IF		
//		
//		//get number of elapsed microseconds in current tick
//		tiMusecStart1 := clock_ms();   	 	
//		
//		//Wait for first gripper (double length sensor puls)
//		IF SHFTREG.typCounters.bStartChainCntr THEN
//			//ringcounter 0-75
//			SHFTREG.typCounters.usChainCounter := (SHFTREG.typCounters.usChainCounter + 1) MOD (SHFTREG.uiGripperCnt);
//		ELSE
//			//startup counter. Only for completing average sensor measuring
//			SHFTREG.typCounters.usStartUpCntr := (SHFTREG.typCounters.usStartUpCntr + 1) MOD 255;
//		END_IF
//		
//		//Variable prevends that falling edge is triggered first
//		bFall_1 := TRUE; 				 
//	END_IF
//	
//	IF EDGENEG(bEncPuls1) AND bFall_1 THEN
//		toggle := TRUE;
//		
//		//get number of elapsed microseconds in current tick
//		tiMusecStop1 := clock_ms();   									
//		tiMusecDiff1 := tiMusecStop1 - tiMusecStart1;
//		
//		AverageSens_0(index := SHFTREG.typCounters.usChainCounter, tiMeasure := tiMusecDiff1);
//
//		//First counter that takes care of detecting first gripper
//		IF SHFTREG.typCounters.usStartUpCntr > 9 THEN
//			AverageSens_0(enable := TRUE);
//			//Check if there was a 1.5 times of length of average sensor puls
//			//IF tiMusecDiff1 > ( (AverageSens_0.tiAverage * 3)/2) THEN
//			IF tiMusecDiff1 > ( (tiMusecDiff2 * 3)/2) THEN
//				tiMusecBetweenEncStart := clock_ms();
//				SHFTREG.typCounters.bStartChainCntr := TRUE;
//				SHFTREG.typCounters.usChainCounter := 0;
//			END_IF
//		END_IF
//						
//		bFall_1 := FALSE;
//	END_IF
//	
//	//Afhandelen van encodertrigger 2
//	IF EDGEPOS(bEncPuls2) AND NOT bFall_2 THEN
//		tiMusecStart2 := clock_ms();   	
//		bFall_2 := TRUE;  				
//	END_IF
//	
//	IF EDGENEG(bEncPuls2) AND bFall_2 THEN
//		tiMusecStop2 := clock_ms(); 
//		tiMusecDiff2 := tiMusecStop2 - tiMusecStart2;
//		
//		AverageSens_1(index := SHFTREG.typCounters.usChainCounter, tiMeasure := tiMusecDiff2);
//
//		//First counter that takes care of detecting first gripper
//		IF SHFTREG.typCounters.usStartUpCntr > 9 THEN
//			AverageSens_1(enable := TRUE);
//			//Check if there was a 1.5 times of length of average sensor puls
//			IF tiMusecDiff2 > ( (AverageSens_1.tiAverage * 3)/2) THEN
//				//Check if first sensor detected first gripper already
//				
//				IF SHFTREG.typCounters.bStartChainCntr THEN
//					tiMusecBetweenEncStop := clock_ms();
//					//calculate time between encoder sensor, by measuring first grippper
//					tiMusecBetweenEncDiff[usCntr] := tiMusecBetweenEncStop - tiMusecBetweenEncStart;
//					usCntr := (usCntr + 1) MOD 100;
//				END_IF								
//			END_IF
//		END_IF
//		bFall_2 := FALSE;
//	END_IF	
	
	IF MCU.typInterface.State <> RUN THEN
		// Blink
		IF NOT tpBlink.Q THEN
			MCU.typOUT.bGreenLight := MCU.typOUT.bRedLight;
			MCU.typOUT.bRedLight := NOT MCU.typOUT.bRedLight;
		END_IF
		tpBlink(IN:=(NOT tpBlink.Q), PT:=T#500ms);
	ELSE
		IF bEncPuls1 THEN
			MCU.typOUT.bRedLight := TRUE;
			tiLastPuls := clock_ms();
		END_IF
		MCU.typOUT.bGreenLight := clock_ms() - tiLastPuls < T#400ms;
	END_IF

	// Reject Unit
	//usGripperIndex := ( SHFTREG.typCounters.usChainCounter + RU.usChainPos) MOD  SHFTREG.uiGripperCnt;
	usGripperIndex := ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt - RU.usChainPos) MOD  SHFTREG.uiGripperCnt;
	IF SHFTREG.typGripper[usGripperIndex].bRejectActive THEN
		//RU.bAddFlower.SET1 := TRUE;
		IF RU.typSettings.usTimingBU16 MOD 16 = SHFTREG.typCounters.uiChainCnt16x16 MOD 16 THEN
			RU.typOUT.bActivateGripper := SHFTREG.typGripper[usGripperIndex].bRejectOnOff;
			//fbResetGripper( ThisGripper := SHFTREG.typGripper[usGripperIndex]);
			SHFTREG.typGripper[usGripperIndex].bRejectActive := FALSE;
			SHFTREG.typGripper[usGripperIndex].bRejectOnOff := FALSE;
		END_IF
	END_IF

	
	// Now check if a gripper is positioned for the BU
	FOR i := 0 TO 9 DO

		//JORKES
		usGripperIndex := ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt - BU[i].usChainPos) MOD  SHFTREG.uiGripperCnt;
		
		IF NOT BU[i].typInterface.bEmptyCmd THEN
			BU[i].typInterface.bEmptyCmd := SHFTREG.typGripper[usGripperIndex].siEmptyBU = i;
			IF BU[i].typInterface.bEmptyCmd THEN
				SHFTREG.typGripper[usGripperIndex].siEmptyBU := -1;
//				itoa(i, ADR(strNum));
//				strLogAdr := strcat(  ADR('Empty command received '), ADR(strNum));
			END_IF
//			IF BU[i].typInterface.bEmptyCmd THEN
//				AsArLogWrite_EmptyCmd(enable :=  BU[i].typInterface.bEmptyCmd, ident := arlogBASE_USER_LOG_IDENT, logLevel := 1, errornr := 50003, mem := ADR(i), len := SIZEOF(i), asciiString :=  strLogAdr);	
//			END_IF
		END_IF
		
		IF NOT BU[i].bAddFlower THEN
			//JORKES
			//usGripperIndex := ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt - BU[i].usChainPos) MOD  SHFTREG.uiGripperCnt;
			BU[i].GripperControl.IN := FALSE;
			
			
			//IF EDGEPOS(BU[i].typInterface.bEmptyCmd) THEN
			//	AsArLogWrite_EmptyCmd(enable := TRUE, ident := arlogBASE_USER_LOG_IDENT, logLevel := 1, errornr := 50002, mem := 0, len := 0, asciiString :=  ADR('Bosunit empty cmd set'));	
			//END_IF
			
			IF i = SHFTREG.typGripper[usGripperIndex].usSetTarget THEN
				//SHFTREG.typGripper[usGripperIndex].
				BU[i].bAddFlower := TRUE;
				BU[i].typInterface.iReceivePos := SHFTREG.typGripper[usGripperIndex].uiCorrection;
				IF SHFTREG.typGripper[usGripperIndex].bFast THEN
					BU[i].typInterface.usServoSpeed := BU[i].typSettings.usFastSpeed;
				ELSE
					BU[i].typInterface.usServoSpeed := BU[i].typSettings.usSpeed;
				END_IF
				//////////BU[i].typSettings.usTimingBU16 := INT_TO_SINT( SHFTREG.typGripper[usGripperIndex].uiTimingBU16 MOD 16);
				// The gripper data is assigend
				//IF EDGEPOS(BU[i].bAddFlower) THEN
				//	AsArLogWrite_EmptyCmd(enable := TRUE, ident := arlogBASE_USER_LOG_IDENT, logLevel := 1, errornr := 50003, mem := ADR(i), len := SIZEOF(i), asciiString :=  ADR('Add flower'));	
				//END_IF
			ELSE
				// The first gripper doen's contain a flow, does the 
				usGripperIndex := ( SHFTREG.typCounters.usChainCounter - 1 + BU[i].usChainPos) MOD SHFTREG.uiGripperCnt;
				IF i = SHFTREG.typGripper[usGripperIndex].usSetTarget AND NOT BU[i].bBusyDrop THEN
					BU[i].typInterface.iReceivePos := SHFTREG.typGripper[usGripperIndex].uiCorrection;
				END_IF
			END_IF
		ELSE IF NOT BU[i].bBusyDrop THEN
			//JORKES
			//IF EDGEPOS(BU[i].rsActivateGripper.Q1) THEN
			IF EDGEPOS(BU[i].typSettings.usTimingBU16 = (SHFTREG.typCounters.uiChainCnt16x16 MOD 16) ) AND (i = SHFTREG.typGripper[usGripperIndex].usSetTarget) THEN
				fbResetGripper( ThisGripper := SHFTREG.typGripper[usGripperIndex]);
				BU[i].GripperControl.IN := TRUE;
				BU[i].bAddFlower := FALSE;
				END_IF
			END_IF
			
			//JORKES
			//BU[i].GripperControl.IN :=  BU[i].rsActivateGripper.Q1; // AND  i = SHFTREG.typGripper[usGripperIndex].usSetTarget;
			//BU[i].GripperControl.IN :=  BU[i].typSettings.usTimingBU16 = SHFTREG.typCounters.uiChainCnt16x16 MOD 16; // AND  i = SHFTREG.typGripper[usGripperIndex].usSetTarget;
		END_IF
		
		IF EDGENEG(BU[i].typOUT.bActivateGripper) THEN
		//	BU[i].bAddFlower(SET1 := FALSE, RESET := TRUE);
		END_IF
		//BU[i].GripperControl(tiSensDelay := BU[i].typInterface.tiDelayActiveGripper, tiSensPuls := INT_TO_TIME( Settings.BU_ActivateReleaseTime )); // T#3000ms); // Was 100 RSP
		BU[i].GripperControl( PT := INT_TO_TIME( Settings.BU_ActivateReleaseTime ));
		BU[i].typOUT.bActivateGripper := BU[i].GripperControl.Q OR  BU[i].typInterface.bManualGripperCmd;		
		//JORKES
		//BU[i].rsActivateGripper(RESET1 := NOT BU[i].bAddFlower);
		//BU[i].GripperControl.IN :=  BU[i].rsActivateGripper.Q1;
		
		// TO DO
		// BU[i].bAddFlower.RESET := (i = SHFTREG.typGripper[usGripperIndex].usSetTarget);

	END_FOR
END_PROGRAM




















