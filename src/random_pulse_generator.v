module random_pulse_generator (
    input wire clk,
    input wire rst_n,
    output reg pulse,
    input wire [1:0] frequency  // Input from rotary encoder to control pulse frequency
);

    reg [31:0] cnt;
    reg [31:0] thresh;

    // Adjust threshold based on rotary encoder value (frequency control)
    always @* begin
        case (frequency)
            2'b00: thresh = 32'h00100000;   // Slowest pulse frequency
            2'b01: thresh = 32'h00080000;   // Faster pulse frequency
            2'b10: thresh = 32'h00040000;   // Even faster pulse frequency
            2'b11: thresh = 32'h00020000;   // Fastest pulse frequency
            default: thresh = 32'h00100000;
        endcase
    end

    // Pulse generation logic (random-like based on shift register)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 32'haaaaaaa;   // Initial value
            pulse <= 1'b0;
        end else begin
            cnt <= {cnt[30:0], (cnt[31] ^ cnt[21] ^ cnt[1] ^ cnt[0])};
            if (cnt < thresh) begin
                pulse <= 1'b1;
            end else begin
                pulse <= 1'b0;
            end
        end
    end

endmodule
