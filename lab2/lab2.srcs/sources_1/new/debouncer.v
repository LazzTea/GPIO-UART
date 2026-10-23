`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 11:31:46 AM
// Design Name: 
// Module Name: debouncer
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


module debouncer #(
    parameter CLK_FREQ_HZ = 100_000_000, // Default 100 MHz clock
    parameter BOUNCE_MS   = 10          // Time window to wait for bounce to settle
)(
    input  wire clk,         // System clock
    input  wire rst,         // Active-high asynchronous reset
    input  wire noisy_in,    // Raw input from physical button/switch
    output reg  clean_out    // Debounced, stable output
);

    // Calculate the number of clock cycles needed for the bounce duration
    localparam integer FIND_CYCLES = (CLK_FREQ_HZ / 1000) * BOUNCE_MS;
    localparam integer COUNTER_MAX = FIND_CYCLES > 0 ? FIND_CYCLES - 1 : 0;
    localparam WIDTH       = $clog2(COUNTER_MAX + 1);

    // Internal registers for synchronization and counting
    reg [1:0] sync_reg;
    reg [WIDTH-1:0] count;
    
    // Step 1: Two-stage synchronizer to prevent metastability
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_reg <= 2'b00;
        end else begin
            sync_reg <= {sync_reg[0], noisy_in};
        end
    end

    wire stable_in = sync_reg[1]; // Synchronized input

    // Step 2: Debounce counter logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count     <= 0;
            clean_out <= 1'b0;
        end else begin
            // If the synchronized input differs from the current debounced output
            if (stable_in != clean_out) begin
                if (count == COUNTER_MAX) begin
                    count     <= 0;
                    clean_out <= stable_in; // Update output after stability window
                end else begin
                    count     <= count + 1;
                end
            end else begin
                count <= 0; // Reset counter if input matches output (or bounces back)
            end
        end
    end

endmodule
