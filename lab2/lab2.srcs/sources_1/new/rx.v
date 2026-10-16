`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 10:30:53 AM
// Design Name: 
// Module Name: rx
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


module rx(
input wire clk,
input wire rst,
input wire rx_line,
output reg [7:0] data
);

reg [3:0] current_bit = 4'b0;
reg state = 1'b0; // 0 is Idle, 1 is Data

always @(posedge clk or posedge rst) begin
  // Start Bit
  if (current_bit == 0 && rx_line == 0) begin
    data <= 8'b0;
    state <= 1'b1;

  // Stop Bit
  end else if (current_bit >= 4'd10 && rx_line == 1) begin
    current_bit = 4'b0;
    state <= 1'b0;
  
  // Store Data
  end else if () begin
    data[current_bit-1] = rx_line;
  end
end

endmodule
