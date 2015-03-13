(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: Lichtkrant
 * File: Lichtkrant.st
 * Author: jorkes
 * Created: November 20, 2014
 *******************************************************************)
FUNCTION_BLOCK fbSetText
	(* Lichtkrant *)
	(**********************************************************************
		Identification:
			FUNCTION block	:	setText
			Description		:	Convert text to Lichtkrant text with checksum
	
	(*----------------------------------------------------------------------
	 	Declaration;
			ThisData	= INPUT[DataPackage] = Select lichtkrant
			text 		= INPUT[STRING[80]]	 = String input
	
	(**********************************************************************)
	ThisData.methodSpeed := interval;
	ThisData.laggingCom := presentation;
	ThisData.fontCode := font;
	ThisData.colorCode := color;
	
	_param := CONCAT(ThisData.lineNumber, ThisData.pageNumber);
	_param := CONCAT(_param, ThisData.leadingCom);
	_param := CONCAT(_param, ThisData.methodSpeed);
	_param := CONCAT(_param, ThisData.waitingTime);
	_param := CONCAT(_param, ThisData.laggingCom);
	_param := CONCAT(_param, ThisData.fontCode);
	_param := CONCAT(_param, ThisData.colorCode);
					
	_param := CONCAT(_param, IN);
			
	_buflen := LEN(_param);
			
	// string omzetten naar USINT array
	brsmemcpy(ADR(_array), ADR(_param), SIZEOF(_array));
			
	_sum := 0;
			
	FOR _idx := 0 TO (_buflen - 1) DO				
		_sum := _sum XOR _array[_idx];							
	END_FOR
		
	dec2hex_0(usMaxHexDigit := 2, udInputDec := _sum);
			
	_hexSum := dec2hex_0.strOutputHex;
			
	IF (LEFT(_hexSum, 1) = '0') THEN //LEFT(string, count)
		IF (LEFT(_hexSum, 2) = '00') THEN
			_hexSum := DELETE(_hexSum, 2, 1); //DELETE(string, index, position)
		ELSE
			_hexSum := DELETE(_hexSum,1, 1);
		END_IF
	END_IF		
			
	_param := CONCAT('<ID00>', _param);
	_param := CONCAT(_param, _hexSum);
	_param := CONCAT(_param, '<E>');
	
	OUT := _param;
END_FUNCTION_BLOCK