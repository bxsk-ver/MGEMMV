import os
import subprocess
import time

def run_compile_commands(module_count_start, module_count_end,
                         adder_min_width, adder_max_width,
                         adder_tree_min_width, adder_tree_max_width,
                         adder_tree_min_number, adder_tree_max_number,
                         multi_min_width, multi_max_width,
                         min_width, max_width):
    report = []
    total_start_time = time.time()  # Start timing the entire process

    for module_id in range(21, 21 + 1):
        module_start_time = time.time()  # Start timing for each module
        base_path = ".."
        module_path = "module" + str(module_id)

        if 1 <= module_id <= 7:
            # module1 to module7 have width directories only
            for width in range(adder_min_width, adder_max_width + 1):
                width_path = os.path.join(base_path, module_path, "width" + str(width), 'sys.ys')
                result = run_yosys(width_path)
                if result is not None and "Error:" not in result:
                    print("Successfully processed:", width_path)
                else:
                    print("Failed or error in:", width_path)
                    if result is not None:
                        print("Error message:", result.strip())
                    else:
                        print("Result is None (maybe yosys command failed to run?)")
        
        elif 8 <= module_id <= 11:
            # module8 to module11 have number and type directories
            for number in range(adder_tree_min_number, adder_tree_max_number + 1):
                number_path = os.path.join(base_path, module_path, "number" + str(number))
                for type_id in range(1, 8):
                    type_path = os.path.join(number_path, "type" + str(type_id))
                    for width in range(adder_tree_min_width, adder_tree_max_width + 1):
                        width_path = os.path.join(type_path, "width" + str(width), 'sys.ys')
                        #print(width_path)
                        result = run_yosys(width_path)
                        #report.append((width_path, result))
                        if "Error:" not in result:  # Check if the result is successful
                            print("Successfully processed:", width_path)  # Print success message
        elif 12 <= module_id <= 20:
            # module12 to module19 have number and type directories
            for type_id in range(1, 8):
                type_path = os.path.join(base_path, module_path, "type" + str(type_id))
                for width in range(multi_min_width, multi_max_width + 1):
                    width_path = os.path.join(type_path, "width" + str(width), 'sys.ys')
                    result = run_yosys(width_path)
                    if "Error:" not in result:  # Check if the result is successful
                        print("Successfully processed:", width_path)  # Print success message
        elif module_id == 21:
            # module21 have width directories only
            for column in range (4,17):
                for width in range(min_width, max_width + 1):
                    width_path = os.path.join(base_path, module_path, f'column{column}', "width" + str(width), 'sys.ys')
                    result = run_yosys(width_path)
                    if "Error:" not in result:  # Check if the result is successful
                        print("Successfully processed:", width_path)  # Print success message
        elif 22 <= module_id <= 23:
            # module22 to module23 have width directories only
            for w_size0 in range(1, 4):
                if w_size0 == 1:
                    for w_size1 in range(2, 4):
                        w_size_path = os.path.join(base_path, module_path, "w_size" + str(w_size0) + str(w_size1))
                        for width in range(min_width, max_width + 1):
                            width_path = os.path.join(w_size_path, "width" + str(width), 'sys.ys')
                            result = run_yosys(width_path)
                            if "Error:" not in result:  # Check if the result is successful
                                print("Successfully processed:", width_path)  # Print success message
                else :
                    for w_size1 in range(1, 4):
                        w_size_path = os.path.join(base_path, module_path, "w_size" + str(w_size0) + str(w_size1))
                        for width in range(min_width, max_width + 1):
                            width_path = os.path.join(w_size_path, "width" + str(width), 'sys.ys')
                            result = run_yosys(width_path)
                            if "Error:" not in result:  # Check if the result is successful
                                print("Successfully processed:", width_path)  # Print success message
        elif module_id == 24:
            # module12 to module19 have number and type directories
            for sign_type_id in range(1, 3):
                sign_type_path = os.path.join(base_path, module_path, "sign_type" + str(sign_type_id))
                for multi_type_id in range(1, 3):
                    multi_type_path = os.path.join(sign_type_path, "multi_type" + str(multi_type_id))
                    for adder_type_id in range(1, 8):
                        adder_type_path = os.path.join(multi_type_path, "adder_type" + str(adder_type_id))
                        for width in range(multi_min_width, multi_max_width + 1):
                            width_path = os.path.join(adder_type_path, "width" + str(width), 'sys.ys')
                            result = run_yosys(width_path)
                            if "Error:" not in result:  # Check if the result is successful
                                print("Successfully processed:", width_path)  # Print success message
        elif 25 <= module_id <= 27:
            # module1 to module7 have width directories only
            for width in range(adder_min_width, adder_max_width + 1):
                width_path = os.path.join(base_path, module_path, "width" + str(width), 'sys.ys')
                result = run_yosys(width_path)
                if result is not None and "Error:" not in result:
                    print("Successfully processed:", width_path)
                else:
                    print("Failed or error in:", width_path)
                    if result is not None:
                        print("Error message:", result.strip())
                    else:
                        print("Result is None (maybe yosys command failed to run?)")
        elif module_id == 28:
            # module1 to module7 have width directories only
            for width in range(adder_min_width, adder_max_width + 1):
                width_path = os.path.join(base_path, module_path, "width" + str(width), 'sys.ys')
                result = run_yosys(width_path)
                if result is not None and "Error:" not in result:
                    print("Successfully processed:", width_path)
                else:
                    print("Failed or error in:", width_path)
                    if result is not None:
                        print("Error message:", result.strip())
                    else:
                        print("Result is None (maybe yosys command failed to run?)")
        elif module_id == 29:
            # module1 to module7 have width directories only
            for data_flow in range (1, 3):
                for width in range(min_width, max_width + 1):
                    width_path = os.path.join(base_path, module_path, f'data_flow{data_flow}', "width" + str(width), 'sys.ys')
                    result = run_yosys(width_path)
                    if result is not None and "Error:" not in result:
                        print("Successfully processed:", width_path)
                    else:
                        print("Failed or error in:", width_path)
                        if result is not None:
                            print("Error message:", result.strip())
                        else:
                            print("Result is None (maybe yosys command failed to run?)")
        elif module_id == 30:
            # module1 to module7 have width directories only
            for column in range (2, 17):
                for width in range(min_width, max_width + 1):
                    width_path = os.path.join(base_path, module_path, f'column{column}', "width" + str(width), 'sys.ys')
                    result = run_yosys(width_path)
                    if result is not None and "Error:" not in result:
                        print("Successfully processed:", width_path)
                    else:
                        print("Failed or error in:", width_path)
                        if result is not None:
                            print("Error message:", result.strip())
                        else:
                            print("Result is None (maybe yosys command failed to run?)")
        elif module_id == 31:
            # module1 to module7 have width directories only
            for row in range (2,17):
                for column in range (2, 3):
                    for width in range(min_width, max_width + 1):
                        width_path = os.path.join(base_path, module_path, f'row{row}', f'column{column}', "width" + str(width), 'sys.ys')
                        result = run_yosys(width_path)
                        if result is not None and "Error:" not in result:
                            print("Successfully processed:", width_path)
                        else:
                            print("Failed or error in:", width_path)
                            if result is not None:
                                print("Error message:", result.strip())
                            else:
                                print("Result is None (maybe yosys command failed to run?)")
        module_end_time = time.time()  # End timing for the module
        module_time = module_end_time - module_start_time
        print("Module %d processed in %.2f seconds" % (module_id, module_time))

    # Total time
    total_end_time = time.time()
    total_time = total_end_time - total_start_time
    print("\nTotal time for all modules: %.2f seconds" % total_time)

    # Report generation
    for path, result in report:
        print("Processed:", path, "| Result:", result)

