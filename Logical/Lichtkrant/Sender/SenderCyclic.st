(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: Sender
 * File: SenderCyclic.st
 * Author: Bernecker & Rainer
 * Created: January 25, 2010
 ********************************************************************
 * Implementation of program Sender
 ********************************************************************)

(*************init program**********************)
PROGRAM _INIT
	serial_0.enable := TRUE;												(*enable sender by default*)	
END_PROGRAM

(*************cyclic program********************)
PROGRAM _CYCLIC
	
	txtChainCounter := UINT_TO_STRING(SHFTREG.typCounters.usChainCounter);
	txtSubChainCounter := UINT_TO_STRING(SHFTREG.typCounters.usChainOffset);
			
	text1 := CONCAT('cnt: ', txtChainCounter);
	text1 := CONCAT(text1, ' ');
	text1 := CONCAT(text1, 'sub: ');
	text1 := CONCAT(text1, txtSubChainCounter);
	IF RU.typOUT.bActivateGripper THEN
		text1 := 'Reject active!!!';
	END_IF
	
	IF BU[0].typOUT.bActivateGripper THEN
		text1 := 'BU -0-';
	END_IF
	IF BU[1].typOUT.bActivateGripper THEN
		text1 := 'BU -1-';
	END_IF
	IF BU[2].typOUT.bActivateGripper THEN
		text1 := 'BU -2-';
	END_IF
	IF BU[3].typOUT.bActivateGripper THEN
		text1 := 'BU -3-';
	END_IF
	IF BU[4].typOUT.bActivateGripper THEN
		text1 := 'BU -4-';
	END_IF
	IF BU[5].typOUT.bActivateGripper THEN
		text1 := 'BU -5-';
	END_IF
	IF BU[6].typOUT.bActivateGripper THEN
		text1 := 'BU -6-';
	END_IF
	IF BU[7].typOUT.bActivateGripper THEN
		text1 := 'BU -7-';
	END_IF
	IF BU[8].typOUT.bActivateGripper THEN
		text1 := 'BU -8-';
	END_IF
	IF BU[9].typOUT.bActivateGripper THEN
		text1 := 'BU -9-';
	END_IF
	
	setText_0.ThisData := LichtkrantData;
	
	IF Var2 = 1 THEN
		setText_0(font := LichtkrantData.fontCode_.narowSize_4x7);
	ELSIF Var2 = 2 THEN
		setText_0(font := LichtkrantData.fontCode_.normalSize_5x7);
	ELSIF Var2 = 3 THEN
		setText_0(color := LichtkrantData.colorCode_.brightGreen);
	ELSIF Var2 = 4 THEN
		setText_0(color := LichtkrantData.colorCode_.brightOrange);
	ELSIF Var2 = 5 THEN
		setText_0(presentation := LichtkrantData.laggingCom_.upDown);
	ELSIF Var2 = 6 THEN
		setText_0(presentation := LichtkrantData.laggingCom_.horizontalScroll);
	ELSIF Var2 = 7 THEN
		setText_0(presentation := LichtkrantData.laggingCom_.normal);	
	ELSIF Var2 = 8 THEN
		setText_0(interval := LichtkrantData.methodSpeed_.fast);		
	ELSIF Var2 = 9 THEN
		setText_0(interval := LichtkrantData.methodSpeed_.middle);		
	ELSIF Var2 = 10 THEN
		setText_0(interval := LichtkrantData.methodSpeed_.slow);						
	END_IF
	Var2 := 0;
	
	
	IF text_old <> text1 THEN
		setText_0(IN := text1); //Data conversion
		serial_0(text := setText_0.OUT);
		text_old := text1;
	END_IF

END_PROGRAM
