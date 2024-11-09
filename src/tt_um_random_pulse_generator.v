// tt_um_random_pulse_generator.v - Random Pulse Generator Wrapper Module
module tt_um_random_pulse_generator (
     input wire clk,
    input wire rst_n,
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire [7:0] uio_in,
    input wire ena
);

  // Internal signal for pulse output from the random_pulse_generator module
    wire pulse;

    // Instantiate the random_pulse_generator module
    random_pulse_generator pulse_gen_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pulse(pulse)
    );

    // Output assignments
    assign uo_out = 8'b0;             // Not used in this project, always 0
    assign uio_out = {7'b0, pulse};   // Only 1 bit used for the pulse output (LSB)
    assign uio_oe = 8'b11111111;      // Output enable all bits

endmodule
