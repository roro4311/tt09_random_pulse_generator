// random_pulse_generator.v - Random Pulse Generator (Simulated Radioactive Source)
module random_pulse_generator (
    input wire clk,           // Clock input
    input wire rst_n,         // Active low reset
    input wire ena,           // Enable signal
    output wire pulse         // Pulse output
);

    reg [15:0] counter;       // Counter for pulse generation
    reg [15:0] random_value;  // Random value (LFSR)
    reg pulse_reg;            // Register to store pulse signal

    // LFSR for randomness (Simple 16-bit Linear Feedback Shift Register)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 16'b0;
            random_value <= 16'b1;  // Initialize random value
            pulse_reg <= 0;
        end else if (ena) begin
            counter <= counter + 1;

            // Simple 16-bit LFSR
            random_value <= {random_value[14:0], random_value[15] ^ random_value[13] ^ random_value[12] ^ random_value[10]};

            // Compare counter with random_value to generate pulses at random intervals
            if (counter >= random_value) begin
                pulse_reg <= 1;
                counter <= 16'b0;  // Reset counter after pulse
            end else begin
                pulse_reg <= 0;
            end
        end
    end

    // Output the pulse signal
    assign pulse = pulse_reg;

endmodule
