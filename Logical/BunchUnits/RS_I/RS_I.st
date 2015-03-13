(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: RS
 * File: RS.st
 * Author: ronspa
 * Created: December 23, 2014
 ********************************************************************
 * Implementation of program RS
 ********************************************************************)

PROGRAM _INIT


(* TODO : Add your code here *)
	RU.usChainPos := SHFTREG.uiRejectPosition;
	RU.typInterface.bEnable := TRUE;
	RU.typSettings.usTimingBU16 := 5; // Pos=7

END_PROGRAM


PROGRAM _CYCLIC
	
//	IF RU.typInterface.bEnable THEN
//		usGripperIndex := ( SHFTREG.typCounters.usChainCounter + SHFTREG.uiGripperCnt + RU.usChainPos) MOD  SHFTREG.uiGripperCnt;
//		RU.GripperControl.IN := (SHFTREG.typGripper[usGripperIndex].bRejectActive);
//		RU.GripperControl(tiSensDelay := RU.typInterface.tiDelayActiveGripper, tiSensPuls := T#200ms);
//									
//		RU.typOUT.bActivateGripper := GripperControl.Q;	
//		IF GripperControl.Q THEN
//			IF SHFTREG.typGripper[usGripperIndex].bRejectActive THEN
//				// The reset data must be reset.
//				SHFTREG.typGripper[usGripperIndex].bRejectOnOff := FALSE;
//				SHFTREG.typGripper[usGripperIndex].bRejectActive := FALSE;
//			END_IF
//			RU.typInterface.bEnable := TRUE;			
//		END_IF
//	END_IF

END_PROGRAM
