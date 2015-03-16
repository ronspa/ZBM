(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: Main
 * File: Main.st
 * Author: jorkes
 * Created: August 14, 2014
 ********************************************************************
 * Implementation of program Main
 ********************************************************************)

PROGRAM _CYCLIC
	//TestPuls(tiHigh := T#40ms, tiLow := T#20ms);
	MCU.motChain.bResetFault := FALSE;
	MBU.motKnifeUnit.bResetFault := FALSE;
	MCU.typOUT.bBuzzer := FALSE;

	// If software toggle is activated, override the input.
	IF MCU.typInterface.bToggle THEN
		MCU.typIN.bJog := MCU.typInterface.bToggle;
	END_IF
	
	IF EDGEPOS(MCU.typIN.bJog) THEN
		MCU.motChain.iSpeed := MCU.typInterface.iJogSpeed;
		MCU.motChain.bResetFault := TRUE;
	END_IF

	IF EDGENEG(MCU.typIN.bJog) OR EDGEPOS(MCU.typInterface.bRun) THEN
		MCU.motChain.iSpeed := MCU.typInterface.iNormalSpeed;
		MCU.motChain.bResetFault := TRUE;
		MBU.motKnifeUnit.bResetFault := TRUE;
	END_IF

	IF EDGENEG(MCU.typInterface.bRun) THEN
				
		iBUEnabledMask := -1;
		FOR i := 0 TO 9 BY 1 DO
			//
			BU[i].typInterface.bEnable := FALSE;
		END_FOR

		IF  MCU.typChain.status.bFault THEN
			// Reset drive
			MCU.motChain.bResetFault := TRUE;
		END_IF
	END_IF

	IF MCU.typInterface.bReset THEN
		MCU.motChain.bResetFault := TRUE;
		MBU.motKnifeUnit.bResetFault := TRUE;
		MCU.typInterface.bReset := FALSE;
		MCU.typInterface.bRun := FALSE;
	ELSE
		IF  MCU.typInterface.bRun  THEN
			// 
			IF MCU.typInterface.iBUEnabledMask <> iBUEnabledMask THEN
				iBUEnabledMask := MCU.typInterface.iBUEnabledMask;
				FOR i := 0 TO 9 BY 1 DO
					//
					iOut := SHL(iMask, i);
					BU[i].typInterface.bEnable :=  (iMask AND iBUEnabledMask) = 0;
					//BU[i].typInterface.bEnable :=  (SHL(1, i) AND iBUEnabledMask) = 0;
				END_FOR
					
			END_IF
			IF MCU.typInterface.bEmpty THEN
				// Start empty machine
				IF MCU.typInterface.bIsEmpty THEN
					MCU.typInterface.bRun := FALSE;
				END_IF
			ELSE
				// Normal RUN
				IF MCU.typChain.status.bRun THEN
					MCU.typInterface.State := RUN;
				ELSE
					IF MCU.typChain.status.bFault THEN
						// Drive in error remove command
						MCU.typInterface.bRun := FALSE;
					ELSE
						bRunRequest := TRUE;
					END_IF
				END_IF
			END_IF
		ELSE
			// bRun is False.
			bRunRequest := FALSE;
			MCU.typInterface.bEmpty := FALSE;
		END_IF
	END_IF
	
	
	CASE MCU.typInterface.State OF
		RUN: // Start main motor
			IF MCU.typChain.status.bFault = TRUE OR NOT MCU.typInterface.bRun THEN
				MCU.typInterface.State := STOP;
			ELSE
				MCU.typChain.command.bPower := TRUE;
				bRunRequest := TRUE;
				IF MCU.typChain.status.bSetSpeedReached THEN
					MCU.typInterface.State := RUN;
				END_IF
			END_IF
		STOP:
			bRunRequest := FALSE;
			bGblSimulation := FALSE;
			IF 	MCU.typInterface.bRun THEN
				IF NOT MCU.typInterface.bSimulation THEN
					MCU.typInterface.State := RUN;
				ELSE
					MCU.typInterface.State := SIMULATION;
				END_IF
			END_IF
		EMPTY:
			IF MCU.typChain.status.bFault = TRUE THEN
				MCU.typInterface.State := STOP;
			ELSE
				MCU.typInterface.State := EMPTY;
			END_IF
		
		SIMULATION:
			bGblSimulation := MCU.typInterface.bEnabled AND  MCU.typInterface.bSimulation;
			IF NOT MCU.typInterface.bRun THEN
				MCU.typInterface.State := STOP;
				bGblSimulation := FALSE;
			ELSE
				MCU.typInterface.State := SIMULATION;
			END_IF
	END_CASE
	// END_IF
	
	
	//tonStart(IN := MCU.typInterface.bRun, PT := T#3s);
	// When starting the chain, first sound a zoomer.
	tonStart(IN := bRunRequest OR MCU.typIN.bJog, PT := T#3s);
	tonJogDelay(IN := (srJogDelay.Q1 AND NOT  MCU.typIN.bJog) , PT := T#5s);
	srJogDelay( SET1 := EDGENEG( MCU.typIN.bJog), RESET := tonJogDelay.Q AND NOT (bRunRequest OR MCU.typIN.bJog));
	bRunRequest := tonStart.Q;
	IF  (srJogDelay.Q1) AND NOT bRunRequest THEN
		bRunRequest := bRunRequest OR MCU.typIN.bJog;
	END_IF

	MCU.typOUT.bBuzzer := bRunRequest <> tonStart.IN OR MCU.typInterface.bBuzzer;
	// If the MCU.typInterface.bBuzzer is not reset in 5 sec. The auto reset zoomer.
	tonBuzzerReset( IN := MCU.typInterface.bBuzzer, PT := T#5s);
	IF( tonBuzzerReset.Q ) THEN
		MCU.typInterface.bBuzzer := FALSE;
	END_IF

	// Set the command to the drive
	MCU.motChain.bRun := bRunRequest;
	MCU.motChain.bRunReverse := FALSE;
	MCU.motChain( MotorStruc := MCU.typChain);
	
	//JORKES 18022015
	//Camera trigger manual
	IF MCU.typInterface.State = STOP THEN
		//Use bBuzzer for triggering camera's when machine is in STOP or PAUZE state.
		//MCU.typInterface.bCamTrigManual := MCU.typInterface.bBuzzer;
		
		//Create light triggers.
		tpLightTrig1(IN := MCU.typInterface.bCamTrigManual, PT := tiLightPuls);
		tpLightTrig2(IN := EDGENEG(tpLightTrig1.Q), PT := tiLightPuls);
		tpLightTrig3(IN := EDGENEG(tpLightTrig2.Q), PT := tiLightPuls);
		tpLightTrig4(IN := EDGENEG(tpLightTrig3.Q), PT := tiLightPuls);
		
		//Create cam triggers.
		tpCamTrig1(IN := EDGEPOS(tpLightTrig1.ET >= T#10ms), PT := tiCamPuls);
		tpCamTrig2(IN := EDGEPOS(tpLightTrig2.ET >= T#10ms), PT := tiCamPuls);
		tpCamTrig3(IN := EDGEPOS(tpLightTrig3.ET >= T#10ms), PT := tiCamPuls);
		tpCamTrig4(IN := EDGEPOS(tpLightTrig4.ET >= T#10ms), PT := tiCamPuls);		
		
		//Set outputs for light's.
		MCU.typOUT.bLightTrigger1 := tpLightTrig1.Q; 
		MCU.typOUT.bLightTrigger2 := tpLightTrig2.Q; 
		MCU.typOUT.bLightTrigger3 := tpLightTrig3.Q; 
		MCU.typOUT.bLightTrigger4 := tpLightTrig4.Q; 
		
		//Set outputs for camera's.
		MCU.typOUT.bCamTrigger1 := tpCamTrig1.Q;
		MCU.typOUT.bCamTrigger2 := tpCamTrig2.Q;
		MCU.typOUT.bCamTrigger3 := tpCamTrig3.Q;
		MCU.typOUT.bCamTrigger4 := tpCamTrig4.Q;
	END_IF
	
END_PROGRAM
