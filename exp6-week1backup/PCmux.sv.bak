module reg_16 (input  logic Clk, LD,
              input  logic [15:0]  D,
              output logic [15:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (LD) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= D;
    end

endmodule
