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

reg [3:0] current_bit;
reg state = 1'b0; // 0 is Idle, 1 is Data

reg [7:0] loaded_data;
reg loaded_tx_line;

always @(posedge clk or posedge rst) begin
  // Start Bit
  if (current_bit == 4'b0 && state == 1'b0) begin
    loaded_data <= data;
    state <= 1'b1;
    current_bit = current_bit + 1;
    
  // Stop Bit
  end else if (current_bit == 4'd10) begin
    // current_bit <= 4'b0; Assuming that once it sends its bits, transmitting is done.  Leaving value prevents sending the same data
    state <= 1'b0;
    loaded_tx_line <= 1'b1;

  // Send Bit
  end else if (state == 1'b1) begin
    loaded_tx_line <= loaded_data[0];
    loaded_data <= loaded_data >> 1;
    current_bit = current_bit + 1;
  end
end

assign tx_line = loaded_tx_line;

endmodule
