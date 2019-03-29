//// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
//// for ECE 385 - University of Illinois - Electrical and Computer Engineering
//// Author: Zuofu Cheng
//
//int main()
//{
//	int i = 0;
//	volatile unsigned int *LED_PIO = (unsigned int*)0x50; //make a pointer to access the PIO block
//	volatile unsigned int *Switch_PIO = (unsigned int*)0x40;
//	volatile unsigned int *Reset_PIO = (unsigned int*)0x30;
//	volatile unsigned int *Accumulate_PIO = (unsigned int*)0x20;
//
//	unsigned int sum = 0;
//	unsigned int flag = 0;
//	*LED_PIO = 0; //clear all LEDs
//	while ( (1+1) != 3) //infinite loop
//	{
//		if(*Reset_PIO == 0){
//			sum = 0;
//		}// if reset pressed then every thing turns to 0
//		else
//		{
//			if(*Accumulate_PIO == 0 && flag == 0){
//				sum = sum + *Switch_PIO;
//				if(sum > 255) sum = sum - 256;
//				flag = 1;
//			}// accumulate when pressed and handle overflow.
//			if(*Accumulate_PIO == 1){
//				flag = 0;
//			}
//		}
//
//		//for (i = 0; i < 100000; i++); //software delay
//
//		*LED_PIO = sum; //set LSB
//
//	}
//	return 1; //never gets here
//}
// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x50; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}
