`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 08:14:50 PM
// Design Name: 
// Module Name: sprite_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sprite_memory(Reset, R, G, B, A, clk, pclk, xcoord, ycoord, shape);
	input [3:0] xcoord, ycoord;
	input [1:0] shape;
	input clk, pclk, Reset;
	output R, G, B, A;

	reg R, G, B, A;
	reg [63:0] shaperow;
	reg [63:0] shape1mem[15:0]; // Sprite Shape 1 (Mole)

	always @(posedge clk) begin
		if (Reset) begin
			shape1mem[0] = 64'b000000000000000000011111111111111111110000000000000000000000000;
			shape1mem[1] = 64'b0000000000000000001100000000000000000011000000000000000000000000;			
			shape1mem[2] = 64'b0000000000000000011000000000000000000001100000000000000000000000;
			shape1mem[3] = 64'b0000000000000000110000000000000000000000110000000000000000000000;
			shape1mem[4] = 64'b0000000000000001100000000000000000000000011000000000000000000000;
			shape1mem[5] = 64'b0000000000000011000000110000000000110000001100000000000000000000;
			shape1mem[6] = 64'b0000000000000011000000110000000000110000001100000000000000000000;
			shape1mem[7] = 64'b0000000000000011000000110000000000110000001100000000000000000000;
			shape1mem[8] = 64'b0000000000000011000000000011111100000000001100000000000000000000;
			shape1mem[9] = 64'b0000000000000011000000001100000011000000001100000000000000000000;
			shape1mem[10] = 64'b0000000000000011000000001100000011000000001100000000000000000000;
			shape1mem[11] = 64'b0000000000000011000000000011111100000000001100000000000000000000;
			shape1mem[12] = 64'b0000000000000011000000000000000000000000001100000000000000000000;
			shape1mem[13] = 64'b0000000000000011000000000000000000000000001100000000000000000000;
			shape1mem[14] = 64'b0000000000000011000000000000000000000000001100000000000000000000;
			shape1mem[15] = 64'b0000000000000011000000000000000000000000001100000000000000000000;
		end
	end

	// Assign signals to proper outputs
	always @(posedge pclk) begin
		if (shape == 0)
			shaperow = shape1mem[ycoord];
		R = shaperow[(xcoord*4)+3];
		G = shaperow[(xcoord*4)+2];
		B = shaperow[(xcoord*4)+1];
		A = shaperow[xcoord*4];
	end
	
endmodule
