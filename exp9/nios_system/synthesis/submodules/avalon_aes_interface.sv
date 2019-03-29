/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);
logic LD0,LD1,LD2,LD3,LD4,LD5,LD6,LD7,LD8,LD9,LD10,LD110,LD12,LD13,LD14,LD15;
logic [31:0] OUT0,OUT1,OUT2,OUT3,OUT4,OUT5,OUT6,OUT7,OUT8,OUT9,OUT10,OUT11,OUT12,OUT13,OUT14,OUT15;

always_comb 
	begin
		LD0 = 0;
		LD1 = 0;
		LD2 = 0;
		LD3 = 0;
		LD4 = 0;
		LD5 = 0;
		LD6 = 0;
		LD7 = 0;
		LD8 = 0;
		LD9 = 0;
		LD10 = 0;
		LD11 = 0;
		LD12 = 0;
		LD13 = 0;
		LD14 = 0;
		LD15 = 0;
		EXPORT_DATA = {OUT4[31:16], OUT7[15:0]};
		
		if(AVL_READ && AVL_CS)
		begin
		
			case(AVL_ADDR)
				4'b0000:
					AVL_READDATA = OUT0;
				4'b0001:
					AVL_READDATA = OUT1;
				4'b0010:
					AVL_READDATA = OUT2;
				4'b0011:
					AVL_READDATA = OUT3;
				4'b0100:
					AVL_READDATA = OUT4;
				4'b0101:
					AVL_READDATA = OUT5;
				4'b0110:
					AVL_READDATA = OUT6;
				4'b0111:
					AVL_READDATA = OUT7;
				4'b1000:
					AVL_READDATA = OUT8;
				4'b1001:
					AVL_READDATA = OUT9;
				4'b1010:
					AVL_READDATA = OUT10;
				4'b1011:
					AVL_READDATA = OUT11;
				4'b1100:
					AVL_READDATA = OUT12;
				4'b1101:
					AVL_READDATA = OUT13;
				4'b1110:
					AVL_READDATA = OUT14;
				4'b1111:
					AVL_READDATA = OUT15;
				default:;
			endcase
		end
		
		if(AVL_WRITE && AVL_CS)
			begin
				case(AVL_ADDR)
					4'b0000:
						LD0 = 1;
					4'b0001:
						LD1 = 1;
					4'b0010:
						LD2 = 1;
					4'b0011:
						LD3 = 1;
					4'b0100:
						LD4 = 1;
					4'b0101:
						LD5 = 1;
					4'b0110:
						LD6 = 1;
					4'b0111:
						LD7 = 1;
					4'b1000:
						LD8 = 1;
					4'b1001:
						LD9 = 1;
					4'b1010:
						LD10 = 1;
					4'b1011:
						LD11 = 1;
					4'b1100:
						LD12 = 1;
					4'b1101:
						LD13 = 1;
					4'b1110:
						LD14 = 1;
					4'b1111:
						LD15 = 1;
					default:;
				endcase
			end
				
	end

	
	

		
reg32 REG0(.*, LD(LD0), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT0));
reg32 REG1(.*, LD(LD1), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT1));
reg32 REG2(.*, LD(LD2), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT2));
reg32 REG3(.*, LD(LD3), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT3));
reg32 REG4(.*, LD(LD4), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT4));
reg32 REG5(.*, LD(LD5), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT5));
reg32 REG6(.*, LD(LD6), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT6));
reg32 REG7(.*, LD(LD7), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT7));
reg32 REG8(.*, LD(LD8), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT8));
reg32 REG9(.*, LD(LD9), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT9));
reg32 REG10(.*, LD(LD10), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT10));
reg32 REG11(.*, LD(LD11), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT11));
reg32 REG12(.*, LD(LD12), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT12));
reg32 REG13(.*, LD(LD13), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT13));
reg32 REG14(.*, LD(LD14), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT14));
reg32 REG15(.*, LD(LD15), .Data(AVL_WRITEDATA), .BE(AVL_BYTE_EN), .Output(OUT15));

	

endmodule
