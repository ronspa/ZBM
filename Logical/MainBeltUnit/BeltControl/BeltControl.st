(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: BeltControl
 * File: BeltControl.st
 * Author: jorkes
 * Created: November 28, 2014
 ********************************************************************
 * Implementation of program BeltControl
 ********************************************************************)

PROGRAM _INIT
	BeltSize := 39; //SIZEOF(	MBU.typInterface.bBeltShiftReg)/SIZEOF(	MBU.typInterface.bBeltShiftReg[idx]);
	MBU.typInterface.Command := MBU_CMD_INIT;
END_PROGRAM


PROGRAM _CYCLIC	
	bResetFault := FALSE;
	
	//Shift bunchbelt after beltsensor puls
	fbShiftBelt(MBU, EDGEPOS(SensControl_0.Q));	
	
	//======================================
	//Reading sensors main belt
	//======================================
	
	//Vakkenband
	SensControl_0(IN := MBU.in_bMainBeltSensor1, tiSensDelay := MBU.typInterface.tiSensDelay1, tiSensPuls := MBU.typInterface.tiSensPuls);
	//Sponsband
	SensControl_1(IN := MBU.in_bMainBeltSensor2, tiSensDelay := MBU.typInterface.tiSensDelay2, tiSensPuls := MBU.typInterface.tiSensPuls);

	//After sensor puls do
	BindControl_0.IN := fbHasFlowersOnIndex(MBU,MBU.typInterface.usBindPos1) AND EDGEPOS(SensControl_0.Q); //MBU.typInterface.bBeltShiftReg[MBU.typInterface.usBindPos1];
	BindControl_1.IN := fbHasFlowersOnIndex(MBU,MBU.typInterface.usBindPos2) AND EDGEPOS(SensControl_0.Q); // MBU.typInterface.bBeltShiftReg[MBU.typInterface.usBindPos2];
	BufferControl.IN := fbHasFlowersOnIndex(MBU,MBU.typInterface.usAflegPos) AND EDGEPOS(SensControl_0.Q); //MBU.typInterface.bBeltShiftReg[MBU.typInterface.usAflegPos];
	KnifeControl.IN := fbHasFlowersOnIndex(MBU,MBU.typInterface.usKnifePos) AND EDGEPOS(SensControl_0.Q); //MBU.typInterface.bBeltShiftReg[MBU.typInterface.usKnifePos];
	
	IF EDGEPOS(MBU.typInterface.bEnable) AND MBU.typInterface.bEnable THEN
		MBU.typInterface.Command := MBU_CMD_INIT;
		MBU.typInterface.uiStepCount_0 := 0;
		MBU.typInterface.uiStepCount_1 := 0;
	END_IF
	
	// Log test van RONSPA	
	//	IF EDGENEG(MBU.typInterface.bSimulate) THEN
	//		AsArLogWrite_1(enable := TRUE, ident := arlogBASE_USER_LOG_IDENT, logLevel := 1, errornr := 50000, mem := 0, len := 0, asciiString := ADR('MBU simulation OFF') );		
	//		//UserLogEvent := TRUE;
	//	END_IF
	//
	//	IF EDGEPOS(MBU.typInterface.bSimulate) THEN
	//		AsArLogWrite_0(enable := TRUE, ident := arlogBASE_USER_LOG_IDENT, logLevel := 1, errornr := 50001, mem := 0, len := 0, asciiString := ADR('MBU simulation on') );		
	//		//UserLogEvent := TRUE;
	//	END_IF	
	
	IF MBU.typInterface.bEnable AND NOT MBU.typInterface.bSimulate AND NOT MBU.typInterface.bReset THEN
		CASE MBU.typInterface.Command OF			
			//======================================
			MBU_CMD_INIT:	
				//======================================
				//MBU state
				MBU.typInterface.State := MBU_ST_INIT;
				MBU.typInterface.bFault := FALSE;
				
				//Inverter Motor 1 
				//Vakkenband
				iSpeed1 := 690; //(23Hz)
				bRunReverse1 := FALSE;
				
				//Inverter Motor 2
				//Sponsband
				iSpeed2 := 670; //(22.3Hz)
				bRunReverse2 := FALSE;
				
				//Knife Motor
				iSpeed3 := 300;	//(10Hz)
				bRunReverse3 := FALSE;
				
				//Buffer Motor
				iSpeed4 := 600; //(20Hz)
				bRunReverse4 := FALSE;
								
				//Clear shiftregister bunchbelt
				IF NOT MBU.typInterface.bReset THEN //AND FALSE THEN
					FOR idx := 0 TO BeltSize - 1 DO
						fbSetFlowersOnIndex(MBU, idx, FALSE);  //		MBU.typInterface.bBeltShiftReg[idx] := FALSE;					
					END_FOR
				END_IF
			
				//Check if frequency drive is Ready		
				IF NOT( (MBU.motBelt1.InverterState_ = INV_ST_READY) OR NOT(MBU.motBelt2.InverterState_ = INV_ST_READY) ) THEN// OR (MBU.motKnifeUnit.InverterState_ = INV_ST_READY) OR (MBU.motBufferBelt.InverterState_ = INV_ST_READY) )THEN
					MBU.typInterface.bFault := TRUE;
					MBU.typInterface.Command := MBU_CMD_STOP;
				ELSE
					MBU.typInterface.Command := MBU_CMD_RUN;					
				END_IF
			
			//======================================
			MBU_CMD_RUN:
				//======================================				
				tiActual := clock_ms();
				
				CASE ST_BELT OF
					//------------------------------------------------------
					CMD_WAIT:	//Check usMovePositions, if not NULL then move belt.
						//------------------------------------------------------
						IF  NOT(fbCheckBUReadyForDrop(BU, BUCount)) THEN
							IF (MBU.typInterface.usMovePositions <> 0) THEN
								MBU.typInterface.State := MBU_ST_RUN;
								MBU.typInterface.bReadyToReceive := FALSE;
							
								bRun1 := TRUE;	//Vakkenband					
								bRun2 := TRUE;  //Sponsband
							
								//Sla tijd op zodra de bosband(en) start(en). 
								tiStart1 := clock_ms();
								tiStart2 := tiStart1;
								ST_BELT := CMD_MOVE;
							ELSE
								MBU.typInterface.State := MBU_ST_READY;
							END_IF
						ELSE
							MBU.typInterface.State := MBU_ST_HOLD_DROP;
						END_IF		
					//------------------------------------------------------
					CMD_MOVE:  //Move belt x positions
					//------------------------------------------------------

						//Vakkenband
						IF EDGEPOS(SensControl_0.Q) THEN
							IF bSensCheck0 THEN
								MBU.typInterface.State := MBU_ST_VAK_SENS_ERROR;
								MBU.typInterface.Command := MBU_CMD_FAULT;
							END_IF
							MBU.typInterface.uiStepCount_0 := MBU.typInterface.uiStepCount_0 + 1;
							bSensCheck0 := TRUE;
							bRun1 := FALSE;
							tiStop1 := clock_ms();
							tiDiff1[idx_Diff1] := tiStop1 - tiStart1;
							idx_Diff1 := (idx_Diff1 + 1) MOD 10;
						END_IF
						
						//Sponsband
						IF EDGEPOS(SensControl_1.Q) THEN
							IF bSensCheck1 THEN
								MBU.typInterface.State := MBU_ST_SPONS_SENS_ERROR;
								MBU.typInterface.Command := MBU_CMD_FAULT;
							END_IF
							MBU.typInterface.uiStepCount_1 := MBU.typInterface.uiStepCount_1 + 1;
							bSensCheck1 := TRUE;
							bRun2 := FALSE;
							tiStop2 := clock_ms();
							tiDiff2[idx_Diff2] := tiStop2 - tiStart2;
							idx_Diff2 := (idx_Diff2 + 1) MOD 10;
						END_IF				
						
						IF bSensCheck0 AND bSensCheck1 THEN
							MBU.typInterface.usMovePositions := MBU.typInterface.usMovePositions - 1;
							bSensCheck0 := FALSE;
							bSensCheck1 := FALSE;
							IF (MBU.typInterface.usMovePositions > 1) THEN
								bRun1 := TRUE;	//Vakkenband					
								bRun2 := TRUE;  //Sponsband
							ELSE							
								bRun1 := FALSE;	//Vakkenband					
								bRun2 := FALSE;  //Sponsband
								MBU.typInterface.bReadyToReceive := TRUE;
								MBU.typInterface.State := MBU_ST_READY;
								ST_BELT := CMD_WAIT;			
							END_IF
						END_IF
					//------------------------------------------------------
				END_CASE
			
			//======================================
			MBU_CMD_STOP:
				//======================================
				MBU.typInterface.State := MBU_ST_ERROR;
			//======================================
			MBU_CMD_MANUAL:
			//======================================
				
			//======================================
			MBU_CMD_FAULT:
			//======================================
				MBU.typInterface.bFault := TRUE;
				bRun1 := FALSE;
				bRun2 := FALSE;
				bSensCheck0 := FALSE;
				bSensCheck1 := FALSE;
		END_CASE
				
	ELSIF MBU.typInterface.bReset THEN
		//freq. regelaaars
		bResetFault := TRUE;
		MBU.typInterface.bReset := FALSE;
		MBU.typInterface.Command := MBU_CMD_RUN; // Init gooit de buffers leeg.
		
	ELSIF MBU.typInterface.bSimulate THEN
		MBU.typInterface.State := MBU_ST_SIMULATED;
	ELSE
		MBU.typInterface.State := MBU_ST_DISABLED;
	END_IF
	
	//Call function blocks
	BindControl_1(tiSensDelay := MBU.typInterface.tiBindDelay2, tiSensPuls := MBU.typInterface.tiBindPuls);
	BindControl_0(tiSensDelay := MBU.typInterface.tiBindDelay1, tiSensPuls := MBU.typInterface.tiBindPuls);
	BufferControl(tiSensDelay := MBU.typInterface.tiBufferDelay, tiSensPuls := MBU.typInterface.tiBufferPuls);
	KnifeControl(tiSensDelay := T#1ms, tiSensPuls := MBU.typInterface.tiKnifePuls);
	
	//======================================
	//Outputs for binders
	//======================================
	MBU.out_bBinder1 := BindControl_0.Q;
	MBU.out_bBinder2 := BindControl_1.Q;
	bRun3 := KnifeControl.Q;
	bRun4 := BufferControl.Q;
		
	//======================================
	//Countup index of shiftregister bunchbelt
	//======================================
	IF EDGEPOS(SensControl_0.Q) OR MBU.typInterface.bSimulate THEN			
		idxBeltPos := (idxBeltPos + 1) MOD MBU.typInterface.usBunchPositions;
	END_IF
		
	//======================================
	//Motor BeltControl 1
	//Vakkenband
	//======================================
	MBU.motBelt1.bRun := bRun1 OR MBU.typInterface.bToggleBelt;
	MBU.motBelt1.bRunReverse := FALSE;
	MBU.motBelt1.bResetFault := bResetFault;
	MBU.motBelt1.iSpeed := iSpeed1;
	MBU.motBelt1(MotorStruc := MBU.typBeltMotor1);	
	
	//======================================
	//Motor BeltControl 2
	//Sponsband
	//======================================
	MBU.motBelt2.bRun := bRun2 OR MBU.typInterface.bToggleBelt;
	MBU.motBelt2.bRunReverse := FALSE;
	MBU.motBelt2.bResetFault := bResetFault;
	MBU.motBelt2.iSpeed := iSpeed2;
	MBU.motBelt2(MotorStruc := MBU.typBeltMotor2);
	
	//======================================
	//Motor Knife
	//======================================
	MBU.motKnifeUnit.bRun := bRun3 OR MBU.typInterface.bToggleKnife OR MBU.typInterface.bToggleBelt; //bToggleBelt just for test JORKES
	MBU.motKnifeUnit.bRunReverse := FALSE;
	MBU.motKnifeUnit.bResetFault := bResetFault;
	MBU.motKnifeUnit.iSpeed := iSpeed3;
	MBU.motKnifeUnit(MotorStruc := MBU.typKnifeUnit);
	
	//======================================
	//Motor Bufferbelt
	//======================================
	MBU.motBufferBelt.bRun := bRun4 OR MBU.typInterface.bToggleBuffer OR MBU.typInterface.bToggleBelt; //bToggleBelt just for test JORKES
	MBU.motBufferBelt.bRunReverse := FALSE;
	MBU.motBufferBelt.bResetFault := bResetFault;
	MBU.motBufferBelt.iSpeed := iSpeed4;
	MBU.motBufferBelt(MotorStruc := MBU.typBufferMotor);	
	
	// MBU State
	MBU.typInterface.bFault := MBU.typBeltMotor1.status.bFault OR 
	MBU.typBeltMotor2.status.bFault OR 
	MBU.typBufferMotor.status.bFault OR 
	MBU.typKnifeUnit.status.bFault OR 
	MBU.typInterface.bSimulate;
END_PROGRAM
