PROGRAM _CYCLIC

	//=========================================Program=====================================================
	//Always check if BunchUnit is enabled, daarna controleren of de bosunit is geïnitialiseerd. 
	//Zo ja, dan mag het de 'run' cyclus beginnen, zo niet dan wordt eerst het initialisatie proces gestart. 
	BU[i].typOUT.bEnableServo := BU[i].typOUT.bStopServo AND BU[i].typInterface.bEnable AND NOT BU[i].typInterface.bReset;
	BU[i].typOUT.bStopServo := BU[i].typInterface.bEnable;
	BU[i].typOUT.bEndStageServo := BU[i].typInterface.bEnable;
	
	IF BU[i].typInterface.bReset THEN
		ServoReset(BU[i]);
		BU[i].bAddFlower := FALSE;
		BU[i].bBusyDrop := FALSE;
		BU[i].GripperControl.IN := FALSE;

		IF BU[i].typInterface.Status = BU_ST_FAILURE THEN
			BU[i].typInterface.Command := BU_CMD_Init;
		END_IF
		//Reset fault				
		IF NOT BU[i].typBunchBelts.status.bFault THEN
			bResetFault := TRUE;
		ELSE
			bResetFault := TRUE;
		END_IF
		// BU[i].typInterface.bReset := FALSE;
	ELSE
		bResetFault := FALSE;
		IF EDGEPOS( BU[i].typInterface.bSimulation ) THEN
			BU[i].typInterface.bEnable := TRUE;
			BU[i].typInterface.Status := BU_ST_RECEIVE;
			BU[i].typInterface.Command := BU_CMD_Receive;
		END_IF
		IF NOT BU[i].typInterface.bEnable THEN
			BU[i].typInterface.Status := BU_ST_DISABLED;
			BU[i].typInterface.bManualCmd := FALSE;
			bRun := FALSE;
		ELSE
			IF EDGEPOS(BU[i].typInterface.bManualCmd) THEN
				// Remove old cmd's
				BU[i].typInterface.bManualUpCmd := FALSE;
				BU[i].typInterface.bManualDownCmd := FALSE;
			END_IF

			IF  BU[i].typInterface.bManualCmd THEN
				BU[i].typInterface.Status := BU_ST_MANUAL;
				BU[i].typInterface.Command := BU_CMD_Manual;
			END_IF
			//==================================
			//Check for initialisation commando.
			//==================================
		
			IF BU[i].typInterface.Status = BU_ST_DISABLED THEN
				BU[i].typInterface.Command := BU_CMD_Init;
			END_IF
		
			//==================================
			//BunchUnit initialisation
			//==================================
		
			CASE BU[i].typInterface.Command OF	
				//==================================
				BU_CMD_Init: // 1 
				//==================================
					//Init freq. inverter bunchbelt 
					//Default speed
					BU[i].typInterface.iSpeedBunchbelt := 2700; //(90Hz) 
					//Direction setting
					bRunReverse := FALSE;
					
					//FOR TESTING PURPOSES (*TESTING*) 17-12-2014
					out_bModule1[0] := TRUE;
					out_bModule1[1] := TRUE;
					
					//Set al pneumatics to default situation.
					BU[i].typOUT.bActivateGripper := FALSE;
					BU[i].typOUT.bBunchGripper := FALSE;
										
					Elevator(BU[i], BU_ELEVATOR_UP);
					BU[i].typInterface.Command := BU_CMD_Home;
					BU[i].typInterface.Status := BU_ST_INIT;
				//==================================
				BU_CMD_Ready: // 6
				//==================================
					BU[i].typInterface.Status := BU_ST_RETURN;
					IF BU[i].typOUT.bBunchGripper THEN
						BU[i].typOUT.bBunchGripper := FALSE;
					END_IF
									
					IF NOT BU[i].typIN.bElevatorUp THEN
						Elevator(BU[i], BU_ELEVATOR_UP);
					ELSE
						//When elevator up, close releasegrippers
						BU[i].typOUT.bReleaseGripper := FALSE;
					END_IF
					
					IF BU[i].typIN.bElevatorMid OR BU[i].typIN.bElevatorUp THEN
						BU[i].typInterface.iReceivePos := Settings.iBUIdealReceivePosition;
						ServoMovePosition(BU[i],  BU[i].typInterface.iReceivePos, BU[i].typInterface.usServoSpeed); //  BU[i].typeSettings.iReceivePos +
						//Bunchbelt release
						BU[i].typInterface.bReadyForDrop := FALSE;
						bRun := FALSE;
					END_IF
					
					IF BU[i].typServo.status.SPOS.bMC AND BU[i].typIN.bElevatorUp THEN
						BU[i].typInterface.Command := BU_CMD_Receive;
						// The loop is completed, now the active BIT can be reset.
						BU[i].bAddFlower := FALSE;
						BU[i].bBusyDrop := FALSE;
					END_IF
				//==================================	
				BU_CMD_Home: // 2
				//==================================
					//Check of elevator is in upper position.
					IF BU[i].typIN.bElevatorUp THEN
						
						IF NOT BU[i].typServo.status.SPOS.bREF THEN
							//Homing servo.
							IF NOT ServoHome(BU[i]) THEN
								BU[i].typInterface.bFault := TRUE;
							END_IF
							//Check for homing complete signal.
						ELSE
							//Put usInitState to rest(99) and set usState to active(0).
							BU[i].typInterface.Status := BU_ST_HOME;
							//BU[i].typInterface.Command := BU_CMD_Drop;
							BU[i].typInterface.Command := BU_CMD_Ready;
						END_IF
					END_IF	
				//==================================
				BU_CMD_Receive: // 3
				//==================================
					//Check if frequency drive is Ready
					IF NOT BU[i].typIN.bElevatorUp  AND NOT BU[i].typInterface.bSimulation THEN
						Elevator(ThisBU := BU[i], BU_ELEVATOR_UP);
						BU[i].typInterface.Status := BU_ST_MOVE_ELEVATOR_UP;
					ELSE
						ServoMovePosition(BU[i],  BU[i].typInterface.iReceivePos, BU[i].typInterface.usServoSpeed);
						
						// ***********************************************
						// Manual add flower!!! TEST RSPA
						IF BU[i].typInterface.bAddFlowerNow THEN
							BU[i].typInterface.bAddFlowerNow := FALSE;
							SHFTREG.typGripper[usGripperIndex].usSetTarget := INT_TO_SINT(i);
							//SHFTREG.typGripper[usGripperIndex].uiTimingBU16 := 4;
						//	IF BU[i].typInterface.bEmptyCmd THEN
								SHFTREG.typGripper[usGripperIndex].siEmptyBU := INT_TO_SINT(i);
						//	END_IF
							SHFTREG.typGripper[usGripperIndex].uiCorrection := testPosition;
							// Release the Reject
							SHFTREG.typGripper[usGripperIndex].bRejectActive := TRUE;
							SHFTREG.typGripper[usGripperIndex].bRejectOnOff := FALSE;
								
							// Activate the Reject
							SHFTREG.typGripper[(usGripperIndex + 1)  MOD  SHFTREG.uiGripperCnt].bRejectActive := TRUE;
							SHFTREG.typGripper[(usGripperIndex + 1)  MOD  SHFTREG.uiGripperCnt].bRejectOnOff := TRUE;
								
							//SHFTREG.typGripANDper[0].uiTimingBU16
						END_IF
						// ***********************************************

						usGripperIndex := ( SHFTREG.typCounters.usChainCounter  ) MOD  SHFTREG.uiGripperCnt; //  + BU[i].usChainPos + RU.usChainPos  + RU.usChainPos

						// BunchBeltControl.Q is SET by the Shift register
						BU[i].BunchBeltControl(IN := BU[i].GripperControl.Q, PT := INT_TO_TIME( Settings.BU_BunchBeltTime)); // T#400ms);
						bRun := BU[i].BunchBeltControl.Q;
						IF EDGENEG(BU[i].BunchBeltControl.Q) THEN // The flower was added
							//Counting stems in bunchunit
							BU[i].typInterface.usStemCount := BU[i].typInterface.usStemCount + 1;
							// BU[i].bAddFlower := FALSE; Wordt al gedaan in shift register....
						END_IF
						
						// Move to receive position  AND (BU[i].motBunchBelts.InverterState_ = INV_ST_READY)
						IF BU[i].typServo.status.SPOS.bMC OR  BU[i].typInterface.bSimulation THEN							
							BU[i].typInterface.Status := BU_ST_RECEIVE;
						ELSIF NOT(BU[i].motBunchBelts.InverterState_ = INV_ST_READY) AND NOT BU[i].typInterface.bSimulation THEN
							BU[i].typInterface.Command := BU_CMD_Hold;
						ELSE
							BU[i].typInterface.Status := BU_ST_RECEIVE_POS; 
						END_IF
						//						// Check for next gripper
						//						IF EDGEPOS( SHFTREG.typCounters.usChainCounter) THEN
						//							// 
						//							usGripperIndex = ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt - BU[i].usChainPos) MOD  SHFTREG.uiGripperCnt;
						//							IF( SHFTREG.typGripper[usGripperIndex].usSetTarget == i)
						//								// Start timer	
