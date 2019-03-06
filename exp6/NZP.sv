module NZP ( 	input logic			 LD_CC, Clk,
					input logic [15:0] Bus_Data, IR,								
					output logic Data_Out);
					
					logic N,Z,P;
									

					always_ff @ (posedge Clk) 
					begin
						if (LD_CC)
						begin
							if (Bus_Data[15]) 
							begin
								N <= 1'b1;
								Z <= 1'b0;
								P <= 1'b0;
							end
								
							else if (Bus_Data == 16'b0) 
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
					
					always_comb
						begin
							Data_Out = IR[11] && N + IR[10] && Z + IR[9] & P;
						end
endmodule
