(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Inverter
 * Author: HD
 * Created: March 15, 2011
 ********************************************************************
 * Implementation of library Invertor
 ********************************************************************) 
(*-------------------------------------------------------------
Setting in I/O configuration X64 ACOPOS inverter

SDC settings	no
IO mapping 	packed

ACPinverter.packed.ETAD		status
ACPinverter.packed.CMDD		command
ACPinverter.packed.LFR		speed [hz]

---------------------------------------------------------------
Com_typ		input		structure
---------------------------------------------------------------
command.iSetSpeed;				[INT]	Hz (0.1) / Rpm (1000 uints = 6 hz) , (+value = forward,  -value = reverse)
command.bPower;					[BOOL]	Power on
command.bEnabledStop			[BOOL]	0 = inverter switch to status "switch on" (16#0023) after stop
																	1 = inverter remain on status "enable operation" (16#0027) after stop 
command.bRun;					[BOOL]	Start run forward with value iSetSpeed;
command.bRunReverse;			[BOOL]	Start run reverse with value iSetSpeed;
command.bQuickStop;				[BOOL]	Quickstop, emergency stop
command.bResetFault;			[BOOL]	Reset error on invertor

---------------------------------------------------------------
Sts_typ		output		structure
---------------------------------------------------------------
status.uiDrive;					[UINT]	Drive status (ETAD AND mask 16#006F)	
status.bReadyToSwitchOn			[BOOL]	Drive is ready to switch power on
status.bDriveReady;				[BOOL]	Drive is switched on, power is on
status.bRun;					[BOOL]	Drive is running
status.bSetSpeedReached			[BOOL]	Speed setpoint is reached
status.bFault;					[BOOL]	Error active	
status.bQuickStopActive;		[BOOL]	Quickstop active
strHmiInfo						[STRING[80]		Hmi info text
strErrorInfo					[STRING(80)]	Fault info text

---------------------------------------------------------------
History:
Version:	Date:				author:	change:
1.00		19-07-2011		HD			changed to one motor structure VAR INOUT
2.00		23-12-2011		HD			added "MotorStruc.status.bSetSpeedReached" 
2.10		23-07-2012		HD			when operation enabled, stop then goto switch on
2.20		12-09-2012		HD			Oneshot bit added at reset fault
3.00		07-05-2013		HD			changed and tested for all invertors
3.10		26-06-2013		HD			add fault info "strErrorInfo"	and HMI info "strHmiInfo"
--------------------------------------------------------------- *)

FUNCTION_BLOCK ACPinverter

	IF EDGEPOS(bResetFault) THEN
		_InverterCommand := INV_CMD_INIT;
		bResetFault := FALSE;
	END_IF
	
	IF iSpeed <> 0 AND iSpeed <> MotorStruc.command.iSetSpeed THEN
		MotorStruc.command.iSetSpeed := iSpeed;
	END_IF
	
	CASE _InverterCommand OF
		//======================================
		INV_CMD_INIT:
			//======================================
			_InverterCommand := INV_CMD_SETSPEED;
			tonTimeOut.PT := T#500ms;
		
		//======================================
		INV_CMD_SETSPEED: 				
			//======================================	
			//Set speed (iSetSpeed/30=Hz)
			MotorStruc.command.iSetSpeed := (iSpeed);	
			_InverterCommand := INV_CMD_POWERON;
		
		//======================================
		INV_CMD_POWERON:	
			//======================================	
			//Power up frequency inverter
			//Check if 'fi' is Ready for switching on
			tonTimeOut(IN := TRUE);
			
			IF MotorStruc.status.bReadyToSwitchOn THEN
				//Power up 'fi'
				MotorStruc.command.bPower := TRUE;
				_InverterCommand := INV_CMD_READY;
				tonTimeOut(IN := FALSE);
			ELSIF MotorStruc.status.bDriveReady THEN
				_InverterCommand := INV_CMD_READY;
			ELSIF tonTimeOut.Q THEN
				//Power down 'fi'
				MotorStruc.command.bPower := FALSE;
				_InverterCommand := INV_CMD_RESETFAULT;
				tonTimeOut(IN := FALSE);
			END_IF	
		
		//======================================
		INV_CMD_RESETFAULT:
			//======================================
			tonTimeOut(IN := TRUE);
			//Reset fault
			MotorStruc.command.bResetFault := MotorStruc.status.bFault;
			
			_InverterCommand := INV_CMD_READY;
			//Check for any FAULTS
			IF MotorStruc.status.bFault AND tonTimeOut.Q THEN
				//Stop 'fi'
				MotorStruc.command.bRun := FALSE;
				MotorStruc.status.bRun := FALSE;
				//bRun_ := _bRun;		
				MotorStruc.command.bResetFault := FALSE;
				_InverterCommand := INV_CMD_ERROR;
				tonTimeOut(IN := FALSE);
			ELSIF MotorStruc.status.bFault THEN
				MotorStruc.command.bResetFault := TRUE;
			ELSIF tonTimeOut.Q THEN
				tonTimeOut(IN := FALSE);
				_InverterCommand := INV_CMD_INIT;
			END_IF	
		
		//======================================
		INV_CMD_READY:
			//======================================
			tonTimeOut(IN := TRUE);
			InverterState_ := INV_ST_READY;
			//Drive remains in enabled state, when run TRUE or FALSE
			MotorStruc.command.bEnabledStop := TRUE;
			//Check if frequency drive is Ready		
			IF MotorStruc.status.bDriveReady THEN
				//'fi' can be operated; bRun, bRunReverse
				MotorStruc.command.bRun := bRun;
				MotorStruc.command.bRunReverse := bRunReverse;
			ELSIF tonTimeOut.Q THEN
				_InverterCommand := INV_CMD_ERROR;
				tonTimeOut(IN := FALSE);
			END_IF	
		
		//======================================
		INV_CMD_ERROR:
			//======================================	
			InverterState_ := INV_ST_FAULT;
	END_CASE

	
	// Speed
	MotorStruc.packed.LFR := MotorStruc.packed.LFRD := MotorStruc.command.iSetSpeed;

	//-------------------------------------------------------------------------------	
	// Mask the DRIVECOM status word 
	// bit 0 = Ready to switch on
	// bit 1 = Switch on
	// bit 2 = Operation enabled
	// bit 3 = Malfuntion, fault
	// bit 4 = x
	// bit 5 = Quick stop
	// bit 6 = Switch on disabled
	
	MotorStruc.status.uiDrive := MotorStruc.packed.ETAD AND 16#006F;

	//-------------------------------------------------------------------------------	
	MotorStruc.status.bReadyToSwitchOn := 0;
	MotorStruc.status.bDriveReady := 0;
	MotorStruc.status.bRun := 0;
	MotorStruc.status.bQuickStopActive := 0;
	MotorStruc.status.bFault := 0;


	CASE MotorStruc.status.uiDrive OF

		//-------------------------------------------	
		16#0000:	// Not ready to switch on
		//-------------------------------------------	
		// Error network	

		//-------------------------------------------	
		16#0007: // Quick stop active
		//-------------------------------------------	
		MotorStruc.status.bQuickStopActive := 1;
		
		// Wait untill quick stop is zero 
		IF (MotorStruc.command.bQuickStop = 0) THEN
			MotorStruc.packed.CMDD := 16#0000;
		END_IF


		//-------------------------------------------	
		16#0008, 16#0028: // Drive in fault state
		//-------------------------------------------	
		MotorStruc.status.bFault := 1;

		// reset fault 
		IF (MotorStruc.command.bResetFault = 1) AND (bResetFault = 0) THEN
			MotorStruc.packed.CMDD := 16#0080;
		END_IF
		bResetFault := MotorStruc.command.bResetFault;


		//-------------------------------------------	
		16#0040, 16#0050:	// Switch on disable		
		//-------------------------------------------	
		MotorStruc.status.bReadyToSwitchOn := 1;

		IF (MotorStruc.command.bPower = 1)  THEN
			IF (MotorStruc.command.bQuickStop = 0) THEN
				MotorStruc.packed.CMDD := 16#0006;
			ELSE				
				MotorStruc.packed.CMDD := 16#0002;
			END_IF
		ELSE // Disable power
			MotorStruc.packed.CMDD := 16#0000;	
		END_IF


		//-------------------------------------------	
		16#0021, 16#0031:	// Ready to switch on
		//-------------------------------------------	
		IF (MotorStruc.command.bPower = 1)  THEN
			IF (MotorStruc.command.bQuickStop = 0) THEN
				MotorStruc.packed.CMDD := 16#0007;
			ELSE				
				MotorStruc.packed.CMDD := 16#0002;
			END_IF
		ELSE // Disable power
			MotorStruc.packed.CMDD := 16#0000;	
		END_IF


		//-------------------------------------------	
		16#0023:	 // Switch on
		//-------------------------------------------	
		MotorStruc.status.bDriveReady := 1;

		//  command run 
		IF (MotorStruc.command.bRun = 1) THEN
			IF (MotorStruc.command.bRunReverse = 0) THEN
				MotorStruc.packed.CMDD := 16#000F;
			ELSE//  command run reverse 
				MotorStruc.packed.CMDD := 16#080F;	
			END_IF
		END_IF
		
		// Disable power or quick stop	
		IF (MotorStruc.command.bPower = 0) THEN	
			MotorStruc.packed.CMDD := 16#0000;	
		ELSIF (MotorStruc.command.bQuickStop = 1) THEN
			MotorStruc.packed.CMDD := 16#0002;
		END_IF
	
		
		//-------------------------------------------	
		16#0027: // Operation enabled
		//-------------------------------------------	
		MotorStruc.status.bDriveReady := 1;

		//  command run 
		IF (MotorStruc.command.bRun = 1) THEN
			MotorStruc.status.bRun := 1;
			IF (MotorStruc.command.bRunReverse = 0) THEN
				MotorStruc.packed.CMDD := 16#000F;
			ELSE//  command run reverse 
				MotorStruc.packed.CMDD := 16#080F;	
			END_IF
		ELSE // stop
			MotorStruc.status.bRun := 0;
			IF	(MotorStruc.command.bEnabledStop = 1) THEN	// Invertor remains in enable operation status 16#0027 
				MotorStruc.packed.CMDD := 16#110F;						// S44 / P74 / P84 = 16#010F, X64 = 16#100F
			ELSE
				MotorStruc.packed.CMDD := 16#0007;	 					// Invertor in switched on status 16#0023
			END_IF
		END_IF
			
		// Disable power or quick stop	
		IF (MotorStruc.command.bPower = 0) THEN	
			MotorStruc.packed.CMDD := 16#0000;	
		ELSIF (MotorStruc.command.bQuickStop = 1) THEN
			MotorStruc.packed.CMDD := 16#0002;
		END_IF

		ELSE	// status unknown
		MotorStruc.packed.CMDD := 16#0000;
		
	END_CASE

	MotorStruc.status.bSetSpeedReached := MotorStruc.packed.ETAD.10 AND MotorStruc.status.bRun;

	//--------------------------------------------------------------------------------------------	
	// HMI info, drive state
	//--------------------------------------------------------------------------------------------	
	CASE MotorStruc.packed.HMIS OF
		
		1: MotorStruc.status.strHmiInfo := 'DC injection braking (dCb)';
		2: MotorStruc.status.strHmiInfo := 'Drive ready (rdY)';
		3: MotorStruc.status.strHmiInfo := 'Freewheel stop control (nSt)';
		4: MotorStruc.status.strHmiInfo := 'Drive running (rUn)';
		5: MotorStruc.status.strHmiInfo := 'In accel. (ACC)';
		6: MotorStruc.status.strHmiInfo := 'In decel. (dEC)';
		7: MotorStruc.status.strHmiInfo := 'Current limitation (CLI)';
		8: MotorStruc.status.strHmiInfo := 'Fast stop (FSt)';
		9: MotorStruc.status.strHmiInfo := 'Vector regulation active (FLU)';
		11: MotorStruc.status.strHmiInfo := 'Control switched on, DC bus not charged (nLP)';
		12: MotorStruc.status.strHmiInfo := 'Active PWR (PrA)';
		13: MotorStruc.status.strHmiInfo := 'Controlled stop (CtL)';
		14: MotorStruc.status.strHmiInfo := 'Adapted deceleration (Obr)';
		15: MotorStruc.status.strHmiInfo := 'Standby output cut (SOC)';
		17: MotorStruc.status.strHmiInfo := 'Undervoltage alarm (USA)';
		18: MotorStruc.status.strHmiInfo := 'TC indust. mode activated (tC)';
		19: MotorStruc.status.strHmiInfo := 'in autotest (St)';
		20: MotorStruc.status.strHmiInfo := 'autotest error (FA)';
		21: MotorStruc.status.strHmiInfo := 'Autotest OK (YES)';
		22: MotorStruc.status.strHmiInfo := 'eeprom test (EP)';
		23: MotorStruc.status.strHmiInfo := 'In fault (FLt)';
		28: MotorStruc.status.strHmiInfo := 'Safety level SS1 active (SS1)';
		29: MotorStruc.status.strHmiInfo := 'Safety level SLS active (SLS)';
		30: MotorStruc.status.strHmiInfo := 'Safety level STO active (StO)';
	END_CASE
	
	//--------------------------------------------------------------------------------------------	
	// Error info
	//--------------------------------------------------------------------------------------------	
	IF (MotorStruc.status.bFault) THEN

		MotorStruc.status.strErrorInfo :='Fault';
		CASE MotorStruc.packed.ERRD OF
			1:	MotorStruc.status.strErrorInfo := 'Calibration error (InF)';
			2:	MotorStruc.status.strErrorInfo := 'Control Eeprom (EEF1)';
			3:	MotorStruc.status.strErrorInfo := 'Internal- I measure (InF9)';
			4:	MotorStruc.status.strErrorInfo := 'Internal-mains circuit (InFA)';
			5:	MotorStruc.status.strErrorInfo := 'Modbus com. (SLF1)';
			6:	MotorStruc.status.strErrorInfo := 'int. com.link (ILF)';
			7:	MotorStruc.status.strErrorInfo := 'Com. network (CnF)';
			8:	MotorStruc.status.strErrorInfo := 'External fault at LI or local connection (EPF1)';
			9:	MotorStruc.status.strErrorInfo := 'Overcurrent (OCF)';
			10:	MotorStruc.status.strErrorInfo := 'Capacitor precharge (CrF)';
			11:	MotorStruc.status.strErrorInfo := 'Encoder feedback signal missing (SPF)';
			16:	MotorStruc.status.strErrorInfo := 'Drive overheat (OHF)';
			17:	MotorStruc.status.strErrorInfo := 'Motor overload (OLF)';
			18:	MotorStruc.status.strErrorInfo := 'Overbraking (ObF)';
			19:	MotorStruc.status.strErrorInfo := 'Mains overvoltage (OSF)';
			20:	MotorStruc.status.strErrorInfo := '1 output phase loss (OPF1)';
			21:	MotorStruc.status.strErrorInfo := 'Input phase loss (PHF)';
			22:	MotorStruc.status.strErrorInfo := 'Mains Undervoltage (USF)';
			23:	MotorStruc.status.strErrorInfo := 'Motor short circuit phase/phase (SCF1)';
			24:	MotorStruc.status.strErrorInfo := 'Motor overspeed (SOF)';
			25:	MotorStruc.status.strErrorInfo := '[Auto-tuning] (tnF)';
			26:	MotorStruc.status.strErrorInfo := 'Unknown drive rating (InF1)';
			27:	MotorStruc.status.strErrorInfo := 'Unknown or incompatible power board (InF2)';
			28:	MotorStruc.status.strErrorInfo := 'Interruption of internal serial communication (InF3)';
			29:	MotorStruc.status.strErrorInfo := 'Invalid industrialization zone (InF4)';
			30:	MotorStruc.status.strErrorInfo := 'Power Eeprom (EEF2)';
			31:	MotorStruc.status.strErrorInfo := 'Impedant sh. circuit (SCF2)';
			32:	MotorStruc.status.strErrorInfo := 'Ground short circuit (SCF3)';
			33:	MotorStruc.status.strErrorInfo := '3 output phase loss (OPF2)';
			34:	MotorStruc.status.strErrorInfo := 'CAN com. (COF)';
			35:	MotorStruc.status.strErrorInfo := 'Brake control (bLF)';
			38:	MotorStruc.status.strErrorInfo := 'External fault com. (EPF2)';
			41:	MotorStruc.status.strErrorInfo := 'Brake feedback (brF)';
			42:	MotorStruc.status.strErrorInfo := 'PC com. (SLF2)';
			43:	MotorStruc.status.strErrorInfo := 'Enc. coupl. (ECF)';
			44:	MotorStruc.status.strErrorInfo := 'Torque/current limit (SSF)';
			45:	MotorStruc.status.strErrorInfo := 'HMI com. (SLF3)';
			46:	MotorStruc.status.strErrorInfo := 'Power removal (PrF)';
			49:	MotorStruc.status.strErrorInfo := 'LI6=PTC probe (PtFL)';
			50:	MotorStruc.status.strErrorInfo := 'PTC fault (OtFL)';
			51:	MotorStruc.status.strErrorInfo := 'Internal- I measure (InF9)';
			52:	MotorStruc.status.strErrorInfo := 'Internal-mains circuit (InFA)';
			53:	MotorStruc.status.strErrorInfo := 'Internal- thermperature sensor (InFb)';
			54:	MotorStruc.status.strErrorInfo := 'IGBT overheat (tJF)';
			55:	MotorStruc.status.strErrorInfo := 'IGBT short circuit (SCF4)';
			56:	MotorStruc.status.strErrorInfo := 'Motor short circuit (SCF5)';
			57:	MotorStruc.status.strErrorInfo := 'Torque time-out (SrF)';
			58:	MotorStruc.status.strErrorInfo := 'Output contactor stuck (closed) (FCF1)';
			59:	MotorStruc.status.strErrorInfo := 'Outut contactor open (FCF2)';
			61:	MotorStruc.status.strErrorInfo := 'AI2 input (AI2F)';
			64:	MotorStruc.status.strErrorInfo := 'input contactor fault (LCF)';
			66:	MotorStruc.status.strErrorInfo := 'Diff. I fault (dCF)';	
			67:	MotorStruc.status.strErrorInfo := 'IGBT desaturation (HdF)';	
			68:	MotorStruc.status.strErrorInfo := 'Unknown or incompatible option card (InF6)';
			69:	MotorStruc.status.strErrorInfo := 'internal CPU error (InFE)';	
			71:	MotorStruc.status.strErrorInfo := 'AI3 4-20mA loss (LFF3)';
			73:	MotorStruc.status.strErrorInfo := 'Error in hardware configuration (HCF)';
			76:	MotorStruc.status.strErrorInfo := 'Dynamic load fault (dLF)';
			77:	MotorStruc.status.strErrorInfo := 'Internal- thermperature sensor (InFb)';
			99:	MotorStruc.status.strErrorInfo := 'Channel switch fault (CSF)';	
			100:	MotorStruc.status.strErrorInfo := 'Speed underload (ULF)';
			101:	MotorStruc.status.strErrorInfo := 'Torque Overload Fault (OLC)';
			105:	MotorStruc.status.strErrorInfo := 'Angle error (ASF)';	
			107:	MotorStruc.status.strErrorInfo := 'Safety fault (SAFF)';
			108:	MotorStruc.status.strErrorInfo := 'Function Block Errors (FbE)';
			109:	MotorStruc.status.strErrorInfo := 'Function block stop fault (FbES)';
	
		END_CASE;
	
	ELSE
		IF NOT MotorStruc.packed.ModuleOk THEN
			MotorStruc.status.strErrorInfo := 'Module error';
		ELSE
			IF MotorStruc.status.bRun THEN
				MotorStruc.status.strErrorInfo := 'Run';
			ELSE
				IF MotorStruc.status.bDriveReady THEN
					MotorStruc.status.strErrorInfo := 'Ready';
				ELSE
					MotorStruc.status.strErrorInfo := '';
				END_IF
			END_IF
		END_IF
	END_IF

END_FUNCTION_BLOCK
