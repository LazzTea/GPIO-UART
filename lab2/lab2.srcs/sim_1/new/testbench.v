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

wire tx_line;

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


task send_data_test(input [7:0] data);
begin
  @(negedge clk);
  data_in = data;
  rst = 1;
  @(negedge clk);
  rst = 0;
  repeat(12) @(negedge clk);
  if (data_out == data_in) begin
    $display("PASS: sent %b, got %b at %0t", data_in, data_out, $time);
  end else begin
    $display("FAILED: sent %b, got %b at %0t", data_in, data_out, $time);
    errors = errors + 1;
  end
end
endtask


task interuption_test(input [7:0] data, input interuptTime);
begin
  // Load Initial Data and Reset to being
  @(negedge clk);
  data_in = data;
  rst = 1;
  @(negedge clk);
  rst = 0;

  // Interupt Part way through
  repeat(interuptTime) @(negedge clk);
  rst = 1;
  @(negedge clk);

  // Allows test to run to finish after interuptions
  rst = 0;
  repeat(12) @(negedge clk);

  // Check Final output
  if (data_out == data_in) begin
    $display("PASS: sent %b, got %b at %0t", data_in, data_out, $time);
  end else begin
    $display("FAILED: sent %b, got %b at %0t", data_in, data_out, $time);
    errors = errors + 1;
  end
end
endtask


initial clk = 0;
initial rst = 0;

always #5 clk = ~clk;
always @(posedge clk) $display("%0t: Transfer Signal %b", $time, tx_line);

initial begin
  // Test Max & Min
  send_data_test(8'b00000000);
  send_data_test(8'b11111111);

  // Test Different start/end bits between
  send_data_test(8'b10000001);
  send_data_test(8'b01111110);

  // Test back and forth between 1 and 0
  send_data_test(8'b10101010);
  send_data_test(8'b01010101);


  /// Interuption Testing
  // Test Max & Min
  interuption_test(8'b00000000, 0);
  interuption_test(8'b11111111, 2);

  // Test Different start/end bits between
  interuption_test(8'b10000001, 4);
  interuption_test(8'b01111110, 6);

  // Test back and forth between 1 and 0
  interuption_test(8'b10101010, 8);
  interuption_test(8'b01010101, 10);
  interuption_test(8'b01010101, 12);

  if (errors == 0) $display("ALL TESTS PASSED");
  else             $display("%0d ERRORS", errors);
  $finish;
end


endmodule


