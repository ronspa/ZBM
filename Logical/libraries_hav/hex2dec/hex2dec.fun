
FUNCTION_BLOCK hex2dec
	VAR_INPUT
		Hexadecimal : STRING[8];
	END_VAR
	VAR_OUTPUT
		Decimal : DINT;
	END_VAR
	VAR
		Dyn_Usint : REFERENCE TO USINT;
		dMemcmpResult : DINT;
		strHexOld : STRING[8];
		strHexChar : STRING[2];
		i : INT;
		iStringLenght : INT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK dec2hex
	VAR_INPUT
		usMaxHexDigit : USINT;
		udInputDec : UDINT;
	END_VAR
	VAR_OUTPUT
		strOutputHex : STRING[8];
	END_VAR
	VAR
		udMask : UDINT;
		usIndex : USINT;
		udDec : ARRAY[0..7] OF UDINT;
		udDecimal : UDINT;
		lenHex : USINT;
		strHex : ARRAY[0..7] OF STRING[1];
		udOldInputDec : UDINT;
		udResult : UDINT;
	END_VAR
END_FUNCTION_BLOCK
