module mux3_21(input logic [2:0] IN_0, IN_1, 
				  input logic SELECT,
				  output logic [2:0] Data_Out);

	always_ff @ (IN_0 or IN_1 or SELECT)
	begin
		if(SELECT == 0)
			Data_Out <= IN_0;
		if(SELECT == 1)
			Data_Out <= IN_1;
	
	end
endmodule