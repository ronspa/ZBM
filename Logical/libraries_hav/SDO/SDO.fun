(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: SDO
 * File: SDO.fun
 * Author: jorkes
 * Created: October 30, 2014
 ********************************************************************
 * Functions and function blocks of library SDO
 ********************************************************************)

FUNCTION SDO_Servo : UDINT
	VAR_INPUT
		ThisBU : BunchUnit;
		Node : USINT;
		Index : UDINT;
		SubIndex : UDINT;
		Command : NodeState_enum := STANDBY;
	END_VAR
	VAR
		Error : UINT;
		Step : USINT;
	END_VAR
END_FUNCTION

FUNCTION SDO_Inverter : UDINT
	VAR_INPUT
		i : USINT;
		Node : USINT;
		Index : UDINT;
		SubIndex : UDINT;
		Command : NodeState_enum := STANDBY;
	END_VAR
	VAR
		Error : UINT;
		Step : USINT;
	END_VAR
END_FUNCTION
