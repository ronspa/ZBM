(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: Serial
 * File: Serial.st
 * Author: jorkes
 * Created: November 26, 2014
 *******************************************************************)
FUNCTION_BLOCK fbSerial
	Sender.Commands.open_send := enable;	
	
	CASE Sender.step OF
		FRM_WAIT:	(*--- wait for command*)
			
			IF Sender.Commands.open_send = TRUE THEN								(*command for sender activation*)
				Sender.step := FRM_OPEN;
			END_IF			
		
		(*close will be requested in step FRM_WRITE*)
		
		FRM_OPEN:	(*--- open serial interface*)
			
			(*_parameters for FRM_xopen()*)
			Sender.FRM_xopen_0.enable := TRUE;
			Sender.FRM_xopen_0.device := ADR('IF1');										(*Devicename --> see your serial interface properties*)
			Sender.FRM_xopen_0.mode := ADR('/PHY=RS232 /BD=9600 /DB=8 /PA=N /SB=1'); 		(*Modestring --> specifies the seria operation mode*)
			Sender.FRM_xopen_0.config := ADR(Sender.xopenConfig) ;					(*Additional _parameters, optional*)
			
			(*Additional _parameters for FRM_xopen()*)
			Sender.xopenConfig.idle := 10;											(*Idle time between two characters*)
			Sender.xopenConfig.delimc := 0;											(*activate two delimeters*)
			Sender.xopenConfig.delim[0] := 0; 										(*CR - carridge return -> dec 13*)
			Sender.xopenConfig.delim[1] := 0; 										(*LF - line feed -> dec 10*)
			Sender.xopenConfig.tx_cnt := 3;											(*number of transmit buffers*)
			Sender.xopenConfig.rx_cnt := 3; 										(*number of receive buffers*)
			Sender.xopenConfig.tx_len := 256; 										(*length of transmit buffers*)
			Sender.xopenConfig.rx_len := 256; 										(*lenght of receive buffers*)
			Sender.xopenConfig.argc := 0;											(*activate additional options*)
			Sender.xopenConfig.argv := 0;											(*_parameters for additional options (check help)*)
	
			Sender.FRM_xopen_0();													(*call the FRM_xopen() function*)
			
			IF Sender.FRM_xopen_0.status = 0 THEN
				Sender.step := FRM_GBUF;											(*Interface opend successfully --> next step*)
			ELSIF Sender.FRM_xopen_0.status = BUSY THEN
				Sender.step := FRM_OPEN;											(*operation not finished yet --> call again*)
			ELSE
				Sender.step := FRM_ERROR;											(*function returned errorcode --> check help*)
			END_IF			
			
		FRM_GBUF:	(*--- aquire sendbuffer for FRM_WRITE*)
			Sender.FRM_gbuf_0.enable := TRUE;
			Sender.FRM_gbuf_0.ident := Sender.FRM_xopen_0.ident;
			
			Sender.FRM_gbuf_0();													(*call the FRM_gbuf() function*)
			
			IF Sender.FRM_gbuf_0.status = 0 THEN
				memset(Sender.FRM_gbuf_0.buffer,0,Sender.FRM_gbuf_0.buflng);		(*clear sendbuffer*)
				Sender.send_data := text;
				strcpy(Sender.FRM_gbuf_0.buffer,ADR(Sender.send_data));					(*copy senddata to sendbuffer*)	
				Sender.FRM_write_0.enable := TRUE;
				Sender.FRM_write_0.ident := Sender.FRM_xopen_0.ident;					(*ident from FRM_xopen()*)
				Sender.FRM_write_0.buffer := Sender.FRM_gbuf_0.buffer;					(*sendbuffer*)
				Sender.FRM_write_0.buflng := strlen(ADR(Sender.send_data));				(*net length of senddata*)
   			
				Sender.FRM_write_0();													(*call the FRM_write() function*)
				
				IF Sender.FRM_write_0.status = 0 THEN
					IF Sender.Commands.close = TRUE THEN								(*requst to close the serial port*)
						Sender.Commands.open_send := FALSE;								(*disable command open_send*)
						Sender.step := FRM_CLOSE;
					ELSE
						Sender.step := FRM_GBUF;										(*writing successful --> get next sendbuffer*)
					END_IF
				ELSIF NOT Sender.FRM_write_0.status = BUSY THEN
					Sender.step := FRM_ROBUF;											(*function returned errorcode --> check help*)
				END_IF				
			END_IF						
			
		FRM_ROBUF:	(*--- release sendbuffer in case of no successful write operation*)
			Sender.FRM_robuf_0.enable := TRUE;
			Sender.FRM_robuf_0.buffer := Sender.FRM_gbuf_0.buffer;					(*sendbuffer*)
			Sender.FRM_robuf_0.buflng := Sender.FRM_gbuf_0.buflng;					(*buffer length*)
			Sender.FRM_robuf_0.ident := Sender.FRM_xopen_0.ident;					(*ident open*)
		
			Sender.FRM_robuf_0();													(*call the FRM_robuf() function*)
		
			IF Sender.FRM_robuf_0.status = 0 THEN
				Sender.step := FRM_GBUF;											(*released buffer successful --> get next sendbuffer*)
			ELSIF Sender.FRM_robuf_0.status = BUSY THEN
				Sender.step := FRM_ROBUF;											(*operation not finished yet --> call again*)
			ELSE
				Sender.step := FRM_ERROR;											(*function returned errorcode --> check help*)
			END_IF			
		
		FRM_CLOSE:	(*--- close the interface*)
			Sender.FRM_close_0.enable := TRUE;
			Sender.FRM_close_0.ident := Sender.FRM_xopen_0.ident;					(*ident from FRM_xopen()*)			
			
			Sender.FRM_close_0();													(*call the FRM_close() function*)
			
			IF Sender.FRM_close_0.status = 0 THEN
				Sender.Commands.close := FALSE;										(*disable close command*)
				Sender.step := FRM_WAIT;											(*closed interface successfully --> wait step*)
			ELSIF Sender.FRM_close_0.status = BUSY THEN
				Sender.step := FRM_CLOSE;											(*operation not finished yet --> call again*)
			ELSE
				Sender.step := FRM_ERROR;											(*function returned errorcode --> check help*)
			END_IF
			
		FRM_ERROR:	(*--- error handling*)
		; (*not implementet yet, check help for error codes*)
	END_CASE
END_FUNCTION_BLOCK