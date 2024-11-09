module tb;

    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [7:0] uio_in;
    reg ena;
    
    // Rotary encoder inputs
    reg clk_in;
    reg dt_in;

    // Instantiate the top module (tt_um_random_pulse_generator)
    tt_um_random_pulse_generator uut (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uio_in(uio_in),
        .ena(ena)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50 MHz clock period (20 ns)
    end

    // Simulation
    initial begin
        // Initialize signals
        rst_n = 0;
        ena = 1;
        ui_in = 8'b00000000;

        // Apply reset
        #100;
        rst_n = 1;

        // Test changing pulse frequency through ui_in for the rotary encoder effect
        #100;
        ui_in = 8'b00000001;  // Simulate a low frequency setting
        #1000;
        ui_in = 8'b00000101;  // Simulate a medium frequency setting
        #1000;
        ui_in = 8'b00001111;  // Simulate a high frequency setting

        #2000;
        $stop;
    end

    // Simulate rotary encoder signals
    initial begin
        clk_in = 0;
        dt_in = 0;
        
        #200;  // Delay before starting rotary encoder signals
        forever begin
            // Simulate encoder phase relationship
            #40 clk_in = ~clk_in;
            #40 dt_in = ~dt_in;
        end
    end
endmodule
