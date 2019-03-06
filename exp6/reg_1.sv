module reg_1(input  logic Clk, LD, Reset,
              input  logic D,
              output logic Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (LD) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= D;
		 if(~Reset)
			  Data_Out <= 1'b0;

    end

endmodule

			