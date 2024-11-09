module tt_um_random_pulse_generator (
    input wire clk,
    input wire rst_n,
    input wire [7:0] ui_in,     // Use ui_in to pass rotary encoder inputs
    output wire [7:0] uo_out,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire [7:0] uio_in,
    input wire ena
);

    // Internal signal for pulse output from the random_pulse_generator module
    wire pulse;
    wire [1:0] encoder_val;  // Rotary encoder output to control pulse frequency

    // Map the rotary encoder inputs from ui_in (using the lower 2 bits for clk_in and dt_in)
    assign clk_in = ui_in[0];  // Assume bit 0 represents the rotary encoder clock
    assign dt_in = ui_in[1];   // Assume bit 1 represents the rotary encoder data signal

    // Instantiate the random_pulse_generator module
    random_pulse_generator pulse_gen_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pulse(pulse),
        .frequency(encoder_val)   // Pass the encoder value to adjust frequency
    );

    // Instantiate the rotary_encoder logic using ui_in bits
    rotary_encoder encoder_inst (
        .clk(clk), 
        .rst(rst_n),
        .clk_in(clk_in),   // Use clk_in from ui_in
        .dt_in(dt_in),     // Use dt_in from ui_in
        .encoder(encoder_val)  // Output the encoder value (frequency control)
    );

    // Output assignments
    assign uo_out = 8'b0;              // Not used in this project, always 0
    assign uio_out = {7'b0, pulse};    // Only 1 bit used for the pulse output (LSB)
    assign uio_oe = 8'b11111111;       // Output enable all bits

endmodule
