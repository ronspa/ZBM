(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Serial
 * File: Serial.typ
 * Author: jorkes
 * Created: November 26, 2014
 ********************************************************************
 * Data types of library Serial
 ********************************************************************)
(*Enumeration for Statemachine*)

TYPE
	enSEND_STEPS : 
		(
		FRM_WAIT := 0, (*Defines the wait step*)
		FRM_OPEN, (*Defines Step for FRM_xopen() *)
		FRM_GBUF, (*Defines Step for FRM_rbuf()*)
		FRM_ROBUF, (*Defines Step for FRM_robuf()*)
		FRM_CLOSE, (*Defines Step for FRM_close()*)
		FRM_ERROR := 255 (*Defines Step for Errorhandling*)
		);
END_TYPE

(*Command data type*)

TYPE
	command_typ : 	STRUCT 
		open_send : BOOL; (*Open serial port and send data*)
		close : BOOL; (*Close serial port*)
	END_STRUCT;
END_TYPE

(*Sender type*)

TYPE
	Sender_typ : 	STRUCT 
		step : enSEND_STEPS := FRM_OPEN; (*Step of the Statemachine*)
		Commands : command_typ; (*Commandinterface*)
		send_data : STRING[80]; (*Send data*)
		FRM_xopen_0 : FRM_xopen; (*Functionblock FRM_xopen()*)
		xopenConfig : XOPENCONFIG; (*Configuration Type for FRM_xopen()*)
		FRM_gbuf_0 : FRM_gbuf; (*Functionblock FRM_gbuf()*)
		FRM_robuf_0 : FRM_robuf; (*Functionblock FRM_robuf()*)
		FRM_write_0 : FRM_write; (*Functionblock FRM_write)*)
		FRM_close_0 : FRM_close; (*Functionblock FRM_close()*)
	END_STRUCT;
END_TYPE
