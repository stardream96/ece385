module NZP ( 	input logic			 LD_CC, Clk, Reset
					input logic [15:0] Data_In,									
					output logic		 N, Z, P);
									

					always_ff @ (posedge Clk) 
					begin
						if (LD_CC)
						begin
							if (Data_In [15]) 
							begin
								N <= 1'b1;
								Z <= 1'b0;
								P <= 1'b0;
							end
								
							else if (Data_In == 16'b0) 
							begin
								N <= 1'b0;
								Z <= 1'b1;
								P <= 1'b0;
							end
								
							else 
							begin
								N <= 1'b0;
								Z <= 1'b0;
								P <= 1'b1;
							end
						end
						else 
						begin
                           N <= N;
                           P <= P;
                           Z <= Z;
                  end
						end
endmodule