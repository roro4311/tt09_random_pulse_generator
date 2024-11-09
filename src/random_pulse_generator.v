// random_pulse_generator.v - Random Pulse Generator (Simulated Radioactive Source)
module random_pulse_generator (
    input wire clk,           // Clock input
    input wire rst_n,         // Active low reset
    output reg pulse          // Pulse output
);

    reg [15:0] lfsr;          // 16-bit Linear Feedback Shift Register (LFSR) for randomness
    reg [15:0] counter;       // Counter for pulse generation
    reg [7:0] pulse_freq_counter;  // Additional counter to control pulse frequency

    // LFSR implementation for randomness
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 16'hACE1;     // Initialize the LFSR with a non-zero seed
            counter <= 0;
            pulse <= 0;
            pulse_freq_counter <= 0;
        end else begin
            // Shift and feedback to create a pseudo-random number
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
            counter <= counter + 1;

            // Increment the pulse frequency counter (to control pulse generation rate)
            pulse_freq_counter <= pulse_freq_counter + 1;

            // Generate a pulse when the lower 8 bits of counter match the lower 8 bits of LFSR
            if (counter[7:0] == lfsr[7:0] && pulse_freq_counter == 8'hFF) begin
                pulse <= 1;
                counter <= 0;  // Reset the counter after each pulse
                pulse_freq_counter <= 0;  // Reset the pulse frequency counter
            end else begin
                pulse <= 0;
            end
        end
    end

endmodule
