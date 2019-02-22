module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
		logic c0a, c1a, c2a, c3a, c0b, c1b, c2b, c3b, c0, c1, c2, c3;
		logic [15:0]	sa; 
		logic [15:0]	sb;
		logic siga	= 0;
		logic sigb	= 1;
	fourbit_select_adder fsa0a(.x(A[3:0]),   .y(B[3:0]),   .cin(siga), .s(sa[3:0]),   .cout(c0a));
	fourbit_select_adder fsa1a(.x(A[7:4]),   .y(B[7:4]),   .cin(siga), .s(sa[7:4]),   .cout(c1a));
	fourbit_select_adder fsa2a(.x(A[11:8]),  .y(B[11:8]),  .cin(siga), .s(sa[11:8]),  .cout(c2a));
	fourbit_select_adder fsa3a(.x(A[15:12]), .y(B[15:12]), .cin(siga), .s(sa[15:12]), .cout(c3a));
	
	fourbit_select_adder fsa0b(.x(A[3:0]),   .y(B[3:0]),   .cin(sigb), .s(sb[3:0]),   .cout(c0b));
	fourbit_select_adder fsa1b(.x(A[7:4]),   .y(B[7:4]),   .cin(sigb), .s(sb[7:4]),   .cout(c1b));
	fourbit_select_adder fsa2b(.x(A[11:8]),  .y(B[11:8]),  .cin(sigb), .s(sb[11:8]),  .cout(c2b));
	fourbit_select_adder fsa3b(.x(A[15:12]), .y(B[15:12]), .cin(sigb), .s(sb[15:12]), .cout(c3b));
	
	assign cin=siga;
	assign c0=(~cin&c0a)|(cin&c0b);
	assign c1=(~c0&c1a)|(c0&c1b);
	assign c2=(~c1&c2a)|(c1&c2b);
	
	fourbit_mux out0(.x(sa[3:0]),   .y(sb[3:0]),   .select(cin),.out(Sum[3:0]));
	fourbit_mux out1(.x(sa[7:4]),   .y(sb[7:4]),   .select(c0), .out(Sum[7:4]));
	fourbit_mux out2(.x(sa[11:8]),  .y(sb[11:8]),  .select(c1), .out(Sum[11:8]));
	fourbit_mux out3(.x(sa[15:12]), .y(sb[15:12]), .select(c2), .out(Sum[15:12]));
	assign CO = (~c2&c3a)|(c2&c3b);
		
endmodule



module fourbit_select_adder(
									input [3:0] x,
									input [3:0] y,
									input cin,
									output logic [3:0] s,
									output logic cout
									);
	logic c0a, c1a, c2a, c3a, c0b, c1b, c2b, c3b, sa[3:0], sb[3:0], c0, c1, c2, c3;
	logic siga	= 0;
	logic sigb	= 1;
	
	select_adder sa0a(.x(x[0]), .y(y[0]), .cin(siga), .s(sa[0]), .cout(c0a));
	select_adder sa1a(.x(x[1]), .y(y[1]), .cin(siga), .s(sa[1]), .cout(c1a));
	select_adder sa2a(.x(x[2]), .y(y[2]), .cin(siga), .s(sa[2]), .cout(c2a));
	select_adder sa3a(.x(x[3]), .y(y[3]), .cin(siga), .s(sa[3]), .cout(c3a));
	select_adder sa0b(.x(x[0]), .y(y[0]), .cin(sigb), .s(sb[0]), .cout(c0b));
	select_adder sa1b(.x(x[1]), .y(y[1]), .cin(sigb), .s(sb[1]), .cout(c1b));
	select_adder sa2b(.x(x[2]), .y(y[2]), .cin(sigb), .s(sb[2]), .cout(c2b));
	select_adder sa3b(.x(x[3]), .y(y[3]), .cin(sigb), .s(sb[3]), .cout(c3b));

	assign c0=(~cin&c0a)|(cin&c0b);
	assign c1=(~c0&c1a)|(c0&c1b);
	assign c2=(~c1&c2a)|(c1&c2b);

		assign s[0]=(~cin&sa[0])|(cin&sb[0]);
		assign s[1]=(~c0&sa[1])|(c0&sb[1]);
		assign s[2]=(~c1&sa[2])|(c1&sb[2]);
		assign s[3]=(~c2&sa[3])|(c2&sb[3]);
		assign cout=(~c2&c3a)|(c2&c3b);


	//	assign s[0]=s0b;
	//	assign s[1]=s1b;
	//	assign s[2]=s2b;
	//	assign s[3]=s3b;
	//	assign cout[0]=c0b;
	//	assign cout[1]=c1b;
	//	assign cout[2]=c2b;
	//	assign cout[3]=c3b;
	
endmodule
	
module select_adder(
						input x,
						input y,
						input cin,
						output logic s,
						output logic cout
						);
	logic s0, s1, cout0, cout1;
	logic sigb	= 1;
	assign s0 = x^y;
	assign s1 = x^y^sigb;
	assign cout0 = (x&y); 
	assign cout1 = y | x;

	assign s=(~cin&s0)|(cin&s1);
	assign cout=(~cin&cout0)|(cin&cout1);

	
endmodule

module fourbit_mux(
						input [3:0]x,
						input [3:0]y,
						input select,
						output logic [3:0]out
						);
	
	assign out[0]=(x[0]&~select)|(y[0]&select);
	assign out[1]=(x[1]&~select)|(y[1]&select);
	assign out[2]=(x[2]&~select)|(y[2]&select);
	assign out[3]=(x[3]&~select)|(y[3]&select);
	
	endmodule
	