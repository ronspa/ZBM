(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: MBU_lib
 * File: MBU_lib.st
 * Author: jorkes
 * Created: December 01, 2014
 *******************************************************************)

FUNCTION fbShiftBelt
//	size := ( SIZEOF(ThisMBU.typInterface.bBeltShiftReg)/SIZEOF(ThisMBU.typInterface.bBeltShiftReg[0]) );
//	
//	IF enable THEN
//		FOR idx := (size - 1) TO 1 BY -1 DO
//			ThisMBU.typInterface.bBeltShiftReg[idx] := ThisMBU.typInterface.bBeltShiftReg[idx-1];
//		END_FOR
//	END_IF

	IF enable THEN
		IF(		ThisMBU.typInterface.uiBeltShiftReg1 AND 16#80000000) <> 0 THEN
			overflow := 1;
		ELSE
			overflow := 0;
		END_IF

		ThisMBU.typInterface.uiBeltShiftReg1 := SHL(ThisMBU.typInterface.uiBeltShiftReg1,1);
		ThisMBU.typInterface.uiBeltShiftReg2 := SHL(ThisMBU.typInterface.uiBeltShiftReg2,1);
		ThisMBU.typInterface.uiBeltShiftReg2 := ((ThisMBU.typInterface.uiBeltShiftReg2 + overflow) AND 16#00FF); // 32 + 8 postities
		fbShiftBelt := TRUE;
	END_IF
END_FUNCTION

FUNCTION fbCheckBelt
//	size := ( SIZEOF(ThisMBU.typInterface.bBeltShiftReg)/SIZEOF(ThisMBU.typInterface.bBeltShiftReg[0]) );
//	
//	sum := 0;
//	FOR idx := 0 TO (size - 1) DO
//		sum := sum + ThisMBU.typInterface.bBeltShiftReg[idx];
//	END_FOR
	
	
//	IF sum <> 0 THEN
	IF ThisMBU.typInterface.uiBeltShiftReg1 <> 0 OR ThisMBU.typInterface.uiBeltShiftReg2 <> 0 THEN
		fbCheckBelt := TRUE;
	ELSE 
		fbCheckBelt := FALSE;		
	END_IF	
END_FUNCTION

FUNCTION fbCheckBUReadyForDrop
	// size := 10; Set by caller
	sum := 0;
	FOR idx := 0 TO (size - 1) DO
		sum := sum + BU[idx].typInterface.bDroppingActive;
	END_FOR
	
	//memco
	
	IF sum <> 0 THEN
		fbCheckBUReadyForDrop := TRUE;
	ELSE 
		fbCheckBUReadyForDrop := FALSE;		
	END_IF	
END_FUNCTION

FUNCTION fbHasFlowersOnIndex
	
//	IF( ThisMBU.typInterface.bBeltShiftReg[idx] ) THEN
//		fbHasFlowersOnIndex := TRUE;
//	ELSE
//		fbHasFlowersOnIndex := FALSE;
//	END_IF
	IF idx <32 THEN
		uiMask := 1;
		uiMask := SHL(uiMask, idx);

		IF( ThisMBU.typInterface.uiBeltShiftReg1 AND uiMask) <> 0 THEN
			fbHasFlowersOnIndex := TRUE;
		ELSE
			fbHasFlowersOnIndex := FALSE;
		END_IF
	ELSE
		uiMask := 1;
		uiMask := SHL(uiMask, idx - 32);
		
		IF( ThisMBU.typInterface.uiBeltShiftReg2 AND uiMask) <> 0 THEN
			fbHasFlowersOnIndex := TRUE;
		ELSE
			fbHasFlowersOnIndex := FALSE;
		END_IF
	END_IF
END_FUNCTION

FUNCTION fbSetFlowersOnIndex
//	ThisMBU.typInterface.bBeltShiftReg[idx] := bHasFlower;
//	fbSetFlowersOnIndex := TRUE;
	IF idx <32 THEN
		uiMask := 1;
		uiMask := SHL(uiMask, idx);

		ThisMBU.typInterface.uiBeltShiftReg1 := ThisMBU.typInterface.uiBeltShiftReg1 OR uiMask;
		
	ELSE
		uiMask := 1;
		uiMask := SHL(uiMask, idx - 32);
		
		ThisMBU.typInterface.uiBeltShiftReg2 := ThisMBU.typInterface.uiBeltShiftReg2 OR uiMask;
	END_IF

END_FUNCTION

