// tb.v - Testbench for tt_um_random_pulse_generator
`timescale 1ns / 1ps

module tb;

    // Signals
    reg clk;
    reg rst_n;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [7:0] uio_in;

    // Instantiate the DUT
    tt_um_random_pulse_generator uut (
        .clk(clk),
        .rst_n(rst_n),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uio_in(uio_in)
    );

    // Generate clock signal with 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Apply reset and stimulus
    initial begin
        rst_n = 0;
        uio_in = 8'b0;
        #10 rst_n = 1;   // Release reset after 10ns
        #2000 $finish;   // End simulation after 2000ns
    end

    // Monitor pulse output
    initial begin
        $monitor("Time = %0t, Pulse = %b", $time, uio_out[0]);
    end

endmodule