def run_yosys(module_dir):
    """ Run Yosys to generate JSON file """
    OSS_CAD_SUITE_ENV = r"D:\\Download\\oss-cad-suite\\environment.bat"
    command = f'cmd /c "call {OSS_CAD_SUITE_ENV} & yosys -s {module_dir} & exit"'

    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as e:
        print(f'{module_dir} fails to run.')
        print("Error message:\n", e.stderr or e.stdout)
        return e.stderr or e.stdout  
    else:
        print(f'{module_dir} runs successfully!')
        return result.stdout  
        #os.chdir(original_dir)  # 恢复到原始的工作目录

# Usage example with inputs
module_count_start = 1
module_count_end = 31

adder_min_width = 1
adder_max_width = 16

min_width = 4
max_width = 16

adder_tree_min_width = 4
adder_tree_max_width = 16
adder_tree_min_number = 4
adder_tree_max_number = 16

multi_min_width = 4
multi_max_width = 16



current_directory = os.getcwd()
new_folder_name = 'json'
new_folder_path = os.path.join(current_directory, new_folder_name)
if not os.path.exists(new_folder_path):
    os.makedirs(new_folder_path)
    print(f" folder '{new_folder_name}' created successfully." )
else:
    print(f" folder '{new_folder_name}' already exists." )
run_compile_commands(module_count_start, module_count_end, adder_min_width, adder_max_width, adder_tree_min_width, adder_tree_max_width, adder_tree_min_number, adder_tree_max_number, multi_min_width, multi_max_width, min_width, max_width)
    
