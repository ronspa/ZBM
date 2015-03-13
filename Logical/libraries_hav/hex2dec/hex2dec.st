FUNCTION_BLOCK hex2dec
	(* Implementation of hex2dec *)
	(**********************************************************************
		Identification:
			Function block:	hex2dec
			Description		:	Convertor from hexidecimal to decimal 
	(*----------------------------------------------------------------------
		History:
			Version			date					author	description
			0.01				03-04-2007		HD			First release
	
	(*----------------------------------------------------------------------
	 	Declaration;
			Hexadecimal = INPUT[STRING(8)] 	= hexadecimal input 
			Decimal 		= INPUT[DINT]				= decimal output
	
	(**********************************************************************)
	
	
	dMemcmpResult := memcmp(ADR(Hexadecimal), ADR(strHexOld), SIZEOF(Hexadecimal));
	IF (dMemcmpResult <> 0) THEN
		Decimal := 0;
		iStringLenght := LEN(Hexadecimal);;
		i := iStringLenght - 1;
		IF (iStringLenght > 0) THEN
	
			WHILE i > -1 DO
				Dyn_Usint ACCESS(ADR(Hexadecimal) + i);
	
				(* Convert ASCI code to decimal *)
				CASE Dyn_Usint OF
					48:			strHexChar := '0';
					49:			strHexChar := '1';
					50:			strHexChar := '2';
					51:			strHexChar := '3';
					52:			strHexChar := '4';
					53:			strHexChar := '5';
					54:			strHexChar := '6';
					55:			strHexChar := '7';
					56:			strHexChar := '8';
					57:			strHexChar := '9';
					65,97:	strHexChar := '10';
					66,98:	strHexChar := '11';
					67,99:	strHexChar := '12';
					68,100:	strHexChar := '13';
					69,101:	strHexChar := '14';
					70,102:	strHexChar := '15';
				END_CASE
	
				(* Formule to calulate hex to decimal *)
				Decimal := Decimal + ( (atoi(ADR(strHexChar))) * REAL_TO_DINT( EXPT(16, (iStringLenght-1-i))) );
	
				i := i - 1;
	
			END_WHILE
		END_IF
	END_IF
	strHexOld := Hexadecimal;
	
	
	
	
END_FUNCTION_BLOCK