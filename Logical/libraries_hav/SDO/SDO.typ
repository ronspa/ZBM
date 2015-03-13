(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: BULib
 * File: SDO.typ
 * Author: jorkes
 * Created: October 07, 2014
 ********************************************************************
 * Data types of library BULib
 ********************************************************************)

TYPE
	NodeState_enum : 
		(
		SERVO_WR := 1,
		SERVO_RD := 2,
		INV_WR := 3,
		INV_RD := 4,
		STANDBY := 99
		);
	SDO_type : 	STRUCT 
		udIndex : UDINT;
		udSubIndex : UDINT;
		usNode : USINT;
		Write : nxcomSdoWrite;
		udDataWrite : ARRAY[0..3]OF UDINT;
		Read : nxcomSdoRead;
		udDataRead : ARRAY[0..3]OF UDINT;
	END_STRUCT;
END_TYPE
