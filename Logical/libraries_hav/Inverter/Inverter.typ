(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Invertor
 * File: Invertor.typ
 * Author: daaneh
 * Created: March 15, 2011
 ********************************************************************
 * Data types of library Invertor
 ********************************************************************)

TYPE
	enumINV_ST : 
		(
		INV_ST_READY := 0,
		INV_ST_FAULT := 1,
		INV_ST_RUN := 2
		);
	enumINV_CMD : 
		(
		INV_CMD_INIT := 0,
		INV_CMD_SETSPEED := 1,
		INV_CMD_POWERON := 2,
		INV_CMD_RESETFAULT := 3,
		INV_CMD_READY := 4,
		INV_CMD_ERROR := 5
		);
	AcpInverter_typ : 	STRUCT 
		command : AcpInverter_command_typ;
		status : AcpInverter_status_typ;
		packed : AcpInverter_packed_typ;
		SDO : SDO_type;
	END_STRUCT;
	AcpInverter_command_typ : 	STRUCT 
		iSetSpeed : INT; (*Speed Hz*)
		bPower : BOOL; (*switch drive on*)
		bRun : BOOL; (*run velocity*)
		bRunReverse : BOOL; (*run reverse *)
		bEnabledStop : BOOL;
		bQuickStop : BOOL; (*emergency stop*)
		bResetFault : BOOL; (*reset fault*)
	END_STRUCT;
	AcpInverter_status_typ : 	STRUCT 
		uiDrive : UINT; (*drive status 8 bits*)
		bReadyToSwitchOn : BOOL; (*ready for power on*)
		bDriveReady : BOOL; (*power switched on*)
		bRun : BOOL; (*run forward*)
		bSetSpeedReached : BOOL; (*Set speed reached*)
		bQuickStopActive : BOOL; (*emergency stop*)
		bFault : BOOL; (*drive in fault state*)
		strHmiInfo : STRING[80]; (*drive info*)
		strErrorInfo : STRING[80]; (*fault info*)
	END_STRUCT;
	AcpInverter_packed_typ : 	STRUCT 
		ETAD : UINT; (*status word*)
		ETI : UINT; (*extended status word*)
		LCR : UINT; (*current 0.1 A*)
		CMDD : UINT; (*command word*)
		CMI : UINT; (*extended command word*)
		ERRD : UINT; (*fault code*)
		HMIS : UINT; (*drive state*)
		RFR : INT; (*output frequentie*)
		RFRD : INT; (*output rpm*)
		OTR : INT; (*Torque %*)
		LFR : INT; (*frequentie setpoint *)
		LFRD : INT; (*Rpm setpoint*)
		LFT : INT; (*last detected fault*)
		ModuleOk : BOOL; (*module OK*)
		Relay : BOOL; (*relay*)
		DigOutput : BOOL; (*digital output*)
	END_STRUCT;
END_TYPE
