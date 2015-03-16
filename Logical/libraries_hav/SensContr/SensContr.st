(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: SensContr
 * File: SensContr.st
 * Author: jorkes
 * Created: December 01, 2014
 *******************************************************************)
FUNCTION_BLOCK fbSensControl
	tpSensPuls_0(IN := EDGEPOS(IN), PT := tiSensDelay);
	tpSensPuls_1(IN := EDGENEG(tpSensPuls_0.Q), PT := tiSensPuls);
	Q := tpSensPuls_1.Q;
END_FUNCTION_BLOCK
FUNCTION_BLOCK fbSensDelay
	tpSensPuls_0(IN := EDGEPOS(IN), PT := tiSensDelay);
	tpSensPuls_1(IN := EDGENEG(tpSensPuls_0.Q), PT := tiSensPuls);
	Q := tpSensPuls_1.Q;
END_FUNCTION_BLOCK