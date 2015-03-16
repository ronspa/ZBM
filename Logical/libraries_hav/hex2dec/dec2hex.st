FUNCTION_BLOCK dec2hex
	(* Implementation of dec2hex *)
	(**********************************************************************
		Identification:
			Function block:	dec2hex
			Description		:	Convertor from decimal to hexidecimal
	(*----------------------------------------------------------------------
		History:
			Version			date				author	description
			0.01				28-9-2005		HD			First release
			0.02				26-7-2010		HD			More Hex numbers max 7 (UDINT input)
	
	(*----------------------------------------------------------------------
	 	Declaration;
			usMaxHexDigit	= INPUT[USINT] 		= Number of Hex digits
			udInputDec 		= INPUT[UINT]		= decimal input
			Hexadecimal 	= OUTPUT[STRING(2)] = hexadecimal output 
	
	(**********************************************************************)
	
IF (udInputDec <> udOldInputDec) THEN
	udOldInputDec := udInputDec;	
 	
	IF (usMaxHexDigit > 7) THEN
 		usMaxHexDigit := 7;
	END_IF
	
	udMask := 16#0000000F;
	strOutputHex := '';
	FOR usIndex := 0 TO usMaxHexDigit	DO

		IF (usIndex = 0) THEN
			udDec[usIndex] := udInputDec AND udMask;	
		ELSE
			udMask := SHL(udMask,4);
			udDec[usIndex] := SHR(udInputDec AND udMask,usIndex*4);
		END_IF

		udDecimal := (udDec[usIndex] MOD 16);

		CASE udDecimal OF
		 10: strHex[usMaxHexDigit-usIndex] := 'A';
		 11: strHex[usMaxHexDigit-usIndex] := 'B';
		 12: strHex[usMaxHexDigit-usIndex] := 'C';
		 13: strHex[usMaxHexDigit-usIndex] := 'D';
		 14: strHex[usMaxHexDigit-usIndex] := 'E';
		 15: strHex[usMaxHexDigit-usIndex] := 'F';
		ELSE
			itoa(udDecimal, ADR(strHex[usMaxHexDigit-usIndex]));
		END_CASE	
		strcat(ADR(strOutputHex), ADR(strHex[usIndex]));
	
	END_FOR
END_IF
	
END_FUNCTION_BLOCK