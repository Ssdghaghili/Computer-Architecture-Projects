`timescale 1ns/1ns
module comprator(input [15:0] A,B, output C);
	assign C = (A > B) ? 1'b1:
		   (A < B) ? 1'b0:
		   (A == B) ? 1'b0: 3'bx;
endmodule
