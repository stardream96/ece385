module reg32(
				input logic CLK, LD, RESET,
				input logic [31:0] Data,
				input logic [3:0] BE,
				output logic [31:0] Output,
			);
		logic [31:0] DC; // Data Chosen
		
		always_comb
			case (BE)
				4'b1111:
					DC = Data;
				4'b1100:
					DC = {Data[31:16],16'b0};
				4'b0011:
					DC = {16'b0,Data[15:0]};
				4'b1000:
					DC = {Data[31:24],24'b0};
				4'b0100:
					DC = {8'b0,Data[23:16],16'b0};
				4'b0010:
					DC = {16'b0,Data[15:8],8'b0};
				4'b0001:
					DC = {24'b0,Data[7:0]};
		
		always_ff @ (posedge CLK)
		begin				
				if(LD)
					Output <= DC;
				if(~RESET)
					Output <= 32'b0;
		end
endmodule