//							END_IF
						//						END_IF
						
						IF NOT BU[i].bAddFlower AND NOT BU[i].GripperControl.Q AND NOT bRun AND NOT(BU[i].typInterface.Status = BU_ST_RECEIVE_POS) THEN
							// Check if must empty
							IF 	BU[i].typInterface.bEmptyCmd THEN
								BU[i].typInterface.bEmptyCmd := FALSE;
								IF NOT BU[i].typInterface.bSimulation THEN
									BU[i].bBusyDrop := TRUE;
									BU[i].typInterface.Command := BU_CMD_Drop;
								ELSE
									BU[i].bBusyDrop := FALSE;
								END_IF
							END_IF
						END_IF
					END_IF
				//==================================
				BU_CMD_Drop: // 4
				//==================================
					//Bunchbelt lock	
					BU[i].typInterface.bReadyForDrop := TRUE;	
					MBU.typInterface.bReadyToReceive := TRUE;  // TEST SHOULD BE FROM MCU!!!!!!!!!
					BU[i].typInterface.usStemCount := 0;

					tonDropDelay.PT := BU[i].typSettings.tiDropDelay;					
					IF BU[i].typIN.bElevatorUp THEN // AND NOT BU[i].typInterface.bSimulation THEN
						ServoMovePosition(BU[i], BU[i].typInterface.iReleasePos,  BU[i].typSettings.usSpeed);
						BU[i].typInterface.Status := BU_ST_DROP_POS;
						
						// AND ABS( BU[i].typInterface.iReleasePos - BU[i].Servo.status.VAL2.diPosition ) < 5
						IF (BU[i].typServo.status.SPOS.bMC  AND ABS( BU[i].typInterface.iReleasePos - BU[i].typServo.status.VAL2.diPosition ) < 5) OR  BU[i].typInterface.bSimulation THEN							
							BU[i].typInterface.Status := BU_ST_WAIT_MCU;
							IF  MBU.typInterface.bReadyToReceive OR  BU[i].typInterface.bSimulation THEN
								//Check for current position. When safe, activate elevator down. Check bunchbelt is ready to receive bunch.
								Elevator(BU[i], BU_ELEVATOR_DOWN);
								BU[i].typOUT.bBunchGripper := TRUE;
								BU[i].typInterface.Status := BU_ST_MOVE_ELEVATOR_DOWN;
								BU[i].typInterface.usStemCount := 0;
							END_IF
						END_IF
					ELSE 
						// Fase 2 of drop lowering Elevator
						IF BU[i].typIN.bElevatorDown OR tonDropDelay.IN THEN
							// Ready to drop
							BU[i].typOUT.bReleaseGripper := TRUE;
							bRun := TRUE;
							tonDropDelay.IN := TRUE;				
							tonDropDelay();
							BU[i].typInterface.Status := BU_ST_RELEASING;
							
							IF tonDropDelay.Q THEN
								tonDropDelay.IN := FALSE;
								BU[i].typOUT.bBunchGripper := TRUE;
								BU[i].typInterface.Status := BU_ST_DROPPED;
								BU[i].typInterface.Command := BU_CMD_DropReady;
								
								//JORKES 25-02-2015
								//Put flowers into shiftregister bunchbelt.
								//MBU.typInterface.bBeltShiftReg[BU[i].typSettings.usBunchBeltPosition] := TRUE;
								fbSetFlowersOnIndex(MBU, BU[i].typSettings.usBunchBeltPosition, TRUE );
							END_IF					
						END_IF
					END_IF
				//==================================				
				BU_CMD_DropReady: // 5
				//==================================
					tonDropReadyDelay.PT := BU[i].typSettings.tiDropReadyDelay;
					tonDropReadyDelay();
					tonDropReadyDelay.IN := TRUE;
					
					IF tonDropReadyDelay.Q THEN
						tonDropReadyDelay.IN := FALSE;
						BU[i].typInterface.Status := BU_ST_DROPPED;
						BU[i].typInterface.Command := BU_CMD_Ready;						
					END_IF
				//==================================
				BU_CMD_Manual:
				//==================================
					IF NOT BU[i].typInterface.bManualCmd  THEN
						BU[i].typInterface.Command := BU_CMD_Init;
					ELSE
						IF BU[i].typInterface.iManualPosition <> BU[i].typServo.command.PARA2.diPosition THEN
							ServoMovePosition(BU[i], BU[i].typInterface.iManualPosition,  BU[i].typInterface.usManualSpeed);
						END_IF
					END_IF
					IF  BU[i].typInterface.bManualUpCmd THEN
						BU[i].typInterface.bManualUpCmd := NOT (BU[i].typIN.bElevatorMid OR BU[i].typIN.bElevatorUp);
						Elevator(BU[i], BU_ELEVATOR_UP);
					END_IF
					IF  BU[i].typInterface.bManualDownCmd THEN
						BU[i].typInterface.bManualDownCmd := NOT (BU[i].typIN.bElevatorMid OR BU[i].typIN.bElevatorDown);
						Elevator(BU[i], BU_ELEVATOR_DOWN);
					END_IF
				
					IF BU[i].typInterface.bManualGripperCmd THEN
						BU[i].typOUT.bBunchGripper := TRUE;
						BU[i].typOUT.bActivateGripper := TRUE;
						BU[i].typOUT.bReleaseGripper := TRUE;
					ELSE
						BU[i].typOUT.bBunchGripper := FALSE;
						BU[i].typOUT.bActivateGripper := FALSE;
						BU[i].typOUT.bReleaseGripper := FALSE;
					END_IF
				//==================================
				BU_CMD_Hold:
				//==================================	
					BU[i].typInterface.Status := BU_ST_FAILURE;
					bRun := FALSE;
				
			END_CASE	
		END_IF		
	END_IF
	
	//======================================
	//Motor Bunchbelt
	//======================================
	//Call function motorstruct
	BU[i].motBunchBelts.bRun := bRun OR BU[i].typInterface.bToggleBunchBelt;
	BU[i].motBunchBelts.bRunReverse := bRunReverse;
	BU[i].motBunchBelts.bResetFault := bResetFault;
	BU[i].motBunchBelts.iSpeed := BU[i].typInterface.iSpeedBunchbelt;
	BU[i].motBunchBelts(MotorStruc := BU[i].typBunchBelts);	
	
	IF EDGEPOS(BU[i].typIN.bPosMove) THEN
		ServoMovePosition(BU[i],DINT_TO_INT( BU[i].typServo.command.PARA2.diPosition + 50), BU[i].typSettings.usHomeSpeed);
	END_IF

	IF EDGEPOS (BU[i].typIN.bNegMove) THEN
		ServoMovePosition(BU[i], DINT_TO_INT(BU[i].typServo.command.PARA2.diPosition - 50), BU[i].typSettings.usHomeSpeed);
	END_IF
		
	BU[i].typInterface.Status := CheckTimers(BU[i], BU[i].typInterface.Status);
	
	// Fault status for GUI
	BU[i].typInterface.bFault := NOT BU[i].typBunchBelts.packed.ModuleOk OR
									NOT BU[i].typServo.bOnLine OR
									NOT BU[i - (i MOD 2)].typIN.bOnline OR
									NOT BU[i - (i MOD 2)].typOUT.bOnline OR
									BU[i].typInterface.bManualCmd OR
									NOT BU[i].typInterface.bEnable OR
									BU[i].typInterface.Status = BU_ST_FAILURE;
				
	
	//==================================
	//Visualistion
	//==================================
	
	//ElevatorState
	IF BU[i].typIN.bElevatorDown THEN
		BU[i].typIN.ElevatorState := BU_VISU_ELEVATOR_DOWN;
	ELSIF BU[i].typIN.bElevatorMid THEN
		BU[i].typIN.ElevatorState := BU_VISU_ELEVATOR_MID;		
	ELSIF BU[i].typIN.bElevatorUp THEN
		BU[i].typIN.ElevatorState := BU_VISU_ELEVATOR_UP;
	END_IF
	
	//ReleaseState
	IF BU[i].typOUT.bReleaseGripper THEN
		BU[i].typOUT.ReleaseState := BU_VISU_RELEASE_OUT;		
	ELSE
		BU[i].typOUT.ReleaseState := BU_VISU_RELEASE_IN;;
	END_IF
		
	//GripperState
	IF BU[i].typOUT.bActivateGripper THEN
		BU[i].typOUT.GripperState := BU_VISU_GRIPPER_OUT;		
	ELSE
		BU[i].typOUT.GripperState := BU_VISU_GRIPPER_IN;
	END_IF	

END_PROGRAM

      