
module tb;

    // Parameters
    parameter data_width = 20;
    parameter a_tile_column_size = 6;
    parameter NUM_TESTS = 100;  // …Ë÷√≤‚ ‘¥Œ ˝

    // Signals
    reg clk;
    reg rst_n;
    reg en;
    reg signed [data_width * a_tile_column_size - 1 : 0] din;
    wire signed [data_width * a_tile_column_size - 1 : 0] dout;
    wire signed [data_width * a_tile_column_size - 1 : 0] dout_golden;

    // Instantiate the DUT and golden model
    DataReOrganize #(data_width, a_tile_column_size) uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .din(din),
        .dout(dout)
    );

    DataReOrganize_golden #(data_width, a_tile_column_size) uut_golden (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .din(din),
        .dout(dout_golden)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    integer i;
    integer correct_count = 0;

    // Test procedure
    initial begin
        rst_n = 0; // Reset
        en = 0;
        #10;
        rst_n = 1; // Release reset

        for (i = 0; i < NUM_TESTS; i = i + 1) begin
            // Generate random input data
            din = $random; // or use $urandom for unsigned random

            en = 1; // Enable the module
            #10;    // Wait for a few clock cycles

            // Compare outputs
            if (dout === dout_golden) begin
                correct_count = correct_count + 1;
            end

            en = 0; // Disable after checking
            #10;
        end

        // Report results
        $display("Total Tests: %0d", NUM_TESTS);
        $display("Correct Count: %0d", correct_count);
        $display("Accuracy: %0.2f%%", (correct_count * 100.0) / NUM_TESTS);
        $finish;
    end
endmodule
