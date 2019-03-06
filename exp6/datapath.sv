module datapath (input logic GatePC, GateMDR, GateALU, GateMARMUX, 
						input logic [15:0] PCALU_Out, MDR, ALU, PC, 
						output logic [15:0] Data_Out);

	always_ff @ (GatePC or GateMDR or GateALU or GateMARMUX or PCALU_Out or MDR or ALU or PC)
	begin
		if(GatePC == 1)
			Data_Out <= PC;
		if(GateMDR == 1)
			Data_Out <= MDR;
		if(GateALU == 1)
			Data_Out <= ALU;	
		if(GateMARMUX == 1)
			Data_Out <= PCALU_Out;	
	end
endmodule
