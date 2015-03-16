(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * File: BU.typ
 * Author: ronspa
 * Created: September 22, 2014
 ********************************************************************
 * Global data types of project The_Magnifica_v0127
 ********************************************************************)

TYPE
	BU_Elevator_enum : 
		(
		BU_ELEVATOR_UP := 0,
		BU_ELEVATOR_DOWN := 1
		);
	BU_Visu_Release_enum : 
		(
		BU_VISU_RELEASE_OUT := 0,
		BU_VISU_RELEASE_IN := 1
		);
	BU_Visu_Gripper_enum : 
		(
		BU_VISU_GRIPPER_OUT := 0,
		BU_VISU_GRIPPER_IN := 1
		);
	BU_Visu_Elevator_enum : 
		(
		BU_VISU_ELEVATOR_UP := 0,
		BU_VISU_ELEVATOR_MID := 1,
		BU_VISU_ELEVATOR_DOWN := 2
		);
	BU_Status_enum : 
		(
		BU_ST_DISABLED := 0,
		BU_ST_INIT := 1,
		BU_ST_HOME := 2,
		BU_ST_RECEIVE := 3,
		BU_ST_FULL := 4,
		BU_ST_DROPPED := 5,
		BU_ST_RETURN := 6,
		BU_ST_FAILURE := 7,
		BU_ST_TIMEOUT_LIFT := 8,
		BU_ST_TIMEOUT_POSITION := 9,
		BU_ST_MANUAL := 10,
		BU_ST_DROP_POS := 11,
		BU_ST_RECEIVE_POS := 12,
		BU_ST_MOVE_ELEVATOR_UP := 13,
		BU_ST_MOVE_ELEVATOR_DOWN := 14,
		BU_ST_RELEASING := 15,
		BU_ST_WAIT_MCU := 16
		);
	BU_Command_Enum : 
		(
		BU_CMD_Ready := 1,
		BU_CMD_Init := 2,
		BU_CMD_Home := 3,
		BU_CMD_Receive := 4,
		BU_CMD_Drop := 5,
		BU_CMD_DropReady := 6,
		BU_CMD_Manual := 7,
		BU_CMD_Hold := 8
		);
	SettingsBU : 	STRUCT 
		uiNextChainDelay : UINT := 0; (*Delay in [ms] to enable trigger afther usNextChainInput*)
		iReceivePos : INT := 50;
		iReleasePos : INT := 450;
		usHomeSpeed : USINT := 10; (*Homing speed*)
		usSpeed : USINT := 50; (*Normal servo speed*)
		usFastSpeed : USINT := 90; (*Fast servo speed*)
		iMaxPosDev2UseLift : INT := 10;
		tiDropDelay : TIME := T#1ms;
		tiDropReadyDelay : TIME := T#500ms;
		iSafeElevatorPosStart : INT := 92; (*Positie waar de elevator pas mag zakken naar de drop positie*)
		iSafeElevatorPosStartVak : INT := 246;
		iSafeElevatorPosEndVak : INT := 443;
		iSafeElevatorPosEnd : INT := 530;
		tiBunchBeltPulse : TIME := T#500ms;
		usTimingBU16 : USINT := 5; (*Pos=7*)
		usBunchBeltPosition : USINT;
	END_STRUCT;
	InterfaceBU : 	STRUCT 
		usNextChainInput : SINT; (*ID of the chain containing the next flower 255  for none*)
		bReset : BOOL;
		bEnable : BOOL;
		iReleasePos : INT := 125;
		iReceivePos : INT := 265;
		usServoSpeed : USINT := 10; (*Bos Unit default speed 0-100 %*)
		bHomeCmd : BOOL; (*Move to home*)
		Command : BU_Command_Enum := BU_CMD_Ready;
		Status : BU_Status_enum := BU_ST_DISABLED;
		usError : USINT;
		bEmptyCmd : BOOL;
		bEmptyPerm : BOOL;
		bManualUpCmd : BOOL;
		bManualCmd : BOOL;
		bManualDownCmd : BOOL;
		iManualPosition : INT := 500;
		usManualSpeed : USINT := 50;
		usStemTarget : USINT := 4;
		usStemCount : USINT;
		iSpeedBunchbelt : INT := 2700; (*90Hz*)
		tiDelayActivateBunchBelts : TIME := T#2150ms; (*150*)
		tiDelayActiveGripper : TIME := T#500ms; (*150*)
		bReadyForDrop : BOOL := FALSE;
		bSimulation : BOOL := FALSE;
		bToggleBunchBelt : BOOL := FALSE; (*Draai even de Bunch belt*)
		bManualGripperCmd : BOOL := FALSE; (*Aktiveer alle grippers*)
		bAddFlowerNow : BOOL := FALSE; (*Voeg voor test een bloem toe*)
		bFault : BOOL := TRUE; (*Hoog als er een fout is*)
	END_STRUCT;
	BunchUnit : 	STRUCT  (*Verzameling parameters bosunit*)
		typOUT : _buOUT;
		typIN : _buIN;
		usUnitNmbr : USINT := 0;
		usChainPos : USINT := 0;
		usErrorState : USINT := 99;
		typServo : Servo_typ;
		typInterface : InterfaceBU;
		typSettings : SettingsBU;
		typBunchBelts : AcpInverter_typ;
		motBunchBelts : ACPinverter;
		BunchBeltControl : TOF;
		GripperControl : TOF;
		rsActivateGripper : RS;
		bAddFlower : BOOL := FALSE;
		bBusyDrop : BOOL := FALSE;
	END_STRUCT;
	_buOUT : 	STRUCT 
		bOnline : BOOL;
		bElevator : BOOL := FALSE;
		bActivateGripper : BOOL := FALSE;
		bBunchGripper : BOOL := FALSE;
		bReleaseGripper : BOOL := FALSE; (*Release load from gripper to conveyor*)
		GripperState : BU_Visu_Gripper_enum;
		ReleaseState : BU_Visu_Release_enum;
		ElevatorState : BU_Elevator_enum;
		bStopServo : BOOL := FALSE; (*Extra Stop uit I?O-Lijst*)
		bEndStageServo : BOOL := FALSE; (*idem*)
		bEnableServo : BOOL := FALSE; (*idem*)
	END_STRUCT;
	_buIN : 	STRUCT 
		bOnline : BOOL;
		bPosHome : BOOL := FALSE;
		bElevatorUp : BOOL := FALSE;
		bElevatorMid : BOOL := FALSE;
		bElevatorDown : BOOL := FALSE;
		bTestUnit : BOOL := FALSE;
		bNegMove : BOOL := FALSE;
		bPosMove : BOOL := FALSE;
		ElevatorState : BU_Visu_Elevator_enum;
		in : ARRAY[0..7]OF BOOL; (*//Used for IO Handling (Fast task)*)
	END_STRUCT;
END_TYPE
