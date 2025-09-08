
module tb;
    // Parameters
    parameter data_width = 23;
    integer i, j, correct_count, total_tests;

    // Inputs
    reg [data_width-1:0] din0, din1, din2, din3, din4, din5;

    // Outputs from both modules
    wire [data_width-1:0] dout_wino0, dout_wino1, dout_wino2, dout_wino3, dout_wino4, dout_wino5;
    wire [data_width-1:0] dout_golden0, dout_golden1, dout_golden2, dout_golden3, dout_golden4, dout_golden5;

    // Instantiate the original module
    Wino_BTDB_22_12 #(
        .data_width(23)
    ) uut (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .din4(din4),
        .din5(din5),
        .dout0(dout_wino0),
        .dout1(dout_wino1),
        .dout2(dout_wino2),
        .dout3(dout_wino3),
        .dout4(dout_wino4),
        .dout5(dout_wino5)
    );

    // Instantiate the golden model
    Wino_BTDB_22_12_golden #(
        .data_width(23)
    ) golden (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .din4(din4),
        .din5(din5),
        .dout0(dout_golden0),
        .dout1(dout_golden1),
        .dout2(dout_golden2),
        .dout3(dout_golden3),
        .dout4(dout_golden4),
        .dout5(dout_golden5)
    );

    // Testbench logic
    initial begin
        // Initialize correct count and total test variables
        correct_count = 0;
        total_tests = 10; 

        for (i = 0; i < total_tests; i = i + 1) begin
        // Generate random inputs for all channels using a loop
            din0 = $random;
            din1 = $random;
            din2 = $random;
            din3 = $random;
            din4 = $random;
            din5 = $random;
        // Wait for a short time to ensure outputs are updated
        #10;

        // Compare outputs using a loop and update correct count if all match
            if ((dout_wino0 === dout_golden0) && 
                (dout_wino1 === dout_golden1) && 
                (dout_wino2 === dout_golden2) && 
                (dout_wino3 === dout_golden3) && 
                (dout_wino4 === dout_golden4) && 
                (dout_wino5 === dout_golden5)) begin
                correct_count = correct_count + 1;
            end
        end
        // Report the accuracy
        $display("Correct outputs: %0d out of %0d", correct_count, total_tests);
        $display("Accuracy: %0.2f%%", (correct_count * 100.0) / total_tests);
        $finish;
    end

endmodule
