//------------------------------------------------------------------------------
// Company:        UIUC ECE Dept.
// Engineer:       Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 10-19-2017 
//    spring 2018 Distribution
//
//------------------------------------------------------------------------------
module slc3(
    input logic [15:0] S,
    input logic Clk, Reset, Run, Continue,
    output logic [11:0] LED,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic CE, UB, LB, OE, WE,
    output logic [19:0] ADDR,
    inout wire [15:0] Data //tristate buffers need to be of type wire
);
//self declared
logic [15:0] Bus_Data;	
logic [15:0] MDRtemp;
logic [2:0] SR1temp, DRtemp;
logic [15:0] SR2temp, SR1_Out, SR2_Out;
logic BENtemp;

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// Internal connections
logic BEN;
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;
logic MIO_EN;

logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC, ALU;
logic [15:0] Data_from_SRAM, Data_to_SRAM;

// Signals being displayed on hex display
logic [3:0][3:0] hex_4;
logic [15:0] PCtemp;
// For week 1, hexdrivers will display IR. Comment out these in week 2.
//HexDriver hex_driver3 (IR[15:12], HEX3);
//HexDriver hex_driver2 (IR[11:8], HEX2);
//HexDriver hex_driver1 (IR[7:4], HEX1);
//HexDriver hex_driver0 (IR[3:0], HEX0);

// For week 2, hexdrivers will be mounted to Mem2IO
 HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
 HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
 HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
 HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

// The other hex display will show PC for both weeks.
HexDriver hex_driver7 (PC[15:12], HEX7);
HexDriver hex_driver6 (PC[11:8], HEX6);
HexDriver hex_driver5 (PC[7:4], HEX5);
HexDriver hex_driver4 (PC[3:0], HEX4);

// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
// input into MDR)
assign ADDR = { 4'b00, MAR }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign MIO_EN = ~OE;	

logic [15:0] ADDR1_Out, ADDR2_Out;
logic [15:0] SEXT11,SEXT9,SEXT6,SEXT5;
logic [15:0] PCALU_Out;

// You need to make your own datapath module and connect everything to the datapath
// Be careful about whether Reset is active high or low
datapath d0 (.*, .Data_Out(Bus_Data));

// Our SRAM and I/O controller
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
);

// State machine and control signals
ISDU state_controller(
    .*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
    .Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
    .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
);

mux_21 ADDR1mux(
	.SELECT(ADDR1MUX),
	.IN_0(PC),
	.IN_1(SR1_Out),//REGISTER FILE
	.Data_Out(ADDR1_Out)
);

SEXT SEXTunit_ADDR2(
	.*,
	.In(IR[10:0])
);

mux_41 ADDR2mux(
	.SELECT(ADDR2MUX),
	.IN_00(16'h0000),
	.IN_01(SEXT6),
	.IN_10(SEXT9),
	.IN_11(SEXT11),
	.Out(ADDR2_Out)
);

ALU PCALU (
	.A(ADDR2_Out),
	.B(ADDR1_Out),
	.Sel(2'b00),
	.Out(PCALU_Out)
);

PCmux mux_for_PC(
				.*,
				.PCMUX(PCMUX),
				.IN_0(PC + 16'h0001),
				.IN_1(PCALU_Out),
				.IN_2(Bus_Data),
				.Data_Out(PCtemp)
);

reg_16 PCREG(
				.*,
				.LD(LD_PC),
				.D(PCtemp),
				.Data_Out(PC)
);

reg_16 MARREG(
				.*,
				.LD(LD_MAR),
				.D(Bus_Data),
				.Data_Out(MAR)
);

mux_21 MDRmux(
				.*,
				.SELECT(MIO_EN),
				.IN_0(Bus_Data),
				.IN_1(MDR_In),
				.Data_Out(MDRtemp)
);
		
reg_16 MDRREG(
				.*,
				.LD(LD_MDR),
				.D(MDRtemp),
				.Data_Out(MDR)
);

reg_16 IRREG(
				.*,
				.LD(LD_IR),
				.D(Bus_Data),
				.Data_Out(IR)
);

mux3_21 DRmux(
				.SELECT(DRMUX),
				.IN_0(IR[11:9]),
				.IN_1(3'b111),
				.Data_Out(DRtemp)
);

mux3_21 SR1mux(
				.SELECT(SR1MUX),
				.IN_0(IR[11:9]),
				.IN_1(IR[8:6]),
				.Data_Out(SR1temp)
);
			
mux_21 SR2mux(
				.SELECT(SR2MUX),
				.IN_0(SR2_Out),
				.IN_1(SEXT5),
				.Data_Out(SR2temp)
);

RegFile RegisterF(
				.*,
				.DR(DRtemp),
				.SR1(SR1temp),
				.SR2(IR[2:0]),
				.Data_In(Bus_Data)
);
				
ALU alu (
	.A(SR1_Out),
	.B(SR2temp),
	.Sel(ALUK),
	.Out(ALU)
);

NZP nzp(
	.*,
	.Data_Out(BENtemp)
);

reg_1 ben(
	.*,
	.LD(LD_BEN),
	.D(BENtemp),
	.Data_Out(BEN)
);
	

endmodule
