import json
import re
import os

def clean_paramod_names(input_folder, output_folder):
    # Regex 1: handle $paramod\MyAdder\width=...
    pattern_normal = re.compile(r"\$paramod\\([^\\]+)\\[^\\]+")
    # Regex 2: handle $paramod$<hash>\CSA_3to2_18_18_18
    pattern_hash = re.compile(r"\$paramod\$[a-f0-9]+\\([^\\]+)")

    def replace_paramod(value):
        if isinstance(value, str):
            new_value = pattern_normal.sub(r"\1", value)
            new_value = pattern_hash.sub(r"\1", new_value)
            return new_value
        elif isinstance(value, dict):
            return {replace_paramod(k): replace_paramod(v) for k, v in value.items()}
        elif isinstance(value, list):
            return [replace_paramod(v) for v in value]
        return value

    for root, _, files in os.walk(input_folder):
        for file in files:
            if file.endswith(".json"):
                input_path = os.path.join(root, file)
                rel_path = os.path.relpath(input_path, input_folder)  # relative path
                output_path = os.path.join(output_folder, rel_path)   # output file path

                # Skip if the target file already exists
                if os.path.exists(output_path):
                    print(f"Skip! File already exists: {output_path}")
                    continue

                try:
                    with open(input_path, 'r', encoding='utf-8') as f:
                        original_data = json.load(f)

                    cleaned_data = replace_paramod(original_data)

                    # Create intermediate directories in the output path if not exist
                    os.makedirs(os.path.dirname(output_path), exist_ok=True)

                    with open(output_path, 'w', encoding='utf-8') as f:
                        json.dump(cleaned_data, f, indent=2)

                    print(f"Saved cleaned file to: {output_path}")
                except Exception as e:
                    print(f"Error! Failed to process {input_path} -- {str(e)}")

# Example usage
clean_paramod_names(".\\json", ".\\cleaned_json")
