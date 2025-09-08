
module tb;
    // Parameters
    parameter data_width = 20; // Replace with the width you're testing
    integer i, correct_count, total_tests;

    // Inputs
    reg [data_width-1:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11;

    // Outputs from both modules
    wire [data_width-1:0] dout_wino0, dout_wino1, dout_wino2, dout_wino3, dout_wino4, dout_wino5, dout_wino6, dout_wino7, dout_wino8, dout_wino9, dout_wino10, dout_wino11;
    wire [data_width-1:0] dout_golden0, dout_golden1, dout_golden2, dout_golden3, dout_golden4, dout_golden5, dout_golden6, dout_golden7, dout_golden8, dout_golden9, dout_golden10, dout_golden11;

    // Instantiate the original module
    Wino_BTDB_22_32 #(
        .data_width(data_width)
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
        .dout0(dout_wino0),
        .dout1(dout_wino1),
        .dout2(dout_wino2),
        .dout3(dout_wino3),
        .dout4(dout_wino4),
        .dout5(dout_wino5),
        .dout6(dout_wino6),
        .dout7(dout_wino7),
        .dout8(dout_wino8),
        .dout9(dout_wino9),
        .dout10(dout_wino10),
        .dout11(dout_wino11)
    );

    // Instantiate the golden model
    Wino_BTDB_22_32_golden #(
        .data_width(data_width)
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
        .dout0(dout_golden0),
        .dout1(dout_golden1),
        .dout2(dout_golden2),
        .dout3(dout_golden3),
        .dout4(dout_golden4),
        .dout5(dout_golden5),
        .dout6(dout_golden6),
        .dout7(dout_golden7),
        .dout8(dout_golden8),
        .dout9(dout_golden9),
        .dout10(dout_golden10),
        .dout11(dout_golden11)
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
            din6 = $random;
            din7 = $random;
            din8 = $random;
            din9 = $random;
            din10 = $random;
            din11 = $random;
            
            // Wait for a short time to ensure outputs are updated
            #10;

            // Compare outputs using a loop and update correct count if all match
            if ((dout_wino0 === dout_golden0) && 
                (dout_wino1 === dout_golden1) && 
                (dout_wino2 === dout_golden2) && 
                (dout_wino3 === dout_golden3) && 
                (dout_wino4 === dout_golden4) && 
                (dout_wino5 === dout_golden5) &&
                (dout_wino6 === dout_golden6) && 
                (dout_wino7 === dout_golden7) &&
                (dout_wino8 === dout_golden8) && 
                (dout_wino9 === dout_golden9) && 
                (dout_wino10 === dout_golden10) && 
                (dout_wino11 === dout_golden11)) begin
                correct_count = correct_count + 1;
            end
        end

        // Report the accuracy
        $display("Correct outputs: %0d out of %0d", correct_count, total_tests);
        $display("Accuracy: %0.2f%%", (correct_count * 100.0) / total_tests);
        $finish;
    end

endmodule
