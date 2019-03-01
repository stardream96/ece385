module mux_4(input logic [15:0] IN_00,IN_01,IN_10,IN_11,
					input logic [1:0] SELECT,
					output logic [15:0] Out);
				
				always_comb
				begin
					case(SELECT)
						2'b00:
							Out = IN_00; 
						2'b01:
							Out = IN_01; 
						2'b10:
							Out = IN_10; 
						2'b11:
							Out = IN_11; 
					endcase
				end
				
endmodule
