(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Lichtkrant
 * File: Lichtkrant.typ
 * Author: jorkes
 * Created: November 17, 2014
 ********************************************************************
 * Data types of library Lichtkrant
 ********************************************************************)

TYPE
	_methodSpeed : 	STRUCT 
		fast : STRING[4] := '<MA>';
		middle : STRING[4] := '<MQ>';
		slow : STRING[4] := '<Ma>';
	END_STRUCT;
	_laggingCom : 	STRUCT 
		normal : STRING[4] := '<FK>';
		upDown : STRING[4] := '<FJ>';
		horizontalScroll : STRING[4] := '<FF>';
	END_STRUCT;
	DataPackage : 	STRUCT 
		lineNumber : STRING[4] := '<L1>';
		pageNumber : STRING[4] := '<PA>';
		leadingCom : STRING[4] := '<FA>';
		methodSpeed : STRING[4] := '<MA>';
		waitingTime : STRING[4] := '<WA>';
		methodSpeed_ : _methodSpeed := (fast:='<MA>',middle:='<MQ>',slow:='<Ma>');
		laggingCom_ : _laggingCom := (normal:='<FK>',upDown:='<FJ>',horizontalScroll:='<FF>');
		laggingCom : STRING[4] := '<FK>';
		fontCode : STRING[4] := '<CC>';
		colorCode : STRING[4] := '<AA>';
		fontCode_ : _fontCode := (narowSize_4x7:='<AC>',boldSize_6x7:='<AB>',normalSize_5x7:='<AA>');
		colorCode_ : _colorCode := (Yellow:='<CJ>',brightOrange:='<CI>',brightGreen:='<CF>',brightRed:='<CC>');
	END_STRUCT;
	_fontCode : 	STRUCT 
		narowSize_4x7 : STRING[4] := '<AC>';
		boldSize_6x7 : STRING[4] := '<AB>';
		normalSize_5x7 : STRING[4] := '<AA>';
	END_STRUCT;
	_colorCode : 	STRUCT 
		Yellow : STRING[4] := '<CJ>';
		brightOrange : STRING[4] := '<CI>';
		brightGreen : STRING[4] := '<CF>';
		brightRed : STRING[4] := '<CC>';
	END_STRUCT;
END_TYPE
