module mux_21(input logic [15:0] IN_0, IN_1, 
				  input logic SLK,
				  output logic [15:0] Data_Out);

	always_ff @ (IN_0 or IN_1 or SLK)
	begin
		if(SLK == 0)
			Data_Out <= IN_0;
		if(SLK == 1)
			Data_Out <= IN_1;
	
	end
endmodule