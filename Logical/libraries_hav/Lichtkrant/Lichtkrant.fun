(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Lichtkrant
 * File: Lichtkrant.fun
 * Author: jorkes
 * Created: November 17, 2014
 ********************************************************************
 * Functions and function blocks of library Lichtkrant
 ********************************************************************)

FUNCTION_BLOCK fbSetText
	VAR_INPUT
		ThisData : DataPackage;
		IN : STRING[80]; (*//Data string*)
		color : STRING[4] := '<CC>';
		font : STRING[4] := '<AC>';
		interval : STRING[4] := '<MA>';
		presentation : STRING[4] := '<FK>';
	END_VAR
	VAR_OUTPUT
		OUT : STRING[100];
	END_VAR
	VAR
		dec2hex_0 : dec2hex;
		_param : STRING[80];
		_idx : UINT;
		_array : ARRAY[0..255] OF USINT;
		_hexSum : STRING[4];
		_sum : UINT;
		_buflen : UINT;
	END_VAR
END_FUNCTION_BLOCK
