import os
import re
import subprocess
import numpy as np

def pass_at_k(n, c, k):
    """
    Calculate the probability that exactly 'k' out of the remaining 'n-c' samples
    are correct.
    
    Parameters:
    n (int): Total number of samples
    c (int): Number of correct samples
    k (int): Number of samples to assess in the pass@$k$
    
    Returns:
    float: Probability that 'k' out of 'n-c' samples are correct
    """
    if n - c < k:
        return 1.0  # Change to 1.0 since it's not possible for all k samples to be correct
    return 1.0 - np.prod(1.0 - k / np.arange(n - c + 1, n + 1))

def simulate_modules(num_modules, num_tests):
    base_path = '..'
    final_results = []  # To store final results for all modules

    for i in range(1, num_modules + 1):
        module_name = f'module{i}'
        compilation_correct = 0
        functional_correct = 0
        for j in range(1, num_tests + 1):
            test_name = f'test{j}'
            code_path = os.path.join(base_path, module_name, test_name, 'code')
            result_path = os.path.join(base_path, module_name, test_name, 'result')
            tb_file = os.path.join(code_path, 'tb.v')
            # Create result directory if it does not exist
            os.makedirs(result_path, exist_ok=True)

            # Construct simulation command
            output_vvp = os.path.join(result_path, 'out.vvp')
            
            if i <= 31:
                include_path = os.path.join(code_path, '*.v')
                compile_command = [
                    'iverilog',
                    '-o', output_vvp,
                    '-y', code_path,
                    '-s', 'tb',  # Specify the top module as 'tb'
                    '-I', code_path,
                    include_path
                ]
            else:
                include_path = os.path.join(code_path, '*.sv')
                compile_command = [
                    'iverilog',
                    '-g2012',  # Enable SystemVerilog (IEEE 1800-2012 standard)
                    '-o', output_vvp,
                    '-y', code_path,
                    '-s', 'tb',  # Specify the top module as 'tb'
                    '-I', code_path,
                    include_path
                ]

            try:
                # Execute the compile command
                compile_result = subprocess.run(compile_command, check=False, text=True, capture_output=True)

                # Check if compilation was successful
                if compile_result.returncode != 0:
                    error_message = f"Compilation failed.\n" + compile_result.stderr
                    #print(error_message)  # Print error message
                    with open(os.path.join(result_path, "out.txt"), "w") as outfile:
                        outfile.write(error_message)  # Save to out.txt
                    continue  # Skip the current test and proceed to the next one
                print(f"Compilation successful.")

                # Step 2: Run simulation with vvp and redirect output to out.txt
                output_txt = os.path.join(result_path, 'out.txt')
                run_command = ['vvp', output_vvp]
                with open(output_txt, "w") as outfile:  # Open in write mode
                    run_result = subprocess.run(run_command, check=False, text=True, stdout=outfile, stderr=subprocess.PIPE)

                    # Check if the simulation was successful
                    if run_result.returncode != 0:
                        error_message = f"Simulation failed for {module_name}/{test_name}.\n" + run_result.stderr
                        #print(error_message)  # Print error message
                        outfile.write(error_message)  # Save to out.txt
                        continue  # Skip the current test and proceed to the next one

                print(f"Simulation completed for {module_name}/{test_name}. Output saved to {output_txt}.")
                with open(output_txt, "r") as file:
                    content = file.read()
                    
                    # Check for compilation errors
                    if "Compilation failed" in content:
                        print("Compilation error detected.")
                    else:
                        # Count successful compilations if no error is found
                        compilation_correct += 1
                        print("Compilation successful.")
                        
                        # Use regex to find various 100% patterns
                        match = re.search(r"(Pass(?:ed)? rate|Accuracy):\s*([0-9.]+)%", content, re.IGNORECASE)
                        if match:
                            metric_name = match.group(1)
                            value = float(match.group(2))
                            print(f"Detected {metric_name}: {value}%")

                            # Check if value is exactly 100%
                            if value == 100.0:
                                functional_correct += 1
                                print("Test passed with 100% value.")
                            else:
                                print("Test did not reach 100%.")
                        else:
                            print("No matching metric found in the output file.")

            except Exception as e:
                print(f"An unexpected error occurred for {module_name}/{test_name}: {e}")

        total_tests = num_tests
        compilation_rate = (compilation_correct / total_tests) * 100 if total_tests > 0 else 0
        functional_rate = (functional_correct / total_tests) * 100 if total_tests > 0 else 0
        
        module_result_path = os.path.join(base_path, module_name, 'result')
        os.makedirs(module_result_path, exist_ok=True)
        module_result_file_path = os.path.join(module_result_path, 'result.txt')
        # Calculate pass@k probabilities for both compilation and functional tests
        pass_at_1_compilation = pass_at_k(total_tests, compilation_correct, 1)
        pass_at_5_compilation = pass_at_k(total_tests, compilation_correct, 5)
        pass_at_10_compilation = pass_at_k(total_tests, compilation_correct, 10)

        pass_at_1_functional = pass_at_k(total_tests, functional_correct, 1)
        pass_at_5_functional = pass_at_k(total_tests, functional_correct, 5)
        pass_at_10_functional = pass_at_k(total_tests, functional_correct, 10)

        # Write results to the module-specific result file
        with open(module_result_file_path, 'w') as result_file:
            result_file.write(f"Total tests: {total_tests}\n")
            result_file.write(f"Total passed compilations: {compilation_correct} ({compilation_rate:.2f}%)\n")
            result_file.write(f"Total functional tests passed: {functional_correct} ({functional_rate:.2f}%)\n")
            
            # Writing pass@k results for compilation
            result_file.write(f"Compilation Pass@1: {pass_at_1_compilation:.2f}\n")
            result_file.write(f"Compilation Pass@5: {pass_at_5_compilation:.2f}\n")
            result_file.write(f"Compilation Pass@10: {pass_at_10_compilation:.2f}\n")

            # Writing pass@k results for functional tests
            result_file.write(f"Functional Pass@1: {pass_at_1_functional:.2f}\n")
            result_file.write(f"Functional Pass@5: {pass_at_5_functional:.2f}\n")
            result_file.write(f"Functional Pass@10: {pass_at_10_functional:.2f}\n")

        
        # Append the results to the final results list
        # Append the results to the final results list
        final_results.append(f"Module: {module_name}\n"
                            f"Total tests: {total_tests}\n"
                            f"Total passed compilations: {compilation_correct} ({compilation_rate:.2f}%)\n"
                            f"Total functional tests passed: {functional_correct} ({functional_rate:.2f})\n"
                            f"Compilation Pass@1: {pass_at_1_compilation:.2f}\n"
                            f"Compilation Pass@5: {pass_at_5_compilation:.2f}\n"
                            f"Compilation Pass@10: {pass_at_10_compilation:.2f}\n"
                            f"Functional Pass@1: {pass_at_1_functional:.2f}\n"
                            f"Functional Pass@5: {pass_at_5_functional:.2f}\n"
                            f"Functional Pass@10: {pass_at_10_functional:.2f}\n"
                            f"{'=' * 40}\n")
        print(f"Summary results for {module_name} saved to {module_result_file_path}")

    # Write all results to the final summary file
    final_summary_path = os.path.join(base_path, 'final_results.txt')  # Path for the final summary file
    with open(final_summary_path, 'w') as final_file:
        final_file.writelines(final_results)
    
    print(f"Final summary results saved to {final_summary_path}")

# Set the number of modules and tests
num_modules = 27  # Adjust as needed
num_tests = 5     # Adjust as needed

# Run the simulation
simulate_modules(num_modules, num_tests)
