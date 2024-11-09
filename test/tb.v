// tb.v - Testbench for tt_um_random_pulse_generator
module tb;

    reg clk;
    reg rst_n;
    reg ena;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [7:0] uio_in;

    // Instantiate the DUT
    tt_um_random_pulse_generator dut (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uio_in(uio_in)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Test sequence
    initial begin
        rst_n = 0;
        ena = 0;
        uio_in = 8'b0;
        #20;                     // Hold reset
        rst_n = 1;               // Release reset
        ena = 1;                 // Enable the generator
        #20000;                   // Run the test for a certain period
        $finish;                 // End simulation
    end

endmodule
