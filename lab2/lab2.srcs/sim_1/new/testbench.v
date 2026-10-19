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

reg [7:0] data_in;
wire [7:0] data_out;

wire tx_line = 1;

integer errors = 0;

tx trans(
  clk,
  rst,
  data_in,
  tx_line
);

rx recv (
  clk,
  rst,
  tx_line,
  data_out
);


task test_transmission(input [7:0] data, input dbt);
begin
  @(negedge clk);
  data_in = data;
  rst = 1;
  @(negedge clk);
  rst = 0;
  if (dbt) begin
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
  end
end
endtask

task send_data_test(input [7:0] data, input dbt);
begin
  @(negedge clk);
  data_in = data;
  // Print each data point
  if (dbt) begin
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
    @(negedge clk);
    $display("Data Bit Transfer %b", tx_line);
  end
  @(negedge clk);
  if (data_out == data) begin
    $display("PASS: sent %b, got %b at %0t", data, data_out, $time);
  end else begin
    $display("FAILED: sent %b, got %b at %0t", data, data_out, $time);
    errors = errors + 1;
  end
end
endtask

initial clk = 0;
initial rst = 0;

always #5 clk = ~clk;

initial begin
  test_transmission(8'b11111111, 1);
  test_transmission(8'b00000000, 1);
  test_transmission(8'b10101010, 1);

  if (errors == 0) $display("ALL TESTS PASSED");
  else             $display("%0d ERRORS", errors);
  $finish;
end


endmodule


