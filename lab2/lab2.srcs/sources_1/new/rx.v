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

reg [3:0] bit_count = 4'b0;
reg state = 1'b0; // 0 is Idle, 1 is Data

reg [7:0] loaded_data;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= 1'b0;
    bit_count <= 4'b0;
    data <= 8'b0;
    loaded_data <= 8'b0;

  end else begin
    if (!state) begin
      if (!rx_line) begin
        state <= 1'b1;
        bit_count <= 4'b0;
        loaded_data <= 8'b0;
      end

    end else if (bit_count < 4'd7) begin
      loaded_data <= {rx_line, loaded_data[7:1]};
      bit_count <= bit_count + 1;

    end else begin
      if (rx_line) begin // make sure rx_line last bit is 1
        data <= loaded_data;
      end
      state <= 1'b0;
      end
  end
end

endmodule
