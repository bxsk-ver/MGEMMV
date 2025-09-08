
module tb #(
    parameter width=8
)(
);

  reg signed [width :1] A;         
  reg signed [width :1] B;         
  wire [width*2 :1] S;         // Sum output
  reg signed [width*2 :1] golden_result; // Store the golden design calculation result {cout, S}
  reg [width*2 :1] module_result; // Store the output from the module under test {cout, S}
  integer passed_tests = 0;     // Count of passed tests
  integer total_tests = 50;      // Total number of tests

  // Instantiate PPA_Brent_Kung_8bit module
  booth_multiplier_8_PPA_Brent_Kung #(
      .width(8)           // Set parameter width
  ) booth_multiplier_instance (
      .A(A),
      .B(B),
      .S(S)               
);
  integer i;
  initial begin
    // Initialize input signals
    $display("Starting testbench...");
    // Test different input combinations
    repeat (total_tests) begin
        A = $urandom;
        B = $urandom;
        golden_result = A * B;

        // Wait for calculation results
        #10;

        // Combine module output
        module_result = S;

        // Output test data
        $display("=> golden={%b}, module={%b}",golden_result, module_result);
        
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
    #10;
    $finish;
  end

endmodule
