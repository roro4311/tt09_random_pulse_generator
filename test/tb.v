module tb;
    reg clk;
    reg rst_n;
    wire pulse;

    random_pulse_generator uut (
        .clk(clk),
        .rst_n(rst_n),
        .pulse(pulse)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Generate a 10ns clock period
    end
endmodule
