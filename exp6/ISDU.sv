//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------
`include "SLC3_2.sv"
import SLC3_2::*;

module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				);

	enum logic [3:0] {  Halted, 
						PauseIR1, 
						PauseIR2, 
						S_18, 
						S_33_1, 
						S_33_2, 
						S_35, 
						S_32, 
						S_01}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b1;
		Mem_WE = 1'b1;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;                      
			S_18 : 
				Next_state = S_33_1;
			// Any states involving SRAM require more than one clock cycles.
			// The exact number will be discussed in lecture.
			S_33_1 : 
				Next_state = S_33_2;
			S_33_2 : 
				Next_state = S_35;
			S_35 : 
				Next_state = s_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
			PauseIR1 : 
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
			S_32 : 
				case (Opcode)
					4'b0001 : //ADD
						Next_state = S_01;
				
					4'b0101 : //AND
						next_state = S_05;
				
					4'b1001 : //NOT
						next_state = S_09;
				
					4'b0000 : //BR
						next_state = S_00;
				
					4'b1100 : //JMP
						next_state = S_12;
				
					4'b0100 : //JSR
						next_state = S_04;
				
					4'b0110 : //LDR
						next_state = S_06;
				
					4'b0111 : //STR
						next_state = S_07;
				
					4'b1101 : //PAUSE
						next_state = S_13;	
					// You need to finish the rest of opcodes.....

					default : 
						Next_state = PauseIR1;
				endcase
			S_01 : //ADD
				Next_state = S_18;
			S_05 : //AND
				Next_state = S_18;
			S_09 : //NOT
				Next_state = S_18;
			S_00 : //BR
				if IR11
					Next_state = S_22;
				else
					Next_state = S_18;
			S_22 : //in BR,PC<-PC+off9
				Next_state = S_18;
			S_12 : //JMP
				Next_state = S_18;
			S_04 : //JSR
				Next_state = S_21;
			S_21 : //in JSR, PC<-PC+off11
				Next_state = S_18;
			S_20 : //in JSR, PC<-BaseR
				Next_state = S_18;
			S_06 : //MAR<-B+off6
				Next_state = S_25;
			S_25 : //MDR<-M[MAR]
				Next_state = S_27;
			S_27 : //DR<-MDR, set CC
				Next_state = S_18;
			S_07 : //STR
				Next_state = S_23;
			S_23 : //MDR<-SR
				Next_state = S_16;
			S_16 : //M[MAR]<-MDR
				Next_state = S_18;
			S_13 ://PAUSE, need modify
				Next_state = S_18;

			// You need to finish the rest of states.....

			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: ;
			S_18 : 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			S_33_1 : 
				Mem_OE = 1'b0;
			S_33_2 : 
				begin 
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
			S_35 : 
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1: ;
			PauseIR2: ;
			S_32 : 
				LD_BEN = 1'b1;
			S_01 : 
				begin 
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					// incomplete...
				end
			S_05 : //AND
			
				Next_state = S_18;
			S_09 : //NOT
				Next_state = S_18;
			S_00 : //BR
				if IR11
					Next_state = S_22;
				else
					Next_state = S_18;
			S_22 : //in BR,PC<-PC+off9
				Next_state = S_18;
			S_12 : //JMP,PC<-R(BaseR)
				begin
					LD_PC = 1'b1;
					PCMUX = 2'b10;//pass value from ALU to PC
					SR1MUX = 1'b1;//pass IR[8:6] into reg file
					ADDR1MUX = 1'b1;	//pass SR1 output to ALU
					ADDR2MUX = 1'b00;	//pass SEXT IR[5:0] to ALU
					
					Mem_OE = 1'b1;
					Mem_WE = 1'b1;
				end
			S_04 : //JSR
				Next_state = S_21;
			S_21 : //in JSR, PC<-PC+off11
				Next_state = S_18;
			S_20 : //in JSR, PC<-BaseR
				Next_state = S_18;
			S_06 : //MAR<-B+off6
				Next_state = S_25;
			S_25 : //MDR<-M[MAR]
				Next_state = S_27;
			S_27 : //DR<-MDR, set CC
				Next_state = S_18;
			S_07 : //STR
				Next_state = S_23;
			S_23 : //MDR<-SR
				Next_state = S_16;
			S_16 : //M[MAR]<-MDR
				Next_state = S_18;
			S_13 ://PAUSE, need modify
				Next_state = S_18;
			// You need to finish the rest of states.....

			default : ;
		endcase
	end 

	 // These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule
