(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: MBU_lib
 * File: MBU_lib.typ
 * Author: jorkes
 * Created: December 01, 2014
 ********************************************************************
 * Data types of library MBU_lib
 ********************************************************************)

TYPE
	enumMBU_CMD : 
		(
		MBU_CMD_INIT,
		MBU_CMD_RUN,
		MBU_CMD_STOP,
		MBU_CMD_MANUAL,
		MBU_CMD_FAULT
		);
	enumMBU_ST : 
		(
		MBU_ST_INIT,
		MBU_ST_RUN,
		MBU_ST_HOLD,
		MBU_ST_READY,
		MBU_ST_DISABLED,
		MBU_ST_MANUAL,
		MBU_ST_ERROR,
		MBU_ST_SIMULATED
		);
	MBU_Interface : 	STRUCT 
		bEnable : BOOL;
		bReset : BOOL;
		bBeltShiftReg : ARRAY[0..39]OF BOOL;
		uiBeltShiftReg1 : UDINT;
		uiBeltShiftReg2 : UDINT;
		usBunchPositions : USINT := 39;
		usAflegPos : USINT := 37;
		usBindPos2 : USINT := 33;
		usBindPos1 : USINT := 31;
		usKnifePos : USINT := 27;
		tiSensPuls : TIME := T#20ms;
		tiBindPuls : TIME := T#100ms;
		tiBindDelay2 : TIME := T#50ms;
		tiBindDelay1 : TIME := T#50ms;
		tiSensDelay2 : TIME := T#70ms; (*Vakkenband*)
		tiSensDelay1 : TIME := T#420ms; (*Sponsband*)
		usMovePositions : USINT := 0;
		bReadyToReceive : BOOL := FALSE;
		bToggleBelt : BOOL := FALSE;
		bToggleKnife : BOOL := FALSE;
		bToggleBuffer : BOOL := FALSE;
		bSimulate : BOOL := FALSE; (*Set high for simulation*)
		bFault : BOOL := FALSE; (*MBU Fault state*)
		Command : enumMBU_CMD := MBU_CMD_STOP;
		State : enumMBU_ST := MBU_ST_HOLD;
		tiKnifePuls : TIME;
		tiBufferPuls : TIME;
		tiBufferDelay : TIME;
	END_STRUCT;
	MainbeltUnit : 	STRUCT  (*Verzameling parameters bosband*)
		in_bMainBeltSensor1 : BOOL := FALSE;
		in_bMainBeltSensor2 : BOOL := FALSE;
		in_bElastiekOp1 : BOOL := FALSE;
		in_bElastiekOp2 : BOOL := FALSE;
		out_bBinder1 : BOOL := FALSE;
		out_bBinder2 : BOOL := FALSE;
		typInterface : MBU_Interface;
		typBeltMotor1 : AcpInverter_typ;
		motBelt1 : ACPinverter;
		typBeltMotor2 : AcpInverter_typ;
		motBelt2 : ACPinverter;
		typMainMotor : AcpInverter_typ;
		motMain : ACPinverter;
		typPreCutter : AcpInverter_typ;
		motPreCutter : ACPinverter;
		typBufferMotor : AcpInverter_typ;
		motBufferBelt : ACPinverter;
		typKnifeUnit : AcpInverter_typ;
		motKnifeUnit : ACPinverter;
	END_STRUCT;
END_TYPE
