(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: can_diag
 * File: can_diag.typ
 * Author: fleischerm
 * Created: February 02, 2015
 ********************************************************************
 * Local data types of program can_diag
 ********************************************************************)

TYPE
	local_if1041_map : 	STRUCT 
		comCOS : UDINT;
		comState : UDINT;
		comError : UDINT;
		version : UINT;
		watchdogTimeout : UINT;
		watchdogHost : UDINT;
		errorCount : UDINT;
		errorLogIndicator : UDINT;
		slaveState : UDINT;
		slaveErrorLogIndicator : UDINT;
		slavesConfigured : UDINT;
		slavesActive : UDINT;
		slavesFaulted : UDINT;
	END_STRUCT;
END_TYPE
