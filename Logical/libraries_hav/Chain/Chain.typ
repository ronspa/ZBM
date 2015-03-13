(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Chain
 * File: Chain.typ
 * Author: jorkes
 * Created: November 18, 2014
 ********************************************************************
 * Data types of library Chain
 ********************************************************************)

TYPE
	_cntrs : 	STRUCT 
		usChainCounter : USINT; (*0-75*)
		uiChainCnt16x16 : UINT; (*0-255*)
		usChainOffset : USINT; (*0-75*)
		bStartChainCntr : BOOL;
		usStartUpCntr : USINT;
	END_STRUCT;
	Shiftregister : {REDUND_UNREPLICABLE} 	STRUCT  (*Schuifregister*)
		typEncoder : {REDUND_UNREPLICABLE} _encoder;
		typGripper : {REDUND_UNREPLICABLE} ARRAY[0..74]OF _gripper;
		uiGripperCnt : {REDUND_UNREPLICABLE} USINT := 75; (*Aantal grijpers die fysiek in de machine zitten*)
		uiCameraPosition : {REDUND_UNREPLICABLE} ARRAY[0..3]OF USINT := [2,3,4,5]; (*Positie in schuifregister waar Camera's hangen*)
		uiRejectPosition : {REDUND_UNREPLICABLE} USINT := 9;
		uiBunchUnitPosition : {REDUND_UNREPLICABLE} ARRAY[0..20]OF USINT := [11,14,16,18,20,23,25,27,30,32,0,0,0,0,0,0,0,0,0,0,0]; (*Positie bosstations t.o.v. de ketting (grijpers)*)
		tiDistanceBetweenGrippers : {REDUND_UNREPLICABLE} TIME := T#600ms; (*Tijd tussen twee grijpers*)
		reGripperSpeed_CmSec : {REDUND_UNREPLICABLE} REAL := 0.0; (*Snelheid van de grijpers in cm/sec*)
		reChainlength : {REDUND_UNREPLICABLE} REAL; (*Ketting lengte*)
		reGripperDistanceBetween_mm : {REDUND_UNREPLICABLE} REAL := 304.88; (*Aantal mm tussen de grijpers*)
		uiMachineSpeed : {REDUND_UNREPLICABLE} UINT := 6000; (*Machine snelheid in grijpers per uur*)
		typCounters : {REDUND_UNREPLICABLE} _cntrs;
	END_STRUCT;
	_encoder : {REDUND_UNREPLICABLE} 	STRUCT 
		uiEncSensorPosition1 : {REDUND_UNREPLICABLE} UINT := 0; (*Schuifregisterpositie1*)
		uiEncSensorPosition2 : {REDUND_UNREPLICABLE} UINT := 34; (*Schuifregisterpositie2*)
		tiEncBetween : {REDUND_UNREPLICABLE} TIME := T#0S; (*Tijd tussen de twee encoder sensoren*)
		reGrippersBetween : {REDUND_UNREPLICABLE} REAL := 0.0; (*Aantal grijpers tussen de twee encoder sensoren*)
		reDistanceBetween : {REDUND_UNREPLICABLE} REAL := 0.0; (*Afstand tussen de twee encoder sensoren*)
	END_STRUCT;
	_gripper : {REDUND_UNREPLICABLE} 	STRUCT 
		usSetTarget : {REDUND_UNREPLICABLE} SINT := -2; (*-2=Empty, -1=Reject 0..x BosUnit*)
		uiCorrection : {REDUND_UNREPLICABLE} UINT := 0;
		uiLength : {REDUND_UNREPLICABLE} UINT := 0;
		uiWeight : {REDUND_UNREPLICABLE} UINT := 0;
		uiTimingBU16 : {REDUND_UNREPLICABLE} UINT := 0; (*Timing from command*)
		bRejectActive : {REDUND_UNREPLICABLE} BOOL := FALSE; (*TRUE if bRejectOnOff is valid*)
		bRejectOnOff : {REDUND_UNREPLICABLE} BOOL := FALSE; (*if Target = -1, set/reset reject*)
		siEmptyBU : {REDUND_UNREPLICABLE} SINT := -2; (*Emprty BU *)
		bFast : {REDUND_UNREPLICABLE} BOOL := FALSE; (*Fast servo movement*)
	END_STRUCT;
END_TYPE
