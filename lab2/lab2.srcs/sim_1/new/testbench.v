`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 11:34:07 AM
// Design Name: 
// Module Name: testbench
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


module testbench();

reg clk;
reg rst;

reg [7:0] input;
reg [7:0] output;

reg data;

tx trans(
  clk,
  rst,
  input,
  data
);

rx recv (
  clk,
  rst,
  data,
  output
);

initial clk = 0;
initial rst = 0;

always #5000 clk = ~clk;

initial begin
  input = 8'b00110011;
  #100
  
end




endmodule
