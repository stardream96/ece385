/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000040;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;


void print (unsigned char * input) {
	int i;
	for (i = 0; i < 16; i++) {
		printf("%02x ", input[i]);
	}
	printf("\n");
}

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
 
 void AddRoundKey(unsigned char* ST, unsigned char* KS){
	//ST is state, KS is keyschedule
	int i;
	for(i = 0; i < 16; i++){
		ST[i] = ST[i] ^ KS[i];
	}
	//each round we need to update the 128-bit state. KS has all rounds ready
	//1 char is 8 bits, do it 16 times for a round.
}

void SubBytes(unsigned char* ST){
	int i;
	for(i = 0; i < 16; i++){
			ST[i] = aes_sbox[(unsigned int)ST[i]];
	}
	//go 16 rounds with the same reason as last times
	//do not need i and j because sbox is already an 1D array
}

void MixColumns (unsigned char* ST){
	int i, j;
	unsigned char temp[4];
	for (i = 0; i < 4; i++) {
		temp[0] = gf_mul[ST[i*4]][0] ^ gf_mul[ST[i*4+1]][1] ^ ST[i*4+2] ^ ST[i*4+3];
		temp[1] = ST[i*4] ^ gf_mul[ST[i*4+1]][0] ^ gf_mul[ST[i*4+2]][1] ^ ST[i*4+3];
		temp[2] = ST[i*4] ^ ST[i*4+1] ^ gf_mul[ST[i*4+2]][0] ^ gf_mul[ST[i*4+3]][1];
		temp[3] = gf_mul[ST[i*4]][1] ^ ST[i*4+1] ^ ST[i*4+2] ^ gf_mul[ST[i*4+3]][0];
		for (j = 0; j < 4; j++) {
			ST[i*4+j] = temp[j];
		}
	}
}

void ShiftRows(unsigned char* ST){
	unsigned char temp1 = ST[1];
	ST[1] = ST[5];
	ST[5] = ST[9];
	ST[9] = ST[13];
	ST[13] = temp1;

	unsigned char temp2 = ST[6];
	temp1 = ST[2];
	ST[2] = ST[10];
	ST[6] = ST[14];
	ST[10] = temp1;
	ST[14] = temp2;

	temp1 = ST[3];
	ST[3] = ST[15];
	ST[15] = ST[11];
	ST[11] = ST[7];
	ST[7] = temp1;
}
uint RotWord(uint word){
	
 	//printf("rotword") ;   from a0, a1, a2, a3 into a1, a2, a3, a0
 	//seperate
 	uint a3 = (word&0xFF); 
	uint a2 = (word&0xFF00) >> 8;
	uint a1 = (word&0xFF0000) >> 16;
	uint a0 = (word&0xFF000000) >> 24;
	//combine
/*	printf("%16x",word);
	word = a1<<24|a2<<16|a3<<8|a0;
	printf("%16x",word) ;*/
	
	//printf("before rot:%16x\n",word);//from a0, a1, a2, a3 into a3, a0, a1, a2????
	word = a3<<24|a0<<16|a1<<8|a2;
	//printf("after rot :%16x\n",word) ;
	return word;
 }
 
 uint SubWord (uint word) {
	unsigned char *get_byte = (unsigned char*)&word;
	int i;
	for (i = 0; i < 4; ++i) {
		get_byte[i] = aes_sbox[get_byte[i]];
	}
	return word;
}

void KeyExpansion (unsigned char * key, uint * key_schedule	) {
	int i,j;
	uint temp;
	for (i = 0; i < 4; i++) {
		key_schedule[i] = ((uint*)key)[i];
	}
	for (i = 1; i < 11; i++) { 	//starting from the second coloumn
		for (j = 0; j<4; j++){
			temp = key_schedule[i*4+j-1];
			if (j == 0){
				temp = RotWord(temp);
				temp = SubWord(temp);
				temp = temp ^ (Rcon[i] >> 24); // Rcon: big endian -> little endian
			}	
			key_schedule[i*4+j] = key_schedule[i*4+j-4] ^ temp;
		}
	
	}
}

void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
	unsigned char key_schedule[176];
	unsigned char key_state[16];
	// printf("\n");
	unsigned char state[16];
	int i;
	int round;
	for (i = 0; i < 16; i++) {
		state[i] = charsToHex (msg_ascii[i*2], msg_ascii[i*2+1]);
		key_state[i] = charsToHex (key_ascii[i*2], key_ascii[i*2+1]);
	}
	KeyExpansion (key_state, (uint*)key_schedule);
	// print(key_schedule);
	// print (input_key);

	AddRoundKey (state, key_schedule);
	for (round = 1; round < 10; round++) {
		SubBytes(state);
		ShiftRows (state);
		MixColumns (state);
		AddRoundKey (state, key_schedule+round*16);
	}
	SubBytes(state);
	ShiftRows (state);
	AddRoundKey (state, key_schedule+160);
/*
	for (i = 0; i < 16; i++) {
		output[i] = state[i];
	}*/
// translate to final output
	for (i = 0; i < 4; i++) {
		msg_enc[i] = (state[4*i] << 24) + (state[4*i + 1] << 16) + (state[4*i + 2] << 8) + state[4*i+3];
		key[i] = (int)(key_state[i*4]<<24)+(int)(key_state[i*4+1]<<16)+ (int)(key_state[i*4+2]<<8)+(int)(key_state[i*4+3]);
	}
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
