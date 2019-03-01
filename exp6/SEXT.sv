module SEXT(
	input logic[10:0] In,
	output logic [15:0] SEXT11,
	output logic [15:0] SEXT9,
	output logic [15:0] SEXT6
);

	always_comb
	begin
		SEXT11[10:0] = In[10:0];
		SEXT9[8:0] = In[8:0];
		SEXT6[5:0] = In[5:0];
		if (In[10])
			SEXT11[15:11] = 5'b11111;
		else
			SEXT11[15:11] = 5'b00000;
		if (In[8])
			SEXT9[15:9] = 7'b1111111;
		else
			SEXT9[15:9] = 7'b0000000;
		if (In[5])
			SEXT6[15:6] = 10'b1111111111;
		else
			SEXT6[15:6] = 10'b0000000000;
	end

	
endmodule
