//module multiplier_processor(
//						input [7:0] A,
//						input [7:0] B,
//						input X,
//						output logic [7:0] AO,
//						output logic [7:0] BO,
//						output logic XO
//						);
//
//	assign X = B[0];
//	assign A = {X,A[7:1]};
//	assign B = {A[0],B[7:1],};
//
//endmodule
//
//module XAB_shifter(
//						input [7:0] A,
//						input [7:0] B,
//						input X,
//						output logic [7:0] AO,
//						output logic [7:0] BO,
//						output logic XO
//						);
//
//	assign X = B[0];
//	assign A = {X,A[7:1]};
//	assign B = {A[0],B[7:1],};
//
//endmodule


module eight_bit_ra_sub(
						input [7:0] A,
						input [7:0] B,
						input Sub,
						output logic [8:0] s
						);

	logic c0, c1;
	logic [7:0] BB;
	logic cin;
	
	assign cin = Sub;
	assign BB = B ^ {8{Sub}};
	// if subtraction, use 2s complement val
	four_bit_ra FRA0(.x(A[3:0]), .y(BB[3:0]), .cin(cin), .s(s[3:0]), .cout(c0));
	four_bit_ra FRA1(.x(A[7:4]), .y(BB[7:4]), .cin(c0), .s(s[7:4]), .cout(c1));
	assign s[8] = s[7]; //Using sign heriarchy
	
endmodule

module four_bit_ra(
						input [3:0] x,
						input [3:0] y,
						input cin,
						output logic [3:0] s,
						output logic cout
						);

	logic c0, c1, c2;
	
	full_adder fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .cout(c0));
	full_adder fa1(.x(x[1]), .y(y[1]), .cin(c0), .s(s[1]), .cout(c1));
	full_adder fa2(.x(x[2]), .y(y[2]), .cin(c1), .s(s[2]), .cout(c2));
	full_adder fa3(.x(x[3]), .y(y[3]), .cin(c2), .s(s[3]), .cout(cout));

endmodule


module full_adder(
						input x,
						input y,
						input cin,
						output logic s,
						output logic cout
						);

	assign s = x^y^cin;
	assign cout = (x&y) | (y&cin) | (cin&x);
	


endmodule
