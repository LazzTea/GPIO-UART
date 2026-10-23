`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 11:34:20 AM
// Design Name: 
// Module Name: UART
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


module UART(
    output wire TX,
    input wire RX,
    input wire rst,
    input wire clk,
    input wire send_data,
    input wire [7:0] data_to_send,
    output wire [7:0] data_received
);

wire send_data_clean;


reg [13:0] ticker = 14'd0;
//Divider = 100000000 / 9600 = 10,416.6667
parameter DIVISOR = 10_417;

reg baud_tick = 1'b0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ticker <= 14'd0;
        baud_tick <= 1'b0;
    end else if (ticker == DIVISOR - 1) begin
        ticker <= 14'd0;
        baud_tick <= 1'b1;
    end else begin
        ticker <= ticker + 1;
        baud_tick <= 1'b0;
    end
end


debouncer send_data_debouncer(
    .clk(clk),
    .rst(rst),
    .noisy_in(send_data),
    .clean_out(send_data_clean)
);




tx transmitter(
    .clk(baud_tick),
    .rst(rst),
    .data(data_to_send),
    .send_data(send_data_clean),
    .tx_line(TX)
);

rx receiver(
    .clk(baud_tick),
    .rst(rst),
    .rx_line(TX),
    .data(data_received)
);




endmodule
