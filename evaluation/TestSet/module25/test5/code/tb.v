
`timescale 1ns / 1ps

module tb();

    // Parameters
    parameter data_width = 18;
    
    // Inputs for both PE and PE_golden
    reg clk;
    reg rst_n;
    reg w_en;
    reg w_compute;
    reg [data_width - 1:0] active_left;
    reg [data_width * 2 - 1:0] in_sum;
    reg [data_width - 1:0] in_weight_above;

    // Outputs for both PE and PE_golden
    wire [data_width - 1:0] active_right_PE, active_right_PE_golden;
    wire [data_width * 2 - 1:0] out_sum_PE, out_sum_PE_golden;

    // Test control variables
    integer num_tests = 50;  // Number of comparisons to run
    integer test_index = 0;  // Test index for counting
    integer seed = 1;  // Seed for randomization

    // Correctness counters
    integer passed_tests = 0;
    integer total_tests = 0;

    // Instantiate the PE module (Design Under Test)
    PE #(
        .data_width(data_width)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .w_compute(w_compute),
        .active_left(active_left),
        .active_right(active_right_PE),
        .in_sum(in_sum),
        .out_sum(out_sum_PE),
        .in_weight_above(in_weight_above)
    );

    // Instantiate the PE_golden module
    PE_golden #(
        .data_width(data_width)
    ) golden (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .w_compute(w_compute),
        .active_left(active_left),
        .active_right(active_right_PE_golden),
        .in_sum(in_sum),
        .out_sum(out_sum_PE_golden),
        .in_weight_above(in_weight_above)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initialize and apply stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        w_en = 0;
        w_compute = 0;
        active_left = 0;
        in_sum = 0;
        in_weight_above = 0;

        // Reset both PE and PE_golden modules
        #10 rst_n = 1;
        // Run multiple tests based on num_tests
        for (test_index = 0; test_index < num_tests; test_index = test_index + 1) begin
            // Apply randomized inputs for both PE and PE_golden
            #10 w_en = 1; 
                in_weight_above = $random(seed) % 16;
                active_left = $random(seed) % 16;
                in_sum = $random(seed) % 32;

            // Compare results between PE and PE_golden for this test case
            #10 check_results(out_sum_PE, out_sum_PE_golden);
        end
        #10 w_en = 0;
        for (test_index = 0; test_index < num_tests; test_index = test_index + 1) begin
            // Apply randomized inputs for both PE and PE_golden
            #10 w_compute = 1;
                in_weight_above = $random(seed) % 16;
                active_left = $random(seed) % 16;
                in_sum = $random(seed) % 32;

            // Compare results between PE and PE_golden for this test case
            #10 check_results(out_sum_PE, out_sum_PE_golden);
        end

        // Finalize the simulation
        #10 $display("Total tests: %d, Passed: %d, Pass rate: %0.2f%%", total_tests, passed_tests, (passed_tests * 100.0 / total_tests));
        #10 $finish;
    end

    // Task to check the results of PE and PE_golden and count correct tests
    task check_results;
        input [data_width * 2 - 1:0] result_PE;
        input [data_width * 2 - 1:0] result_PE_golden;
        begin
            total_tests = total_tests + 1;
            if (result_PE == result_PE_golden) begin
                passed_tests = passed_tests + 1;
                $display("Test %d Passed: PE output = %d, Golden output = %d", total_tests, result_PE, result_PE_golden);
            end else begin
                //$display("active_left: %d, in_weight_above: %d", active_left, in_weight_above);
                $display("Test %d Failed: PE output = %d, Golden output = %d", total_tests, result_PE, result_PE_golden);
            end
        end
    endtask

endmodule
