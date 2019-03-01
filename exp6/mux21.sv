module mux21(input logic [15:0] In_0, In_1, 
				  input logic select,
				  output logic [15:0] Data_Out);

	always_ff @ (In_0 or In_1 or select)
	begin
		if(select == 0)
			Data_Out <= In_0;
		if(select == 1)
			Data_Out <= In_1;
	
	end
endmodule