module RegFile( input logic Clk, LD_REG, Reset,
					 input logic[2:0] DR, SR2, SR1,
					 input logic[15:0] Data_In,
					 output logic[15:0] SR1_Out, SR2_Out);
	
	logic R0LD, R1LD, R2LD, R3LD, R4LD, R5LD, R6LD, R7LD;
	logic [15:0] Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7;

	reg_16 R0(
				.*,
				.LD(R0LD),
				.D(Data_In),
				.Data_Out(Reg0)
	);
	
	reg_16 R1(
				.*,
				.LD(R1LD),
				.D(Data_In),
				.Data_Out(Reg1)
	);
	
	reg_16 R2(
				.*,
				.LD(R2LD),
				.D(Data_In),
				.Data_Out(Reg2)
	);
	
	reg_16 R3(
				.*,
				.LD(R3LD),
				.D(Data_In),
				.Data_Out(Reg3)
	);
	
	reg_16 R4(
				.*,
				.LD(R4LD),
				.D(Data_In),
				.Data_Out(Reg4)
	);
	
	reg_16 R5(
				.*,
				.LD(R5LD),
				.D(Data_In),
				.Data_Out(Reg5)
	);
	
	reg_16 R6(
				.*,
				.LD(R6LD),
				.D(Data_In),
				.Data_Out(Reg6)
	);
	
	reg_16 R7(
				.*,
				.LD(R7LD),
				.D(Data_In),
				.Data_Out(Reg7)
	);

	
	always_comb
	begin
	if (Reset)
	begin 
		
		case (SR1)
			3'b000 : SR1_Out = Reg0;
			3'b001 : SR1_Out = Reg1;
			3'b010 : SR1_Out = Reg2;
			3'b011 : SR1_Out = Reg3;
			3'b100 : SR1_Out = Reg4;
			3'b101 : SR1_Out = Reg5;
			3'b110 : SR1_Out = Reg6;
			3'b111 : SR1_Out = Reg7;
		endcase
			
		case (SR2)
			3'b000 : SR2_Out = Reg0;
			3'b001 : SR2_Out = Reg1;
			3'b010 : SR2_Out = Reg2;
			3'b011 : SR2_Out = Reg3;
			3'b100 : SR2_Out = Reg4;
			3'b101 : SR2_Out = Reg5;
			3'b110 : SR2_Out = Reg6;
			3'b111 : SR2_Out = Reg7;
		endcase
			

	end
	else
			begin
			  SR1_Out <= 16'b0000000000000000;
			  SR2_Out <= 16'b0000000000000000;
			end
		
	end
	
	always_ff @ (posedge Clk)
    begin
	 	 if (LD_REG) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
					R0LD = 0;
					R1LD = 0;
					R2LD = 0;
					R3LD = 0;
					R4LD = 0;
					R5LD = 0;
					R6LD = 0;
					R7LD = 0;
			case(DR)
					3'b000: R0LD <= 1;
					3'b001: R1LD <= 1;
					3'b010: R2LD <= 1;
					3'b011: R3LD <= 1;
					3'b100: R4LD <= 1;
					3'b101: R5LD <= 1;
					3'b110: R6LD <= 1;
					3'b111: R7LD <= 1;
				endcase
		
    end

endmodule
