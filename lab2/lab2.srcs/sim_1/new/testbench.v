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
reg [7:0] data_out;

integer errors = 0;

tx trans(
  clk,
  rst,
  input,
  data_in
);

rx recv (
  clk,
  rst,
  data,
  data_out
);

task send_data_test(input [7:0] data);
begin
  @(negedge clk);
  data_in = data;
  #20000
  @(negedge clk);
  if (data_out == data) begin
    $display("PASS: sent %h, got %h at %0t", data, data_out, $time);
  end else begin
    $display("FAILED: sent %h, got %h at %0t", data, data_out, $time);
    errors = errors + 1;
  end
end
endtask

initial clk = 0;
initial rst = 0;

always #5 clk = ~clk;

initial begin
  send_data_test(8'b11111111);
  send_data_test(8'b00000000);
  send_data_test(8'b10101010);

  if (errors == 0) $display("ALL TESTS PASSED");
  else             $display("%0d ERRORS", errors);
  $finish;
end


endmodule


