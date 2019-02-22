module lab5_multiplier_toplevel
(
    input   logic           Clk,        	// 50MHz clock is only used to get timing estimate data
    input   logic           Reset,      	// From push-button 0.  Remember the button is active low (0 when pressed)
    input   logic           LoadB_ClearA,	// From push-button 1
    input   logic           Run,       	// From push-button 3.
    input   logic[7:0]      S,         	// From slider switches
    
    // all outputs are registered
    output  logic           X,          // Carry-out.  Goes to the green LED to the left of the hex displays.
	 // Goes to the red LEDs.  You need to press "Run" before the sum shows up here.
    output  logic[6:0]      AhexU,      // Hex drivers display both inputs to the adder.
    output  logic[6:0]      AhexL,
    output  logic[6:0]      BhexU,
    output  logic[6:0]      BhexL,   
	 output	logic[7:0]    	 Aval,
	 output	logic[7:0]		 Bval
);

    /* Declare Internal Registers */
    logic[7:0]     A;  // use this as an input to your adder
    logic[7:0]     B;  // use this as an input to your adder
	
    /* Declare Internal Wires
     * Wheather an internal logic signal becomes a register or wire depends
     * on if it is written inside an always_ff or always_comb block respectivly */
    logic[7:0]      Aval_comb;
	 logic[7:0]      Bval_comb;
    logic           X_comb;	
    logic[6:0]      AhexU_comb;
    logic[6:0]      AhexL_comb;
    logic[6:0]      BhexU_comb;
    logic[6:0]      BhexL_comb;
	 logic			  enable_comb;
	 logic			  Reset_out;
	 logic M;
	 logic Shift_En, Clr_Ld, Add, Sub;
	 logic A_out;
	 logic [8:0] A9;
    /* Decoders for HEX drivers and output registers
     * Note that the hex drivers are calculated one cycle after Sum so
     * that they have minimal interfere with timing (fmax) analysis.
     * The human eye can't see this one-cycle latency so it's OK. */
    always_ff @(posedge Clk) begin
        
        AhexU <= AhexU_comb;
        AhexL <= AhexL_comb;
        BhexU <= BhexU_comb;
        BhexL <= BhexL_comb;
    end
    
    /* Module instantiation
	  * You can think of the lines below as instantiating objects (analogy to C++).
     * The things with names like Ahex0_inst, Ahex1_inst... are like a objects
     * The thing called HexDriver is like a class
     * Each time you instantate an "object", you consume physical hardware on the FPGA
     * in the same way that you'd place a 74-series hex driver chip on your protoboard 
     * Make sure only *one* adder module (out of the three types) is instantiated*/

  eight_bit_ra_sub adder
  (.*,
		.A(A),
		.B(S),
		.Sub(Sub),
		.s(A9)
  );

  control control_unit
  (.*,
		.Reset(~Reset),
		.LoadB_ClearA,
		.Run(Run),
		.M (M),
		.Shift_En,
		.Clr_Ld,
		.Add(Add),
		.Sub(Sub),
		.Clr_cont(Clr_cont),
		.Reset_out(Reset_out)
	);


    D_flipflop Reg_X
  (.*,
		.Clk(Clk),
		.Load(M),
		.Reset(Reset_out|Clr_Ld|Clr_cont),
		.D(A9[8]),
		.Q(X)
  );
  
  reg_8 Reg_A
  (.*,
      .Clk(Clk), 
		.Reset(Reset_out|Clr_Ld|Clr_cont), 
		.Shift_In(X), 
		.Load(Add|Sub),
		.Shift_En(Shift_En),
		.D (A9[7:0]),
		.Shift_Out(A_out),
		.Data_Out(A)
  );
  
    reg_8 Reg_B
  (.*,
      .Clk(Clk), 
		.Reset(Reset_out), 
		.Shift_In(A_out), 
		.Load(Clr_Ld),
		.Shift_En(Shift_En),
		.D (S),
		.Shift_Out(M),
		.Data_Out(B)
  );

    
    HexDriver AhexL_inst
    (
        .In0(Aval[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(AhexL_comb)
    );
    
    HexDriver AhexU_inst
    (
        .In0(Aval[7:4]),
        .Out0(AhexU_comb)
    );
    
    
    HexDriver BhexL_inst
    (
        .In0(Bval[3:0]),
        .Out0(BhexL_comb)
    );
    
    HexDriver BhexU_inst
    (
        .In0(Bval[7:4]),
        .Out0(BhexU_comb)
    );
	 assign Aval = A;
	 assign Bval = B;
    
    
endmodule
