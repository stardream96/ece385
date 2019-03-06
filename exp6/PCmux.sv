module PCmux (input logic [15:0] IN_0, IN_1, IN_2, 
						input logic [1:0] PCMUX, 
						output logic [15:0] Data_Out);

	always_comb 
	begin
		case(PCMUX)
			2'b00: Data_Out = IN_0;
			2'b01: Data_Out = IN_1;
			2'b10: Data_Out = IN_2;		
		default:
			Data_Out = 16'b0;
		
		endcase	
	end
endmodule