`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 10:30:53 AM
// Design Name: 
// Module Name: tx
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


module tx(
input wire clk,
input wire rst,
input wire [7:0] data,

output wire tx_line
);

reg [3:0] bit_count;
reg state = 1'b0; // 0 is Idle, 1 is Data

reg [7:0] loaded_data;
reg loaded_tx_line = 1'b1;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= 1'b0;
    bit_count <= 4'b0;
    loaded_tx_line <= 1;
    loaded_data <= data;

  end else if (!state && bit_count == 4'b0) begin
    loaded_tx_line <= 1'b0;
    bit_count <= 4'b1;
    state <= 1'b1;
    loaded_data <= data;

  end else if (bit_count < 4'd8) begin
    loaded_tx_line <= data[0];
    loaded_data <= loaded_data >> 1;
    bit_count <= bit_count + 1;

  end else begin
    loaded_tx_line <= 1'b1;
    state <= 1'b0;
  end
end

assign tx_line = loaded_tx_line;

endmodule
