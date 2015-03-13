(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: can_diag
 * File: can_diag.st
 * Author: fleischerm
 * Created: February 02, 2015
 ********************************************************************
 * Implementation of program can_diag
 ********************************************************************)




//******************************************************************
//
//	i n i t
//
//******************************************************************
PROGRAM _INIT


//******************************************************************
// RCX Common Status & Errors Codes
//------------------------------------------------------------------
// variable for the following error codes is -> x20if1041map.comError
//------------------------------------------------------------------
//	RCX_S_OK						0x00000000	Success, Status Okay
//	RCX_E_FAIL						0xC0000001 	Fail
//	RCX_E_UNEXPECTED				0xC0000002	Unexpected
//	RCX_E_OUTOFMEMORY				0xC0000003 	Out OF Memory
//	RCX_E_UNKNOWN_COMMAND			0xC0000004	Unknown Command
//	RCX_E_UNKNOWN_DESTINATION		0xC0000005	Unknown Destination
//	RCX_E_UNKNOWN_DESTINATION_ID	0xC0000006	Unknown Destination ID
//	RCX_E_INVALID_PACKET_LEN		0xC0000007	Invalid Packet Length
//	RCX_E_INVALID_EXTENSION			0xC0000008	Invalid Extension
//	RCX_E_INVALID_PARAMETER			0xC0000009	Invalid Parameter
//	RCX_E_WATCHDOG_TIMEOUT			0xC000000C	Watchdog Timeout
//	RCX_E_INVALID_LIST_TYPE			0xC000000D	Invalid List Type
//	RCX_E_UNKNOWN_HANDLE			0xC000000E	Unknown Handle
//	RCX_E_PACKET_OUT_OF_SEQ			0xC000000F	Out OF Sequence
//	RCX_E_PACKET_OUT_OF_MEMORY		0xC0000010	Out OF Memory
//	RCX_E_QUE_PACKETDONE			0xC0000011	Queue Packet Done
//	RCX_E_QUE_SENDPACKET			0xC0000012	Queue Send Packet
//	RCX_E_POOL_PACKET_GET			0xC0000013	Pool Packet Get
//	RCX_E_POOL_GET_LOAD				0xC0000015	Pool Get Load
//	RCX_E_REQUEST_RUNNING			0xC000001A	Request Already Running
//	RCX_E_INIT_FAULT				0xC0000100	Initialization Fault
//	RCX_E_DATABASE_ACCESS_FAILED	0xC0000101	Database ACCESS Failed
//	RCX_E_NOT_CONFIGURED			0xC0000119	NOT Configured
//	RCX_E_CONFIGURATION_FAULT		0xC0000120	Configuration Fault
//	RCX_E_INCONSISTENT_DATA_SET		0xC0000121	Inconsistent Data Set
//	RCX_E_DATA_SET_MISMATCH			0xC0000122	Data Set Mismatch
//	RCX_E_INSUFFICIENT_LICENSE		0xC0000123	Insufficient License
//	RCX_E_PARAMETER_ERROR			0xC0000124	Parameter Error
//	RCX_E_INVALID_NETWORK_ADDRESS	0xC0000125	Invalid Network Address
//	RCX_E_NO_SECURITY_MEMORY		0xC0000126	No Security Memory
//	RCX_E_NETWORK_FAULT				0xC0000140	Network Fault
//	RCX_E_CONNECTION_CLOSED			0xC0000141	Connection Closed
//	RCX_E_CONNECTION_TIMEOUT		0xC0000142	Connection Timeout
//	RCX_E_LONELY_NETWORK			0xC0000143	Lonely Network
//	RCX_E_DUPLICATE_NODE			0xC0000144	Duplicate Node
//	RCX_E_CABLE_DISCONNECT			0xC0000145	Cable Disconnected
//	RCX_E_BUS_OFF					0xC0000180	Network Node Bus Off
//	RCX_E_CONFIG_LOCKED				0xC0000181	Configuration Locked
//	RCX_E_APPLICATION_NOT_READY		0xC0000182	Application NOT Ready
//	RCX_E_TIMER_APPL_PACKET_SENT	0xC002000C	Timer App Packet Sent
//******************************************************************


//******************************************************************
// RCX Status & Error Codes Slave State
//------------------------------------------------------------------
// variable for the following error codes is -> x20if1041map.slaveState
//------------------------------------------------------------------
//	RCX_SLAVE_STATE_UNDEFINED		0x00000000	UNDEFINED
//	RCX_SLAVE_STATE_OK				0x00000001	OK
//	RCX_SLAVE_STATE_FAILED			0x00000002	FAILED (at least one slave)
//******************************************************************
 

//******************************************************************
// init some variables
//******************************************************************
step									:= 255;
getDiagInfo								:= FALSE;


END_PROGRAM




