`timescale 1ns / 1ps

// tb.v - Testbench for tt_um (Random Pulse Generator)
module tb;

    // Testbench signals
    reg clk;                // Clock input
    reg rst_n;              // Active low reset
    wire [7:0] uo_out;     // Output (not used in this test, set to 0)
    wire [7:0] uio_out;    // Output for pulse signal (1 bit used for the pulse)
    wire [7:0] uio_oe;     // Output enable signal (for uio_out)
    reg [7:0] uio_in;      // Input (unused in this design, can be set to 0)

    // Instantiate the tt_um_random_pulse_generator module
    tt_um_random_pulse_generator uut (
        .clk(clk),
        .rst_n(rst_n),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uio_in(uio_in)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Generate a clock with a period of 10 time units
    end

    // Initial block to apply stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        uio_in = 8'b0;

        // Apply reset
        #10 rst_n = 1;    // Release reset after 10 time units

        // Test case: Wait and observe pulses
        #100;              // Observe pulses for 100 time units

        // End the simulation after 200 time units
        #200 $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time = %0t, Pulse = %b", $time, uio_out[0]);
    end

endmodule
