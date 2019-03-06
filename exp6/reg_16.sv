module reg_16 (
					input  logic Clk, LD, Reset,
					input  logic [15:0]  D,
					output logic [15:0]  Data_Out
);

    always_ff @ (posedge Clk)
    begin
	 	 if (LD) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= D;
		 if(~Reset)
			  Data_Out <= 16'b0000000000000000;

    end

endmodule
