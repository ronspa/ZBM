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
END_PROGRAM
	
PROGRAM _CYCLIC
	PulsGenerator_0(tInit := MCU.typIN.bEncPuls1, enable := bGblSimulation OR MCU.typInterface.State = RUN, sysTim := systemTime, tiHigh := T#1ms, tiLow := tiMusecSub);	
	
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
	CamTrig_0(CamPos := Settings.CamPosition1, reset := MCU.typIN.bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := INT_TO_TIME(Settings.CamPulseLength), tiDelay := INT_TO_TIME(Settings.CamDelay1), tiExtraLight := INT_TO_TIME(Settings.FlitsBefore)); //tiDelay = zie excel berekening Beschrijving software.xlsx
	CamTrig_1(CamPos := Settings.CamPosition2, reset := MCU.typIN.bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := INT_TO_TIME(Settings.CamPulseLength), tiDelay := INT_TO_TIME(Settings.CamDelay2), tiExtraLight := INT_TO_TIME(Settings.FlitsBefore));
	CamTrig_2(CamPos := Settings.CamPosition3, reset := MCU.typIN.bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := INT_TO_TIME(Settings.CamPulseLength), tiDelay := INT_TO_TIME(Settings.CamDelay3), tiExtraLight := INT_TO_TIME(Settings.FlitsBefore));
	CamTrig_3(CamPos := Settings.CamPosition4, reset := MCU.typIN.bEncPuls1, trigger := EDGENEG(PulsGenerator_0.bOutput), tiPuls := INT_TO_TIME(Settings.CamPulseLength), tiDelay := INT_TO_TIME(Settings.CamDelay4), tiExtraLight := INT_TO_TIME(Settings.FlitsBefore));

	
	MCU.typOUT.bLightTrigger1 := CamTrig_0.outLight;
	MCU.typOUT.bCamTrigger1 := CamTrig_0.outCam;
	MCU.typOUT.bLightTrigger2 := CamTrig_1.outLight;
	MCU.typOUT.bCamTrigger2 := CamTrig_1.outCam;
	MCU.typOUT.bLightTrigger3 := CamTrig_2.outLight;
	MCU.typOUT.bCamTrigger3 := CamTrig_2.outCam;
	MCU.typOUT.bLightTrigger4 := CamTrig_3.outLight;
	MCU.typOUT.bCamTrigger4 := CamTrig_3.outCam;
	
	//Afhandelen van encodertrigger 1
	IF EDGEPOS(MCU.typIN.bEncPuls1) AND NOT bFall_1 THEN
		tiMusecStart4 := clock_ms();
		IF toggle THEN
			toggle := FALSE;
			tiMusecStop3 := clock_ms();
			tiMusecDiff3 := tiMusecStop3 - tiMusecStart1;
			tiMusecSub := tiMusecDiff3 / 16;
		END_IF		
		
		//get number of elapsed microseconds in current tick
		tiMusecStart1 := clock_ms();   	 	
		
		//Wait for first gripper (double length sensor puls)
		IF SHFTREG.typCounters.bStartChainCntr THEN
			//ringcounter 0-75
			SHFTREG.typCounters.usChainCounter := (SHFTREG.typCounters.usChainCounter + 1) MOD (SHFTREG.uiGripperCnt);
		ELSE
			//startup counter. Only for completing average sensor measuring
			SHFTREG.typCounters.usStartUpCntr := (SHFTREG.typCounters.usStartUpCntr + 1) MOD 255;
		END_IF
		
		//Variable prevends that falling edge is triggered first
		bFall_1 := TRUE; 				 
	END_IF
	
	IF EDGENEG(MCU.typIN.bEncPuls1) AND bFall_1 THEN
		toggle := TRUE;
		
		//get number of elapsed microseconds in current tick
		tiMusecStop1 := clock_ms();   									
		tiMusecDiff1 := tiMusecStop1 - tiMusecStart1;
		
		AverageSens_0(index := SHFTREG.typCounters.usChainCounter, tiMeasure := tiMusecDiff1);

		//First counter that takes care of detecting first gripper
		IF SHFTREG.typCounters.usStartUpCntr > 9 THEN
			AverageSens_0(enable := TRUE);
			//Check if there was a 1.5 times of length of average sensor puls
			IF tiMusecDiff1 > ( (AverageSens_0.tiAverage * 3)/2) THEN
				tiMusecBetweenEncStart := clock_ms();
				SHFTREG.typCounters.bStartChainCntr := TRUE;
			END_IF
		END_IF
						
		bFall_1 := FALSE;
	END_IF
	
	//Afhandelen van encodertrigger 2
	IF EDGEPOS(MCU.typIN.bEncPuls2) AND NOT bFall_2 THEN
		tiMusecStart2 := clock_ms();   	
		bFall_2 := TRUE;  				
	END_IF
	
	IF EDGENEG(MCU.typIN.bEncPuls2) AND bFall_2 THEN
		tiMusecStop2 := clock_ms(); 
		tiMusecDiff2 := tiMusecStop2 - tiMusecStart2;
		
		AverageSens_1(index := SHFTREG.typCounters.usChainCounter, tiMeasure := tiMusecDiff2);

		//First counter that takes care of detecting first gripper
		IF SHFTREG.typCounters.usStartUpCntr > 9 THEN
			AverageSens_1(enable := TRUE);
			//Check if there was a 1.5 times of length of average sensor puls
			IF tiMusecDiff2 > ( (AverageSens_1.tiAverage * 3)/2) THEN
				//Check if first sensor detected first gripper already
				IF SHFTREG.typCounters.bStartChainCntr THEN
					tiMusecBetweenEncStop := clock_ms();
					//calculate time between encoder sensor, by measuring first grippper
					tiMusecBetweenEncDiff[usCntr] := tiMusecBetweenEncStop - tiMusecBetweenEncStart;
					usCntr := (usCntr + 1) MOD 100;
				END_IF								
			END_IF
		END_IF
		bFall_2 := FALSE;
	END_IF	
	
	IF MCU.typInterface.State <> RUN THEN
		// Blink
		IF NOT tpBlink.Q THEN
			MCU.typOUT.bGreenLight := MCU.typOUT.bRedLight;
			MCU.typOUT.bRedLight := NOT MCU.typOUT.bRedLight;
		END_IF
		tpBlink(IN:=(NOT tpBlink.Q), PT:=T#500ms);
	ELSE
		MCU.typOUT.bRedLight := (MCU.typIN.bEncPuls1);
		MCU.typOUT.bGreenLight := TRUE;
	END_IF

	// Reject Unit
	//usGripperIndex := ( SHFTREG.typCounters.usChainCounter + RU.usChainPos) MOD  SHFTREG.uiGripperCnt;
	usGripperIndex := ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt - RU.usChainPos) MOD  SHFTREG.uiGripperCnt;
	IF SHFTREG.typGripper[usGripperIndex].bRejectActive THEN
		//RU.srAddFlower.SET1 := TRUE;
		IF RU.typSettings.usTimingBU16 MOD 16 = SHFTREG.typCounters.uiChainCnt16x16 MOD 16 THEN
			RU.typOUT.bActivateGripper := SHFTREG.typGripper[usGripperIndex].bRejectOnOff;
			//fbResetGripper( ThisGripper := SHFTREG.typGripper[usGripperIndex]);
			SHFTREG.typGripper[usGripperIndex].bRejectActive := FALSE;
			SHFTREG.typGripper[usGripperIndex].bRejectOnOff := FALSE;
		END_IF
	END_IF

	
	// Now check if a gripper is positioned for the BU
	FOR i := 0 TO 1 DO

		
		usGripperIndex := ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt - BU[i].usChainPos) MOD  SHFTREG.uiGripperCnt;
		//IF BU[i].typSettings.usTimingBU16 = SHFTREG.typCounters.uiChainCnt16x16 MOD 16 AND  i = SHFTREG.typGripper[usGripperIndex].usSetTarget THEN
		// The time has come to activate the grippers!!!
		//	BU[i].GripperControl.IN := TRUE;
		//END_IF
		
		IF NOT BU[i].srAddFlower THEN
			usGripperIndex := ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt - BU[i].usChainPos) MOD  SHFTREG.uiGripperCnt;
		//	IF i = SHFTREG.typGripper[usGripperIndex].usSetTarget THEN
		//		// The first gripper doen's contain a flow, does the 
		//		usGripperIndex := ( SHFTREG.typCounters.usChainCounter - 1 + BU[i].usChainPos) MOD  SHFTREG.uiGripperCnt;
		//		BU[i].typInterface.iReceivePos := SHFTREG.typGripper[usGripperIndex].uiCorrection;				
		//	END_IF

			IF i = SHFTREG.typGripper[usGripperIndex].usSetTarget THEN
				//SHFTREG.typGripper[usGripperIndex].
				BU[i].srAddFlower := TRUE;
				BU[i].typInterface.bEmptyCmd := SHFTREG.typGripper[usGripperIndex].bEmptyBU;
				BU[i].typInterface.iReceivePos := SHFTREG.typGripper[usGripperIndex].uiCorrection;
				IF SHFTREG.typGripper[usGripperIndex].bFast THEN
					BU[i].typInterface.usServoSpeed := BU[i].typSettings.usFastSpeed;
				ELSE
					BU[i].typInterface.usServoSpeed := BU[i].typSettings.usSpeed;
				END_IF
				//////////BU[i].typSettings.usTimingBU16 := INT_TO_SINT( SHFTREG.typGripper[usGripperIndex].uiTimingBU16 MOD 16);
				// The gripper data is assigend
				
			END_IF
		ELSE
			// BU[i].srAddFlower.Q1 = TRUE so a flower is already assigned
			usGripperIndex := ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt - BU[i].usChainPos) MOD  SHFTREG.uiGripperCnt;
			BU[i].rsActivateGripper.SET := BU[i].typSettings.usTimingBU16 = SHFTREG.typCounters.uiChainCnt16x16 MOD 16  AND  i = SHFTREG.typGripper[usGripperIndex].usSetTarget;

			//IF BU[i].typSettings.usTimingBU16 = SHFTREG.typCounters.uiChainCnt16x16 MOD 16 AND  i = SHFTREG.typGripper[usGripperIndex].usSetTarget THEN
				// The time has come to activate the grippers!!!
			//	BU[i].GripperControl.IN := TRUE;
			//END_IF
			IF EDGEPOS(BU[i].rsActivateGripper.Q1) THEN
				fbResetGripper( ThisGripper := SHFTREG.typGripper[usGripperIndex]);
			END_IF
			BU[i].GripperControl.IN :=  BU[i].rsActivateGripper.Q1; // AND  i = SHFTREG.typGripper[usGripperIndex].usSetTarget;
			//BU[i].GripperControl.IN :=  BU[i].typSettings.usTimingBU16 = SHFTREG.typCounters.uiChainCnt16x16 MOD 16; // AND  i = SHFTREG.typGripper[usGripperIndex].usSetTarget;
		END_IF
		
		IF EDGENEG(BU[i].typOUT.bActivateGripper) THEN
		//	BU[i].srAddFlower(SET1 := FALSE, RESET := TRUE);
		END_IF
		//BU[i].GripperControl(tiSensDelay := BU[i].typInterface.tiDelayActiveGripper, tiSensPuls := INT_TO_TIME( Settings.BU_ActivateReleaseTime )); // T#3000ms); // Was 100 RSP
		BU[i].GripperControl( PT := INT_TO_TIME( Settings.BU_ActivateReleaseTime ));
		BU[i].typOUT.bActivateGripper := BU[i].GripperControl.Q;
		BU[i].rsActivateGripper(RESET1 := NOT BU[i].srAddFlower);
		BU[i].GripperControl.IN :=  BU[i].rsActivateGripper.Q1;;
		// TO DO
		// 							BU[i].srAddFlower.RESET := (i = SHFTREG.typGripper[usGripperIndex].usSetTarget);

	END_FOR
END_PROGRAM




















