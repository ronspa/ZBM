(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Package: PulsGen
 * File: PulsGen.st
 * Author: jorkes
 * Created: July 18, 2014
 *******************************************************************)
FUNCTION_BLOCK PulsGenerator
	(* First time take over the systemtime *)
	IF EDGEPOS(tInit) THEN
		time := sysTim;
		state := 0;
		counter := 0;
	END_IF

	(* Run if enabled *)
	IF enable THEN
		CASE state OF
			(**)
			0:
				bOutput := TRUE; 
		
				IF (sysTim - time) >= (TIME_TO_DINT(tiHigh)*1000) THEN
					state := 1;
					bOutput := FALSE; 
					time := sysTim;
					counter := counter + 1;
				END_IF			
			(**)
			1:
				bOutput := FALSE;
		
				IF ((sysTim - time) >= (TIME_TO_DINT(tiLow)*1000)) AND (counter < 16) THEN
					state := 0;
					bOutput := TRUE; 
					time := sysTim;
				END_IF		
		END_CASE;
	ELSE
		time := sysTim;
		state := 0;
	END_IF
END_FUNCTION_BLOCK

FUNCTION_BLOCK fbTriggerBuf
	IF EDGEPOS(reset) THEN
		idx := 0;
	END_IF
	
	IF EDGENEG(trigger) THEN
		IF idx = (CamPos-1) THEN
			tiTime := clock_ms();
		END_IF			
		idx := (idx + 1) MOD 16;
	END_IF
	
	IF (clock_ms() - tiTime) >= tiDelay THEN
		tpPulsLight.IN := TRUE;
	ELSE
		tpPulsLight.IN := FALSE;
	END_IF
	
	IF (clock_ms() - tiTime) >= (tiDelay + tiExtraLight) THEN
		tpPulsCam.IN := TRUE;
	ELSE
		tpPulsCam.IN := FALSE;
	END_IF
	
	tpPulsLight(PT := tiPuls + tiExtraLight + tiExtraLight);
	tpPulsCam(PT := tiPuls);
	
	outLight := tpPulsLight.Q;
	outCam := tpPulsCam.Q;
END_FUNCTION_BLOCK