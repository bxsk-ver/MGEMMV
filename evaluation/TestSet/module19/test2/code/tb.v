
module tb #(
    parameter width=7
)(
);

  wire          valid;
  reg           clk;
  reg           rst_n;
  reg           en;
  reg unsigned [width:1] A;
  reg unsigned [width:1] B;
  wire [width*2 :1] S;         // Sum output
  reg unsigned [width*2 :1] golden_result; // Store the golden design calculation result {cout, S}
  reg [width*2 :1] module_result; // Store the output from the module under test {cout, S}
  integer passed_tests = 0;     // Count of passed tests
  integer total_tests = 50;      // Total number of tests

  // Instantiate C_Skip_A_7bit module
  serial_multiplier_7_C_Skip_A #(
      .width(7)           // Set parameter width
  ) serial_multiplier_instance (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),
      .A(A),
      .B(B),
      .valid(valid),
      .S(S)
);

  integer i;
  
  always #5 clk = ~clk;
  
  initial begin
    // Initialize input signals
    rst_n = 0;
    clk = 0;
    en = 0;
    #40;
    rst_n = 1;
    $display("Starting testbench...");
    // Test different input combinations
    repeat (total_tests) begin
        #100;
        A = $urandom;
        B = $urandom;
        golden_result = A * B;
        #10;
        en = 1;
        #10;
        en = 0;

        // Wait for calculation results 
        wait(valid);
        #5;
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
