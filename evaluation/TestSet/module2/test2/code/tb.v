module tb #(
    parameter width = 17  // Parameterized bit width
);

    reg [width-1:0] A;          // Input A
    reg [width-1:0] B;          // Input B
    reg cin;                    // Carry input
    wire cout;                  // Carry output
    wire [width-1:0] S;         // Sum output
    reg [width:0] golden_result; // Golden design calculation result {cout, S}
    reg [width:0] module_result; // Module under test result {cout, S}
    integer passed_tests = 0;   // Passed tests count
    integer total_tests = 50;   // Total number of tests

    // Instantiate PPA_Sklansky_17bit module
    PPA_Sklansky_17bit #(
        .width(width)           // Set parameter width
    ) PPA_Sklansky_instance (
        .A(A),                  // Connect input A
        .B(B),                  // Connect input B
        .cin(cin),              // Connect carry input
        .S(S),                  // Connect sum output
        .cout(cout)             // Connect carry output
    );
    initial begin
        // Initialize input signals
        $display("Starting testbench...");

        // Test different input combinations
        repeat (total_tests) begin
            A = $urandom;          // Generate random input A with width bits
            B = $urandom;          // Generate random input B with width bits
            cin = $urandom % 2;    // Random carry input

            // Calculate the golden design result
            golden_result = A + B + cin;

            // Wait for calculation results
            #10;

            // Combine module output
            module_result = {cout, S};

            // Output test data
            $display("A=%b, B=%b, cin=%b => golden={%b}, module={%b}", A, B, cin, golden_result, module_result);
            
            // Verify results
            if (module_result !== golden_result) begin
                $display("Mismatch! Expected {%b}, got {%b}", golden_result, module_result);
            end else begin
                $display("Test passed.");
                passed_tests = passed_tests + 1; // Increment pass count
            end
        end

        // Output test pass rate
        $display("Testbench completed.");
        $display("Passed tests: %d/%d", passed_tests, total_tests);
        $display("Pass rate: %0.2f%%", (passed_tests * 100.0) / total_tests);
        $finish;
    end

endmodule
