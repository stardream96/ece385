module mux21(input logic [15:0] In_0, In_1, 
				  input logic select,
				  output logic [15:0] Data_Out);

	always_comb
	begin
		case(select)
			1'b0: Data_Out = In_0;
			1'b1: Data_Out = In_1;
		endcase
	
	end
endmodule