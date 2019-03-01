module testbench();

timeunit 10ns;

timeprecision 1ns;

logic           Clk;        // 50MHz clock is only used to get timing estimate data
logic           Reset;      // From push-button 0.  Remember the button is active low (0 when pressed)
logic           LoadB_ClearA;      // From push-button 1
logic           Run;        // From push-button 3.
logic[7:0]      S;         // From slider switches

logic           X;          // Carry-out.  Goes to the green LED to the left of the hex displays.
logic[7:0]      Aval;
logic[7:0]		 Bval;		 // Goes to the red LEDs.  You need to press "Run" before the sum shows up here.
logic[6:0]      AhexU;      // Hex drivers display both inputs to the adder.
logic[6:0]      AhexL;
logic[6:0]      BhexU;
logic[6:0]      BhexL;

always begin : CLOCK_GENERATION

#1 Clk = ~Clk;

end

initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end


lab5_multiplier_toplevel tp(.*);

initial begin: TEST_VECTORS

Reset = 0;
LoadB_ClearA = 1;
Run   = 1;


//test case1
#2 Reset = 1;

#2 LoadB_ClearA = 0;
	S = 8'h07;
	
#4 LoadB_ClearA = 1;
	S = 8'hC5;

#6 Run = 0;

#8 Run = 1;
#26;

end

endmodule
