
module tb #(
    parameter width=20
)(
);
  reg signed [width:1] A1;
  reg signed [width:1] A2;
  reg signed [width:1] A3;
  reg signed [width:1] A4;
  reg signed [width:1] A5;

  wire [width + 3:1] S;         // Sum output
  reg signed [width + 3:1] golden_result; // Store the golden design calculation result {cout, S}
  reg [width + 3:1] module_result; // Store the output from the module under test {cout, S}
  integer passed_tests = 0;     // Count of passed tests
  integer total_tests = 50;      // Total number of tests

  // Instantiate C_Sel_A_20bit module
  AdderTree_signed #(
      .width(20)           // Set parameter width
  ) AdderTree_signed_instance (
      .A1(A1),
      .A2(A2),
      .A3(A3),
      .A4(A4),
      .A5(A5),
      .S(S)               
);
  integer i;
  initial begin
    // Initialize input signals
    $display("Starting testbench...");
    // Test different input combinations
    repeat (total_tests) begin
        A1 = $urandom;
        A2 = $urandom;
        A3 = $urandom;
        A4 = $urandom;
        A5 = $urandom;
        golden_result = A1 + A2 + A3 + A4 + A5;
        // Wait for calculation results
        #10;

        // Combine module output
        module_result = S;

        // Output test data
        $display("=> golden={{%b}}, module={{%b}}",golden_result, module_result);
        
        // Verify results
        if (module_result !== golden_result) begin
          $display("Mismatch! Expected {{%b}}, got {{%b}}", golden_result, module_result);
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
