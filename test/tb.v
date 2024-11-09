`timescale 1ns / 1ps

// tb.v - Testbench for tt_um (Random Pulse Generator)
module tb;

    // Testbench signals
    reg clk;                // Clock input
    reg rst_n;              // Active low reset
    reg ena,
    wire [7:0] uo_out;      // Output (unused in this test)
    wire [7:0] uio_out;     // Output for pulse signal (uio_out[0] for pulse)
    wire [7:0] uio_oe;      // Output enable signal (for uio_out)
    reg [7:0] uio_in;       // Input (unused in this design)

    // Instantiate the tt_um_random_pulse_generator module
    tt_um_random_pulse_generator uut (
        .clk(clk),
        .rst_n(rst_n),
        .ena,
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

        // Test case: Observe pulses
        #100;              // Observe pulses for 100 time units

        // End the simulation after 200 time units
        #200 $finish;
    end

    // Monitor output and detect pulses
    integer pulse_count = 0;
    integer last_pulse_time = 0;

    initial begin
        $monitor("Time = %0t, Pulse = %b", $time, uio_out[0]);
        
        // Monitor pulse on uio_out[0] and calculate intervals
        forever begin
            @(posedge clk);
            if (uio_out[0]) begin
                pulse_count = pulse_count + 1;
                $display("Pulse #%0d at Time = %0t, Interval since last pulse = %0t", pulse_count, $time, $time - last_pulse_time);
                last_pulse_time = $time;
            end
        end
    end

endmodule
