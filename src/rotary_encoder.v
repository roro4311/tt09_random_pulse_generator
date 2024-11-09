module rotary_encoder (
    input wire clk,          // Clock signal (usually the system clock)
    input wire rst,          // Reset signal
    input wire clk_in,       // Rotary encoder clock signal
    input wire dt_in,        // Rotary encoder data signal (directional)
    output reg [1:0] encoder // Output representing the encoder value (e.g., frequency control)
);

    reg [1:0] state;         // State of the rotary encoder (for debouncing and state tracking)
    reg [1:0] last_state;    // Last state for detecting changes
    reg [1:0] direction;     // Direction of rotation (0 = clockwise, 1 = counterclockwise)

    // Debounce the rotary encoder inputs to eliminate noise
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            last_state <= 2'b00;
            direction <= 2'b00;
            encoder <= 2'b00;
        end else begin
            // Shift the inputs into the state register
            state <= {clk_in, dt_in};

            // Detect changes in the encoder's state to determine rotation direction
            if (state != last_state) begin
                if (state == 2'b01) begin
                    direction <= 2'b00; // Clockwise (increases frequency)
                end else if (state == 2'b10) begin
                    direction <= 2'b01; // Counter-clockwise (decreases frequency)
                end
                last_state <= state;

                // Update the encoder output based on direction
                if (direction == 2'b00) begin
                    encoder <= encoder + 1'b1; // Increase encoder value (clockwise)
                end else begin
                    encoder <= encoder - 1'b1; // Decrease encoder value (counter-clockwise)
                end
            end
        end
    end
endmodule
