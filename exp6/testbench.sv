module testbench();

timeunit 10ns;

timeprecision 1ns;

logic[15:0]     S;        // From slider switches

logic           Clk;      // 50MHz clock is only used to get timing estimate data
logic           Reset;      // From push-button 0
logic           Run;        // From push-button 1.
logic			    Continue;          //From push-button 2 Remember the button is active low (0 when pressed)
wire [15:0] 	 Data;

// all outputs are registered
logic[11:0] 	 LED;         // Carry-out.  Goes to the green LED to the left of the hex displays.
logic[6:0] 		 HEX0;      // Hex drivers display both inputs to the adder.
logic[6:0] 		 HEX1;
logic[6:0]      HEX2;
logic[6:0]      HEX3;
logic[6:0]      HEX4;
logic[6:0]      HEX5;
logic[6:0]      HEX6;
logic[6:0]      HEX7;
logic CE, UB, LB, OE, WE;
logic[19:0]     ADDR;



always begin : CLOCK_GENERATION

#1 Clk = ~Clk;

end

initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end


lab6_toplevel tp(.*);

initial begin: TEST_VECTORS

S = 16'h0000;
Reset = 0;
Run   = 1;
Continue = 1;
//Data = 16'h0000;


//test case1
#2 Reset = 1;

//#2 Data = 16'hACAC;\

#2 S = 16'h0014;

#2 Run = 0;
#2 Run = 1;
#20 

#22;

end

endmodule