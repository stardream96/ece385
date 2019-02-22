//-------------------------------------------------------------------------
//      lab6_toplevel.sv                                                 --
//                                                                       --
//      Created 10-19-2017 by Po-Han Huang                               --
//                        Spring 2018 Distribution                       --
//                                                                       --
//      For use with ECE 385 Experment 6                                 --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------
module lab6_toplevel( input logic [15:0] S,
                      input logic Clk, Reset, Run, Continue,
                      output logic [11:0] LED,
                      output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
                      output logic CE, UB, LB, OE, WE,
                      output logic [19:0] ADDR,
                      inout wire [15:0] Data);

							 
							 

			
//logic[3:0]    Opcode;
//logic         IR_5;
//logic         IR_11;
//logic         BEN;
//
//logic        LD_MAR;
//			LD_MDR;
//			LD_IR;
//			LD_BEN;
//			LD_CC;
//			LD_REG;
//			LD_PC;
//			LD_LED; // for PAUSE instruction
//			
// logic        GatePC;
//			GateMDR;
//			GateALU;
//			GateMARMUX;
//			
// logic [1:0]  PCMUX;
// logic        DRMUX;
//			SR1MUX;
//			SR2MUX;
//			ADDR1MUX;
// logic [1:0]  ADDR2MUX;
//			ALUK;
//
// logic        Mem_CE;
//			Mem_UB;
//			Mem_LB;
//			Mem_OE;
//			Mem_WE;
//ISDU Control{*,
//};
//
//reg_16 PC{
//				.Clk(Clk),
//				.LD(LD_PC),
//				.D(S)
//				.Data_Out(PC)
//};
//
//reg_16 MAR{
//				.Clk(Clk),
//				.LD(LD_MAR),
//				.D(PC)
//				.Data_Out(Address)
//};
//			
//			
//tristate tristate1{
//				.Clk(Clk),
//				.tristate_output_enable(),
//				.Data_write(),
//				.Data_read(),
//				.Data(Data)
//};
//reg_16 MDR{
//				.Clk(Clk),
//				.LD(LD_MDR),
//				.D(Data),
//				.Data_Out(MDR_out)
//};				
//
//reg_16 IR{
//				.Clk(Clk),
//				.LD(LD_IR),
//				.D(MDR_out),
//				.Data_Out(Instr)
//};
//

slc3 my_slc(.*);
// Even though test memory is instantiated here, it will be synthesized into 
// a blank module, and will not interfere with the actual SRAM.
// Test memory is to play the role of physical SRAM in simulation.
test_memory my_test_memory(.Reset(~Reset), .I_O(Data), .A(ADDR), .*);

endmodule