//******************************************************************
//
//	c y c l i c
//
//******************************************************************
PROGRAM _CYCLIC


	//******************************************************************************
	// Havatec global used data structure for OPC, VIS and Control
	//**************************************************************
	BU[0];


	//******************************************************************************
	// CANopen Master -> X20IF1041-1
	// get data structure from the I/O mapping
	//**************************************************************
	CASE x20if1041map.comState OF
	//**************************************************************
	0: 	// Unkown
	2:	// Stop
	3:	// Standby
	4:	// Operate
	END_CASE

	//**************************************************************
	CASE x20if1041map.comError OF
	//**************************************************************
	16#C0000140:	// General communication error (this error will occur if at least one slave in the CAN network isn't working)
	16#C0000142:	// Timeout while establishing connection
	16#C0000144:	// Repeated node number found in CAN network
	16#C0000145:	// CAN cable has been disconnected
	END_CASE

	//**************************************************************
	CASE x20if1041map.slaveState OF
	//**************************************************************
	0: 	// Undefined
	1:	// OK
	2:	// Failed
	3:	// Warning
	END_CASE


	//******************************************************************************
	// Servo Unit I/O mapping 
	// - Module OK signal
	// - will be FALSE on network or cable error
	//**************************************************************
	IF (BU[0].typServo.bOnLine = FALSE) THEN							// a better check is to wait a certain time before the error is TRUE
		;
	END_IF

	//**************************************************************
	// Servo Unit I/O mapping 
	// - Festo drive in error state
 	// -- 16#08 means drive is faulty
	//**************************************************************
	IF (BU[0].typServo.packed.SCON.3 = TRUE) THEN
		getDiagInfo						:= TRUE;
	ELSE
		getDiagInfo						:= FALSE;
	END_IF

	//**************************************************************
	IF EDGEPOS(getDiagInfo) THEN
		step							:= 2;							// next step -
	END_IF


	//******************************************************************************
	// call different function blocks
	//**************************************************************
	CASE step OF														// case function switch of
	//**************************************************************
	1:	// get emergency telegrams
		//**********************************************************
		nxcomRecvEmcyDev_0.enable 		:= TRUE;						// enable function block
		nxcomRecvEmcyDev_0.pDevice 		:= ADR('SS1.IF1');				// CANopen interface address
		nxcomRecvEmcyDev_0.node 		:= 3;							// node number (client address)
		nxcomRecvEmcyDev_0.flags		:= nxcomFLAG_PEEK;				// means: Don't remove node from the diagnostics list
		nxcomRecvEmcyDev_0.pEmcyData	:= ADR(emcyTelegram);			// pointer to an array of 5 emergency telegrams with 8 bytes each
		nxcomRecvEmcyDev_0();											// call function block instance

		//**********************************************************
		CASE nxcomRecvEmcyDev_0.status OF								// case function switch of
		//**********************************************************
		65535:	// ERR_BUSY
			//******************************************************
			;															// wait for different status
		//**********************************************************
		0:		// ERR_OK
			//******************************************************
			nxcomRecvEmcyDev_0.coStatus;								// see help file for the nxcomGetDiag function block
			nxcomRecvEmcyDev_0.emcyCount;								// ...
			//******************************************************
			step						:= 255;							// next step -
		ELSE
			//******************************************************
			step						:= 255;							// next step -
		END_CASE

	//**************************************************************
	2:	// read the diagnostics for the specified node 
		// ->
		// -> inclusive the last b5 emergency telegrams
		// ->
		//**********************************************************
		nxcomGetDiag_0.enable 			:= TRUE;						// enable function block
		nxcomGetDiag_0.pDevice 			:= ADR('SS1.IF1');				// CANopen interface address
		nxcomGetDiag_0.node 			:= 3;							// node number (client address)
		nxcomGetDiag_0.flags 			:= nxcomFLAG_PEEK;				// means: Don't remove node from the diagnostics list
		nxcomGetDiag_0.pEmcyData 		:= ADR(emcyTelegram);			// pointer to an array of 5 emergency telegrams with 8 bytes each
		nxcomGetDiag_0();												// call function block instance

		//**********************************************************
		CASE nxcomGetDiag_0.status OF									// case function switch of
		//**********************************************************
		65535:	// ERR_BUSY
			//******************************************************
			;															// wait for different status
		//**********************************************************
		0:		// ERR_OK
			//******************************************************
			nxcomGetDiag_0.coStatus;									// see help file for the nxcomGetDiag function block
			nxcomGetDiag_0.nodeFlags;									// ...
			nxcomGetDiag_0.lastDiagInfo;								// ...
			nxcomGetDiag_0.devType;										// ...
			nxcomGetDiag_0.nmtState;									// ...
			nxcomGetDiag_0.emcyCount;									// Number of actually read emergency telegrams.
			//******************************************************
			step						:= 255;							// next step -
		ELSE
			//******************************************************
			step						:= 255;							// next step -
		END_CASE
	ELSE
		//**********************************************************
		step							:= 255;							// next step -
	END_CASE


END_PROGRAM




//******************************************************************
//
//	e x i t
//
//******************************************************************
PROGRAM _EXIT


//******************************************************************
// TODO : Add your code here
//******************************************************************
nxcomRecvEmcyDev_0.enable 				:= FALSE;						// disable function block on exit
nxcomRecvEmcyDev_0();													// call function block instance

//******************************************************************
nxcomGetDiag_0.enable 					:= FALSE;						// disable function block on exit
nxcomGetDiag_0();														// call function block instance


END_PROGRAM
