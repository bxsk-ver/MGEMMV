
module tb;
    // Parameters
    parameter data_width = 24;
    integer i, j, correct_count, total_tests;

    // Inputs
    reg [data_width-1:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, din12, din13, din14, din15;

    // Outputs from both modules
    wire [data_width-1:0] dout_wino0, dout_wino1, dout_wino2, dout_wino3;
    wire [data_width-1:0] dout_golden0, dout_golden1, dout_golden2, dout_golden3;

    // Instantiate the original module
    Wino_ATZA_22_33 #(
        .data_width(24)
    ) uut (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .din4(din4),
        .din5(din5),
        .din6(din6),
        .din7(din7),
        .din8(din8),
        .din9(din9),
        .din10(din10),
        .din11(din11),
        .din12(din12),
        .din13(din13),
        .din14(din14),
        .din15(din15),
        .dout0(dout_wino0),
        .dout1(dout_wino1),
        .dout2(dout_wino2),
        .dout3(dout_wino3)
    );

    // Instantiate the golden model
    Wino_ATZA_22_33_golden #(
        .data_width(24)
    ) golden (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .din4(din4),
        .din5(din5),
        .din6(din6),
        .din7(din7),
        .din8(din8),
        .din9(din9),
        .din10(din10),
        .din11(din11),
        .din12(din12),
        .din13(din13),
        .din14(din14),
        .din15(din15),
        .dout0(dout_golden0),
        .dout1(dout_golden1),
        .dout2(dout_golden2),
        .dout3(dout_golden3)
    );


    // Testbench logic
    initial begin
        // Initialize correct count and total test variables
        correct_count = 0;
        total_tests = 50; 

        // Loop for multiple tests
        for (i = 0; i < total_tests; i = i + 1) begin
            // Generate random inputs
            din0 = $random;
            din1 = $random;
            din2 = $random;
            din3 = $random;
            din4 = $random;
            din5 = $random;
            din6 = $random;
            din7 = $random;
            din8 = $random;
            din9 = $random;
            din10 = $random;
            din11 = $random;
            din12 = $random;
            din13 = $random;
            din14 = $random;
            din15 = $random;
            // Wait for a short time to ensure outputs are updated
            #10;
            
            // Compare outputs and update correct count
            if ((dout_wino0 === dout_golden0) && 
                (dout_wino1 === dout_golden1) && 
                (dout_wino2 === dout_golden2) && 
                (dout_wino3 === dout_golden3)) begin
                correct_count = correct_count + 1;
            end
        end

        // Report the accuracy
        $display("Correct outputs: %0d out of %0d", correct_count, total_tests);
        $display("Accuracy: %0.2f%%", (correct_count * 100.0) / total_tests);
        $finish;
    end
endmodule
