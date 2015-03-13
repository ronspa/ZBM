(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: AsNxCoM
 * File: AsNxCoM.typ
 * Author: B+R
 ********************************************************************
 * Data types of library AsNxCoM
 ********************************************************************)
                                                                      
TYPE
	nxcomEmcyTelegram_t		: STRUCT			(*emergency telegram*)
		data				: ARRAY[0..7] OF USINT;
	END_STRUCT;

	nxcomEmcyTelegrams_t	: STRUCT			(*array of emergency telegrams*)
		telegram			: ARRAY[0..4] OF nxcomEmcyTelegram_t;
	END_STRUCT;
END_TYPE
