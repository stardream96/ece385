module ALU(input logic [15:0] A, B,
				input logic [1:0] Sel,
				output logic [15:0] Out);
				
				always_comb
				begin
					case(Sel)
						2'b00:
							Out = A + B; //ADD
						2'b01:
							Out = A & B; //AND
						2'b10:
							Out = ~A; //NOT A
						2'b11:
							Out = A; //A
					endcase
				end
				
endmodule
