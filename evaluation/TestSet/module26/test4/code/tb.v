
`timescale 1ns / 1ps

module tb;

    // Parameters
    parameter data_width = 22;
    parameter w_tile_column_size = 16;
    // Signals for DUT
    reg clk;
    reg rst_n;
    reg w_en;
    reg w_compute;
    reg [data_width - 1 : 0] active_left;
    reg [data_width * w_tile_column_size - 1 :0] in_weight_above;
    reg [data_width * 2 * w_tile_column_size - 1 :0] in_sum;

    wire [data_width - 1 : 0] active_right;
    wire [data_width * w_tile_column_size - 1 :0] out_weight_below;
    wire [data_width * 2 * w_tile_column_size - 1 :0] out_sum;

    // Golden design outputs
    wire [data_width - 1 : 0] golden_out_active_right;
    wire [data_width * w_tile_column_size - 1 :0] golden_out_weight_below;
    wire [data_width * 2 * w_tile_column_size - 1 :0] golden_out_sum;

    // Instantiate DUT
    PE_row #(
        .data_width(data_width),
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

    // Instantiate golden design
    PE_row_golden #(
        .data_width(data_width),
        .w_tile_column_size(w_tile_column_size)
    ) golden (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .w_compute(w_compute),
        .active_left(active_left),
        .active_right(golden_out_active_right),
        .in_weight_above(in_weight_above),
        .out_weight_below(golden_out_weight_below),
        .in_sum(in_sum),
        .out_sum(golden_out_sum)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    integer passed_tests = 0;
    integer failed_tests = 0;
    integer num_tests = 0;
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
        #10 w_en = 1;
        for (i = 0; i < 50; i = i + 1) begin
            // Random input
            active_left = $urandom;
            in_weight_above = $urandom;
            in_sum = $urandom;
            #10;
        end
        #10 w_en = 0;
        #10 w_compute = 1;
        for (i = 0; i < 50; i = i + 1) begin
            // Random input
            active_left = $urandom;
            in_weight_above = $urandom;
            in_sum = $urandom;
            #10;

            // Check results
            mismatch = 0;
            if (active_right !== golden_out_active_right) mismatch = 1;
            
            if (out_weight_below !== golden_out_weight_below)
                mismatch = 1;
            if (out_sum !== golden_out_sum)
                mismatch = 1;

            if (mismatch) begin
                failed_tests = failed_tests + 1;
                $display("Test %0d failed", i);
            end else begin
                passed_tests = passed_tests + 1;
            end
            num_tests = num_tests + 1;
        end

        // Summary
        $display("------------------------------------------------");
        $display("Test Summary:");
        $display("Total Tests: %0d", num_tests);
        $display("Passed Tests: %0d", passed_tests);
        $display("Failed Tests: %0d", failed_tests);
        $display("Passed Rate: %f%%", (passed_tests * 100.0 / num_tests));
        $display("------------------------------------------------");

        $finish;
    end

endmodule
