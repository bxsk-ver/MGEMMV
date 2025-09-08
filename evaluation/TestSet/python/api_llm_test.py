
import os
import base64
import requests
import time
import re

# API configuration for the LLaMAFactory server
API_URL = "http://localhost:8000/v1/chat/completions"
MODEL_NAME = "gpt-3.5-turbo"  # Replace with your actual model name if different

def encode_image_to_base64(image_path):
    """Convert an image file to a base64-encoded string."""
    with open(image_path, "rb") as img_file:
        return base64.b64encode(img_file.read()).decode("utf-8")

def split_prompt_at_image_tag(prompt):
    """Split prompt at <image> or <img> tag, ignoring case and whitespace."""
    parts = re.split(r"<\s*image\s*>|<\s*img\s*>", prompt, flags=re.IGNORECASE)
    if len(parts) == 2:
        return parts[0].strip(), parts[1].strip()
    else:
        return prompt.strip(), None

def call_llm_with_image_and_text(prompt, image_path):
    """Call the LLM API with prompt + image + (optional) trailing prompt."""
    base64_image = encode_image_to_base64(image_path)
    before_text, after_text = split_prompt_at_image_tag(prompt)

    content = []
    if before_text:
        content.append({"type": "text", "text": before_text})
    content.append({
        "type": "image_url",
        "image_url": {
            "url": f"data:image/jpeg;base64,{base64_image}"
        }
    })
    if after_text:
        content.append({"type": "text", "text": after_text})

    payload = {
        "model": MODEL_NAME,
        "messages": [
            {
                "role": "user",
                "content": content
            }
        ],
        "temperature": 0.8,
        "top_p": 0.9,
        "max_tokens": 8192
    }

    response = requests.post(API_URL, json=payload)

    if response.ok:
        result = response.json()
        return result["choices"][0]["message"]["content"]
    else:
        raise RuntimeError(f"API request failed: {response.status_code}, {response.text}")

def clean_module_code(code_content):
    """Extract a single module block and ensure 'endmodule' is properly terminated."""
    end_idx = code_content.find("endmodule")
    if end_idx != -1:
        start_idx = code_content.rfind("module", 0, end_idx)
        cleaned_code = code_content[start_idx:end_idx].strip() if start_idx != -1 else code_content[:end_idx].strip()
    else:
        cleaned_code = code_content.strip()
    cleaned_code += "\nendmodule"
    return cleaned_code

def process_files(base_path, num_modules_min, num_modules_max, num_tests):
    """Process all modules and test sets, reading descriptions and associated images, then generating code."""
    for i in range(num_modules_min, num_modules_max + 1):
        module_name = f'module{i}'
        file_extension = ".v"

        for j in range(1, num_tests + 1):
            test_name = f'test{j}'
            description_path = os.path.join(base_path, module_name, test_name, 'description')
            code_path = os.path.join(base_path, module_name, test_name, 'code')

            file_index = 0
            while True:
                description_file = os.path.join(description_path, f"description{file_index}.txt")
                image_name_file = os.path.join(description_path, f"image_name{file_index}.txt")

                if not os.path.exists(description_file) or not os.path.exists(image_name_file):
                    break  # Stop if either paired file is missing

                with open(description_file, "r") as f:
                    prompt = f.read().strip()

                with open(image_name_file, "r") as f:
                    image_filename = f.read().strip()
                image_path = os.path.join(description_path, image_filename)

                if not os.path.exists(image_path):
                    print(f"Warning: image file {image_filename} not found, skipping.")
                    file_index += 1
                    continue

                print(f"Processing: {module_name}/{test_name} -> description{file_index}.txt + {image_filename}")

                try:
                    generated_code = call_llm_with_image_and_text(prompt, image_path)

                    output_txt = os.path.join(code_path, f"llm_code{file_index}.txt")
                    with open(output_txt, "w") as f:
                        f.write(generated_code)

                    cleaned_code = clean_module_code(generated_code)
                    output_code = os.path.join(code_path, f"llm_code{file_index}{file_extension}")
                    with open(output_code, "w") as f:
                        f.write(cleaned_code)

                except Exception as e:
                    print(f"Error processing {description_file}: {e}")

                file_index += 1

            print(f"Completed: {module_name}/{test_name}")

        print(f"Finished all tests in: {module_name}")

if __name__ == "__main__":
    base_directory = ".."  # Root directory
    num_modules_min = 1
    num_modules_max = 27
    num_tests = 5

    start_time = time.time()
    process_files(base_directory, num_modules_min, num_modules_max, num_tests)
    end_time = time.time()

    print(f"Total runtime: {end_time - start_time:.2f} seconds")
