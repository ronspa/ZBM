(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Package: BULib
 * File: SDO.st
 * Author: jorkes
 * Created: October 07, 2014
 *******************************************************************)
FUNCTION SDO_Servo
			// Als Command = 1 (=READ_SDO) dan spring naar step 40 en voert functie readSDO uit 
	CASE Command OF
		SERVO_WR : // 1 
			Step := 10;
			Command := 99;
		SERVO_RD : // 2 
			Step := 20;
			Command := 99;		
		STANDBY : // Standby
	END_CASE
	
	CASE Step OF		
		//-----------------------------------------------------------
		// Servo write SDO
		//-----------------------------------------------------------
		10:
			ThisBU.typServo.SDO.Write.enable := TRUE;
			ThisBU.typServo.SDO.Write.pDevice := ADR('SS1.IF1');
			ThisBU.typServo.SDO.Write.node := Node;
			ThisBU.typServo.SDO.Write.index := Index;
			ThisBU.typServo.SDO.Write.subIndex := SubIndex; 
			ThisBU.typServo.SDO.Write.dataCount := 4;
						
			// Wait for function is done, OK or error
			IF (ThisBU.typServo.SDO.Write.status = ERR_OK) THEN
				ThisBU.typServo.SDO.Write.pData := ADR(ThisBU.typServo.SDO.udDataWrite[0]);			
				Step := 0;
			ELSIF (ThisBU.typServo.SDO.Write.status <> ERR_FUB_BUSY) THEN
				Error := ThisBU.typServo.SDO.Write.status;
				Step := 100; 	// STATE_ERROR;
			END_IF
				
			ThisBU.typServo.SDO.Write();	
		//-----------------------------------------------------------
		// Servo read SDO
		//-----------------------------------------------------------
		20:			
			ThisBU.typServo.SDO.Read.enable := TRUE;
			ThisBU.typServo.SDO.Read.pDevice := ADR('SS1.IF1');
			ThisBU.typServo.SDO.Read.node := Node;
			ThisBU.typServo.SDO.Read.index := Index;
			ThisBU.typServo.SDO.Read.subIndex := SubIndex; 
			ThisBU.typServo.SDO.Read.dataCount := 4;
			ThisBU.typServo.SDO.Read.pData := ADR(ThisBU.typServo.SDO.udDataRead[0]);
			ThisBU.typServo.SDO.Read();
						
			// Wait for function is done, OK or error
			IF (ThisBU.typServo.SDO.Read.status = ERR_OK) THEN			
				Step := 0;
			ELSIF (ThisBU.typServo.SDO.Read.status <> ERR_FUB_BUSY) THEN
				Error := ThisBU.typServo.SDO.Read.status;
				Step := 100; 	// STATE_ERROR;
			END_IF
			
			SDO_Servo := ThisBU.typServo.SDO.udDataRead[0];	
		// Error
		//-----------------------------------------------------------
		100:
	END_CASE
END_FUNCTION

FUNCTION SDO_Inverter
			// Als Command = 1 (=READ_SDO) dan spring naar step 40 en voert functie readSDO uit 
	CASE Command OF
		INV_WR	 : // 3 
			Step := 30;
			Command := 99;	
		INV_RD	 : // 4 
			Step := 40;
			Command := 99;		
		STANDBY : // Standby
	END_CASE
	
	(*CASE Step OF		
		//-----------------------------------------------------------
		// Inverter write SDO
		//-----------------------------------------------------------
		30:
			typBunchBelts[i].SDO.Write.enable := TRUE;
			typBunchBelts[i].SDO.Write.pDevice := ADR('SS1.IF1');
			typBunchBelts[i].SDO.Write.node := Node;
			typBunchBelts[i].SDO.Write.index := Index;
			typBunchBelts[i].SDO.Write.subIndex := SubIndex; 
			typBunchBelts[i].SDO.Write.dataCount := 2;
						
			// Wait for function is done, OK or error
			//IF (ThisBU.typServo.SDO.Write.status = ERR_OK) THEN
			IF (typBunchBelts[i].SDO.Write.status = ERR_OK) THEN
				typBunchBelts[i].SDO.Write.pData := ADR(typBunchBelts[i].SDO.udDataWrite[0]);			
				Step := 0;
			ELSIF (ThisMotor.typBunchBelts.SDO.Write.status <> ERR_FUB_BUSY) THEN
				Error := typBunchBelts[i].SDO.Write.status;
				Step := 100; 	// STATE_ERROR;
			END_IF
				
			ThisMotor.typBunchBelts.SDO.Write();		
		//-----------------------------------------------------------
		// Inverter read SDO
		//-----------------------------------------------------------
		40:			
			typBunchBelts[i].SDO.Read.enable := TRUE;
			typBunchBelts[i].SDO.Read.pDevice := ADR('SS1.IF1');
			typBunchBelts[i].SDO.Read.node := Node;
			typBunchBelts[i].SDO.Read.index := Index;
			typBunchBelts[i].SDO.Read.subIndex := SubIndex; 
			typBunchBelts[i].SDO.Read.dataCount := 2;
			typBunchBelts[i].SDO.Read.pData := ADR(ThisMotor.typBunchBelts.SDO.udDataRead[0]);
			typBunchBelts[i].SDO.Read();
						
			// Wait for function is done, OK or error
			IF (typBunchBelts[i].SDO.Read.status = ERR_OK) THEN			
				Step := 0;
			ELSIF (typBunchBelts[i].SDO.Read.status <> ERR_FUB_BUSY) THEN
				Error := ThisMotor.typBunchBelts.SDO.Read.status;
				Step := 100; 	// STATE_ERROR;
			END_IF
			
			SDO_Inverter := typBunchBelts[i].SDO.udDataRead[0];		
		// Error
		//-----------------------------------------------------------
		100:
		
	END_CASE*)
END_FUNCTION
