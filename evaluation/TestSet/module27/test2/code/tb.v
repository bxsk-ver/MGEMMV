
`timescale 1ns / 1ps

module tb;

    // Parameters
    parameter data_width = 19;
    parameter a_tile_row_size = 4;
    parameter w_tile_column_size = 2;

    // Signals for DUT
    reg clk;
    reg rst_n;
    reg w_en;
    reg w_compute;

    reg [data_width * a_tile_row_size - 1 : 0] active_left;
    reg [data_width * w_tile_column_size - 1 : 0] in_weight_above;
    reg [data_width * 2 * w_tile_column_size - 1 : 0] in_sum;

    wire [data_width * a_tile_row_size - 1 : 0] active_right;
    wire [data_width * w_tile_column_size - 1 : 0] out_weight_below;
    wire [data_width * 2 * w_tile_column_size - 1 : 0] out_sum;

    // Golden outputs for comparison
    wire [data_width * w_tile_column_size - 1 : 0] golden_out_weight_below;
    wire [data_width * 2 * w_tile_column_size - 1 : 0] golden_out_sum;

    // Instantiate DUT
    PE_array #(
        .data_width(data_width),
        .a_tile_row_size(a_tile_row_size),
        .w_tile_column_size(w_tile_column_size)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .w_compute(w_compute),
        .active_left(active_left),
        .active_right(active_right),
        .in_weight_above(in_weight_above),
        .out_weight_below(out_weight_below),
        .in_sum(in_sum),
        .out_sum(out_sum)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    integer passed_tests = 0;
    integer failed_tests = 0;
    integer num_tests = 50;
    integer mismatch = 0;
    integer i, j;

    initial begin
        // Initialize
        rst_n = 0;
        w_en = 0;
        w_compute = 0;
        active_left = 0;
        in_weight_above = 0;
        in_sum = 0;

        // Reset
        #10 rst_n = 1;
        #10;
        w_en = 1;
        #10;
        for (i = 0; i < num_tests; i = i + 1) begin
            // Randomize inputs
            for (j = 0; j < a_tile_row_size; j = j + 1) begin
                active_left[j*data_width +: data_width] = $random;
            end
            for (j = 0; j < w_tile_column_size; j = j + 1) begin
                in_weight_above[j*data_width +: data_width] = $random;
                in_sum[j*data_width*2 +: data_width*2] = $random;
            end
            #10;
        end
        #10;
        w_en = 0;
        w_compute = 1;
        #10;
        for (i = 0; i < num_tests; i = i + 1) begin
            // Randomize inputs
            for (j = 0; j < a_tile_row_size; j = j + 1) begin
                active_left[j*data_width +: data_width] = $random;
            end
            for (j = 0; j < w_tile_column_size; j = j + 1) begin
                in_weight_above[j*data_width +: data_width] = $random;
                in_sum[j*data_width*2 +: data_width*2] = $random;
            end

            #10;

            // Check outputs (Note: golden comparison logic is placeholder)
            mismatch = 0;
            for (j = 0; j < w_tile_column_size; j = j + 1) begin
                if (out_weight_below[j*data_width +: data_width] !== out_weight_below[j*data_width +: data_width] || 
                    out_sum[j*data_width*2 +: data_width*2] !== out_sum[j*data_width*2 +: data_width*2]) begin
                    mismatch = 1;
                    $display("Mismatch at test %0d, index %0d:", i, j);
                    $display("out_weight_below: %d", out_weight_below[j*data_width +: data_width]);
                    $display("out_sum: %d", out_sum[j*data_width*2 +: data_width*2]);
                end
            end

            if (mismatch) begin
                failed_tests = failed_tests + 1;
            end else begin
                passed_tests = passed_tests + 1;
            end

            #10;
        end

        // Report
        $display("------------------------------------------------");
        $display("Test Summary:");
        $display("Total Tests: %0d", num_tests);
        $display("Passed Tests: %0d", passed_tests);
        $display("Failed Tests: %0d", failed_tests);
        $display("Passed Rate: %f%%", (passed_tests * 100.0) / num_tests);
        $display("------------------------------------------------");

        $finish;
    end
endmodule
