//io_handler.c
#include "io_handler.h"
#include <stdio.h>
#include "alt_types.h"
#include "system.h"

void IO_init(void)
{
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
	// Reset OTG chip
	*otg_hpi_cs = 0;
	*otg_hpi_reset = 0;
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	*otg_hpi_cs = 0;
	*otg_hpi_address = Address;
	*otg_hpi_w = 0;

	/* write the data */
	*otg_hpi_data = Data;

	/* Turn off all the signals */
	*otg_hpi_cs = 1;
	*otg_hpi_w = 1;
	*otg_hpi_data = 0;
}

alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//.
	/* specify where to read from */
	*otg_hpi_address = Address;
	*otg_hpi_cs = 0;
	*otg_hpi_r = 0;

	/* grab the data that was read */
	temp = *otg_hpi_data;

	/* Turn off all the signals */
	*otg_hpi_r = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_address = 0;

	//printf("%x\n",temp);
	return temp;

}