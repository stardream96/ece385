module PCmux (input logic [15:0] IN_0, IN_1, IN_2, 
						input logic [1:0] PCMUX, 
						output logic [15:0] Data_Out);

	always_ff @ (IN_0 or IN_1 or IN_2 or PCMUX)
	begin
		if(PCMUX == 2'b00)
			Data_Out <= IN_0;
		if(PCMUX == 2'b01)
			Data_Out <= IN_1;
		if(PCMUX == 2'b10)
			Data_Out <= IN_2;		
	end
endmodule