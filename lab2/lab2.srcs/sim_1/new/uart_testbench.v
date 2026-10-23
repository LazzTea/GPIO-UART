module testbench();

reg clk;
reg rst;

reg tx;
reg rx;
reg send;

reg [7:0] data_in;
wire [7:0] data_out;


// module UART(
//     output wire TX,
//     input wire RX,
//     input wire rst,
//     input wire clk,
//     input wire send_data,
//     input wire [7:0] data_to_send,
//     output wire [7:0] data_received
// );

UART dut (
  tx,
  rx,
  rst,
  clk,
  send,
  data_in,
  data_out
);

task test_uart_trans(input [7:0] data);
begin
  @(negedge clk);
  data_in = data;
  $display("Current Input %b", data_out);
  @(negedge clk);
  send = 1;
  repeat(12) @(negedge clk);
  begin
    $display("Current TX: %b", tx);
  end
end

initial clk = 0;
initial rst = 0;

always #5 clk = ~clk;

initial begin
  test_uart_trans(8'b11111111);
end