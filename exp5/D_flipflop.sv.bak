module D_flipflop (input  logic Clk, Load, Reset, D,
						 output logic Q);							
		
		always_ff @ (posedge Clk or posedge Reset) begin	
				if (Reset)				// on reset, default to 0
					Q <= 1'b0;
				else	
					if (Load)			// on load, output equals input
						Q <= D;
					else	
						Q <= Q;			// else maintain value
		end
		
endmodule
