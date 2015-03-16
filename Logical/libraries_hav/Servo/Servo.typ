(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: BULib
 * File: Servo.typ
 * Author: ronspa
 * Created: September 29, 2014
 ********************************************************************
 * Data types of library BULib
 ********************************************************************)

TYPE
	stat_type : 	STRUCT 
		SCON : SCON_status_typ;
		SPOS : SPOS_status_typ;
		SDIR : SDIR_status_typ;
		VAL2 : VAL2_stat_type;
		VAL1 : VAL1_stat_type;
	END_STRUCT;
	SPOS_status_typ : 	STRUCT 
		bHALT : BOOL; (*Halt*)
		bACK : BOOL; (*Acknowledge start*)
		bMC : BOOL; (*Motion complete*)
		bTEACH : BOOL; (*Acknowledge Teach/Sampling*)
		bMOV : BOOL; (*Axis is moving*)
		bDEV : BOOL; (*Drag (deviation) error*)
		bSTILL : BOOL; (*Standstill control*)
		bREF : BOOL; (*Axis is referenced*)
		uiSPOS : USINT; (*Status byte*)
	END_STRUCT;
	PARA2_command_typ : 	STRUCT 
		diPosition : DINT; (*Velocity as percentage of base value*)
	END_STRUCT;
	VAL1_stat_type : 	STRUCT 
		usVelocity : USINT;
	END_STRUCT;
	SDIR_status_typ : 	STRUCT 
		bABS : BOOL; (*Absolute/relative*)
		bCOM1 : BOOL; (*Control mode feedback*)
		bCOM2 : BOOL;
		bFNUM1 : BOOL; (*Function number feedback*)
		bFNUM2 : BOOL;
		bFGRP1 : BOOL; (*Function group feedback*)
		bFGRP2 : BOOL;
		bFUNC : BOOL; (*Function feedback*)
		uiSDIR : USINT; (*Status byte*)
	END_STRUCT;
	SCON_status_typ : 	STRUCT 
		bENABLED : BOOL; (*Drive enabled*)
		bOPEN : BOOL; (*Operation enabled*)
		bWARN : BOOL; (*Warning*)
		bFAULT : BOOL; (*Fault*)
		b24VL : BOOL; (*Supply voltage is applied*)
		bLOCK : BOOL; (*Drive control by software*)
		bOPM1 : BOOL; (*Display operating mode*)
		bOPM2 : BOOL; (*Display operating mode*)
		uiSCON : USINT; (*Status byte*)
	END_STRUCT;
	Servo_typ : 	STRUCT 
		enumServoState : SERVO_Status_enum := SERVO_READY;
		command : com_typ;
		status : stat_type;
		packed : Servo_packed_typ;
		enumServoCmd : SERVO_CMD_Enum := SERVO_CMD_READY;
		bOnLine : BOOL; (*Servo online*)
		usNode : USINT;
		SDO : SDO_type;
	END_STRUCT;
	CDIR_command_typ : 	STRUCT 
		bABS : BOOL; (*Absolute/relative*)
		bCOM1 : BOOL; (*Control mode feedback*)
		bCOM2 : BOOL;
		bFNUM1 : BOOL; (*Function number feedback*)
		bFNUM2 : BOOL;
		bFGRP1 : BOOL; (*Function group feedback*)
		bFGRP2 : BOOL;
		bFUNC : BOOL; (*Function feedback*)
	END_STRUCT;
	CPOS_command_typ : 	STRUCT 
		bHALT : BOOL; (*Halt*)
		bSTART : BOOL; (*Start positioning task*)
		bHOM : BOOL; (*Start homing*)
		bJOGP : BOOL; (*Jog positive*)
		bJOGN : BOOL; (*Job negative*)
		bTEACH : BOOL; (*Teach actual value*)
		bCLEAR : BOOL; (*Clear remaing position*)
		bNU : BOOL; (*Not used*)
	END_STRUCT;
	com_typ : 	STRUCT 
		CCON : CCON_command_typ;
		CPOS : CPOS_command_typ;
		CDIR : CDIR_command_typ;
		PARA1 : PARA1_command_typ;
		PARA2 : PARA2_command_typ;
	END_STRUCT;
	Servo_packed_typ : 	STRUCT 
		CCON : USINT; (*Control byte 1*)
		CPOS : USINT; (*Control byte 2*)
		CDIR : USINT; (*Control byte 3*)
		PARA1 : USINT; (*Control byte 4*)
		PARA2 : DINT; (*Control bytes 5-8*)
		SCON : USINT; (*Status byte 1*)
		SPOS : USINT; (*Status byte 2*)
		SDIR : USINT; (*Status byte 3*)
		VAL2 : DINT;
		VAL1 : USINT;
	END_STRUCT;
	CCON_command_typ : 	STRUCT 
		bENABLE : BOOL; (*Drive enabled*)
		bSTOP : BOOL; (*Stop*)
		bBRAKE : BOOL; (*Open brake*)
		bRESET : BOOL; (*Reset fault*)
		bNU : BOOL; (*Not used*)
		bLOCK : BOOL; (*Software access locked*)
		bOPM1 : BOOL; (*Select operating mode*)
		bOPM2 : BOOL;
	END_STRUCT;
	VAL2_stat_type : 	STRUCT 
		diPosition : DINT;
	END_STRUCT;
	PARA1_command_typ : 	STRUCT 
		usVelocity : USINT; (*Velocity as percentage of base value*)
	END_STRUCT;
	SERVO_Status_enum : 
		(
		SERVO_READY := 1,
		SERVO_HOMING_COMPLETE := 2,
		SERVO_WARNING := 3,
		SERVO_FAULT := 4,
		SERVO_HOMING_NOT_COMPLETED := 5,
		SERVO_IS_HOMING := 6,
		SERVO_RUNNING := 7,
		SERVO_DISABLED := 8
		);
	SERVO_CMD_Enum : 
		(
		SERVO_CMD_HOME := 10,
		SERVO_CMD_RUN := 20,
		SERVO_CMD_RESET := 99,
		SERVO_CMD_READY := 100
		);
END_TYPE
