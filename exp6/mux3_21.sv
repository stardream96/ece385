module mux3_21(input logic [2:0] IN_0, IN_1, 
				  input logic SELECT,
				  output logic [2:0] Data_Out);

	always_comb
	begin			
		case(SELECT)
			1'b0: Data_Out = IN_0;
			1'b1: Data_Out = IN_1;
		endcase
	end
endmodule