(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: Chain
 * File: Chain.st
 * Author: jorkes
 * Created: November 18, 2014
 *******************************************************************)
FUNCTION_BLOCK fbAverage
	tiAverage := 0;
	
	size := ( SIZEOF(_tiMusecDiff1)/SIZEOF(_tiMusecDiff1[0]) );
	index := index MOD size;
	
	_tiMusecDiff1[index] := tiMeasure;
	
	IF enable THEN
		FOR idx := 0 TO (size-1) DO
			//Assign timestamp of sensor puls length
			tiAverage := tiAverage + _tiMusecDiff1[idx];
		END_FOR
	
		//Everage of 10 sensor pulses 
		tiAverage := tiAverage / size;
	END_IF	
END_FUNCTION_BLOCK

FUNCTION fbChainlength
	ThisSHIFTREG.reChainlength := (UINT_TO_REAL(ThisSHIFTREG.uiGripperCnt)*ThisSHIFTREG.reGripperDistanceBetween_mm)/1000;
	//fbChainlength := ThisSHIFTREG.reChainlength;
END_FUNCTION

FUNCTION fbGripperSpeed
	ThisSHIFTREG.reGripperSpeed_CmSec := (ThisSHIFTREG.reGripperDistanceBetween_mm/10)*UINT_TO_REAL(ThisSHIFTREG.uiMachineSpeed)/3600;
	//fbGripperSpeed := ThisSHIFTREG.reGripperSpeed_CmSec;
END_FUNCTION

FUNCTION fbEncoderDistance
	ThisSHIFTREG.typEncoder.reDistanceBetween := ( (TIME_TO_REAL(ThisSHIFTREG.typEncoder.tiEncBetween)/1000)*ThisSHIFTREG.reGripperSpeed_CmSec )/100;
	//fbEncoderDistance := ThisSHIFTREG.typEncoder.reDistanceBetween;
END_FUNCTION

FUNCTION fbGripperDistance
	ThisSHIFTREG.typEncoder.reGrippersBetween := ThisSHIFTREG.typEncoder.reDistanceBetween/(ThisSHIFTREG.reGripperDistanceBetween_mm/1000);
	//fbGripperDistance := ThisSHIFTREG.typEncoder.reGrippersBetween;
END_FUNCTION

FUNCTION fbEncoderBetween
	ThisSHIFTREG.typEncoder.tiEncBetween := tiBetween;
	//fbEncoderBetween := ThisSHIFTREG.typEncoder.tiEncBetween;
END_FUNCTION

FUNCTION fbResetGripper
	/////ThisGripper.siEmptyBU := -2;
	//ThisGripper.bRejectActive := FALSE;
	//ThisGripper.bRejectOnOff := FALSE;
	//ThisGripper.uiCorrection := 0;
	ThisGripper.uiLength := 0;
	ThisGripper.uiTimingBU16 := 0;
	ThisGripper.uiWeight := 0;
	ThisGripper.usSetTarget := -2;
END_FUNCTION