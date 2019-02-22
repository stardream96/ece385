module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

	logic P0, P1, P2, P3, G0, G1, G2, G3, c0, c1, c2, c3;
	
	assign P0=A[3]|B[3];
	assign P1=A[7]|B[7];
	assign P2=A[11]|B[11];
	assign P3=A[15]|B[15];
	assign G0=A[3]&B[3];
	assign G1=A[7]&B[7];
	assign G2=A[11]&B[11];
	assign G3=A[15]&B[15];
	assign cin=0;
	cout_calc co0(.x(A[3:0]),   .y(B[3:0]),   .cin(cin), .cout(c0) );
	cout_calc co1(.x(A[7:4]),   .y(B[7:4]),   .cin(c0), .cout(c1) );
	cout_calc co2(.x(A[11:8]),  .y(B[11:8]),  .cin(c1), .cout(c2) );
	cout_calc co3(.x(A[15:12]), .y(B[15:12]), .cin(c2), .cout(CO) );
	four_bit_CLA CLA0(.x(A[3:0]), .y(B[3:0]), .cin(cin), .s(Sum[3:0]) );
	four_bit_CLA CLA1(.x(A[7:4]), .y(B[7:4]), .cin(c0), .s(Sum[7:4]) );
	four_bit_CLA CLA2(.x(A[11:8]), .y(B[11:8]), .cin(c1), .s(Sum[11:8]) );
	four_bit_CLA CLA3(.x(A[15:12]), .y(B[15:12]), .cin(c2), .s(Sum[15:12]) );
	
endmodule

module four_bit_CLA(
						input [3:0] x,
						input [3:0] y,
						input cin,
						output logic [3:0] s
						);

	logic P0, P1, P2, G0, G1, G2, c0, c1, c2, c3;
	
	assign P0=x[0]|y[0];
	assign P1=x[1]|y[1];
	assign P2=x[2]|y[2];
	assign G0=x[0]&y[0];
	assign G1=x[1]&y[1];
	assign G2=x[2]&y[2];
	assign c0=cin;
	assign c1=cin&P0^G0;
	assign c2=cin&P0&P1^G0&P1^G1;
	assign c3=cin&P0&P1&P2^G0&P1&P2^G1&P2^G2;
	nocout_adder fa0(.x(x[0]), .y(y[0]), .cin(c0), .s(s[0]));
	nocout_adder fa1(.x(x[1]), .y(y[1]), .cin(c1), .s(s[1]));
	nocout_adder fa2(.x(x[2]), .y(y[2]), .cin(c2), .s(s[2]));
	nocout_adder fa3(.x(x[3]), .y(y[3]), .cin(c3), .s(s[3]));
	
endmodule


module nocout_adder(
						input x,
						input y,
						input cin,
						output logic s
						);

	assign s = x^y^cin;

endmodule

module cout_calc(
					input [3:0] x,
					input [3:0] y,
					input cin,
					output logic cout
					);
		assign cout=cin&(x[0]|y[0])&(x[1]|y[1])&(x[2]|y[2])&(x[3]|y[3])|(x[0]&y[0])&(x[1]|y[1])&(x[2]|y[2])&(x[3]|y[3])|(x[1]&y[1])&(x[2]|y[2])&(x[3]|y[3])|(x[2]&y[2])&(x[3]|y[3])|(x[3]&y[3]);
endmodule
