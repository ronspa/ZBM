(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * File: Global.typ
 * Author: jorkes
 * Created: July 07, 2014
 ********************************************************************
 * Global data types of project The_Magnifica
 ********************************************************************)

TYPE
	_visuInv : 	STRUCT 
		bRunReverse : BOOL;
		bResetFault : BOOL;
		bRun : BOOL;
		bSetParams : BOOL;
		iSpeed : INT;
		bGetSpeed : BOOL;
		bSetSpeed : BOOL;
		bDriveReady : BOOL;
		bEnableManual : BOOL;
	END_STRUCT;
	enumError : 
		(
		OK,
		EMERGENCYSTOP,
		DOOROPEN,
		AIRPRESSURE,
		BINDER,
		MOTORMALFUNCTION,
		SERVICEMODE,
		COMMUNICATION
		);
	enumState : 
		( (*Machine State*)
		RUN,
		PAUZE, (*Not used*)
		STOP,
		EMPTY,
		SIMULATION
		);
	_muOUT : 	STRUCT 
		bCamTrigger1 : BOOL := FALSE;
		bLightTrigger1 : BOOL := FALSE;
		bCamTrigger2 : BOOL := FALSE;
		bLightTrigger2 : BOOL := FALSE;
		bCamTrigger3 : BOOL := FALSE;
		bLightTrigger3 : BOOL := FALSE;
		bCamTrigger4 : BOOL := FALSE;
		bLightTrigger4 : BOOL := FALSE;
		bResetDoorOpen : BOOL := FALSE;
		bResetEmergencyStop : BOOL := FALSE;
		bGreenLight : BOOL := TRUE;
		bRedLight : BOOL := TRUE;
		bBuzzer : BOOL := FALSE;
		bMachineShutDown : BOOL := FALSE; (*Power down machine*)
	END_STRUCT;
	_muIN : 	STRUCT 
		bEncPuls1 : BOOL := FALSE;
		bEncPuls2 : BOOL := FALSE;
		bDoorOpen : BOOL := FALSE;
		bEmergencyStop : BOOL := FALSE;
		bServiceMode : BOOL := FALSE;
		bBinder : BOOL := FALSE;
		bAirpressure : BOOL := FALSE;
		bJog : BOOL := FALSE;
	END_STRUCT;
	Register : 	STRUCT 
		reg0 : INT;
		reg1 : INT;
		reg2 : INT;
		reg3 : INT;
		reg4 : INT;
		reg5 : INT;
		reg6 : INT;
		reg7 : INT;
		reg8 : INT;
		reg9 : INT;
		reg10 : INT;
		reg11 : INT;
		reg12 : INT;
		reg13 : INT;
		reg14 : INT;
		reg15 : INT;
		reg16 : INT;
		reg17 : INT;
		reg18 : INT;
		reg19 : INT;
	END_STRUCT;
	Trigger : 	STRUCT 
		Coil0 : BOOL;
		Coil1 : BOOL;
		Coil2 : BOOL;
		Coil3 : BOOL;
		Coil4 : BOOL;
		Coil5 : BOOL;
		Coil6 : BOOL;
		Coil7 : BOOL;
		Coil8 : BOOL;
		Coil9 : BOOL;
	END_STRUCT;
	InterfaceMCU : 	STRUCT 
		bEnabled : BOOL := FALSE; (*MCU Enabled*)
		bReset : BOOL := FALSE; (*MCU Reset *)
		bEmpty : BOOL := FALSE; (*MCU Empty machine*)
		bIsEmpty : BOOL := FALSE; (*Machine is empty*)
		bRun : BOOL := FALSE; (*MCU Start running*)
		bToggle : BOOL := FALSE; (*Toggle MCU (auto reset)*)
		bSimulation : BOOL := FALSE; (*Should be false on system*)
		bBuzzer : BOOL := FALSE; (*Buzzer by user*)
		bCamTrigManual : BOOL := FALSE; (*Manual camtrigger*)
		State : enumState := STOP;
		iJogSpeed : INT := 300; (*20Hz*)
		iNormalSpeed : INT := 1500; (*50Hz*)
		iRegisters : Register;
		bTriggers : Trigger;
		iBUEnabledMask : INT := 0;
	END_STRUCT;
	SettingsType : 	STRUCT  (*Settings worden overschreven vanuit de PC*)
		Mode : INT; (*0=STOP, 1=RUN, 2=EMPTY*)
		CamDelay1 : INT := 10; (*ms*)
		CamDelay2 : INT := 10; (*ms*)
		CamDelay3 : INT := 10; (*ms*)
		CamDelay4 : INT := 10; (*ms*)
		CamPosition1 : INT := 8; (*0-15*)
		CamPosition2 : INT := 12; (*0-15*)
		CamPosition3 : INT := 14; (*0-15*)
		CamPosition4 : INT := 6; (*0-15*)
		CamPulseLength : INT := 10; (*ms*)
		FlitsBefore : INT := 20; (*ms*)
		FlitsAfter : INT := 15; (*ms*)
		RejectPosition : INT := 151; (*Position relative to gripper *16*)
		BosUnit1Position : INT; (*Position relative to gripper *16*)
		BosUnit2Position : INT; (*Position relative to gripper *16*)
		BosUnit3Position : INT; (*Position relative to gripper *16*)
		BosUnit4Position : INT; (*Position relative to gripper *16*)
		BosUnit5Position : INT; (*Position relative to gripper *16*)
		BosUnit6Position : INT; (*Position relative to gripper *16*)
		BosUnit7Position : INT; (*Position relative to gripper *16*)
		BosUnit8Position : INT; (*Position relative to gripper *16*)
		BosUnit9Position : INT; (*Position relative to gripper *16*)
		BosUnit10Position : INT; (*Position relative to gripper *16*)
		BU_BunchBeltTime : INT := 1200; (*ms dat de belt draait*)
		BU_ActivateReleaseTime : INT := 600; (*ms dat de dropper is activated*)
		HeartBeatTime : INT := 5000; (*ms*)
		iBUIdealReceivePosition : INT := 400;
		iBUIdealReceivePositionGui : INT; (*Buffer om de GU update in op te slaan*)
	END_STRUCT;
	MainControlUnit : 	STRUCT  (*Verzameling parameters hoofdkast*)
		typOUT : _muOUT;
		typIN : _muIN;
		typInterface : InterfaceMCU; (*Interface*)
		typChain : AcpInverter_typ;
		motChain : ACPinverter;
	END_STRUCT;
END_TYPE
