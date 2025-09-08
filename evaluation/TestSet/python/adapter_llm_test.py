import os
import re
import time
from transformers import AutoTokenizer, AutoProcessor, AutoModelForVision2Seq
from peft import PeftModel
from PIL import Image
import torch

# ==== Model and device configuration ====
base_model_path = "Llama-3-2-11B-Vision-Instruct"
lora_adapter_path = "v16-R1-Llama-3.2-11B-Vision-Instruct/lora/sft/"
device = "cuda:0"

# Load base model + LoRA adapter
model = AutoModelForVision2Seq.from_pretrained(
    base_model_path,
    torch_dtype=torch.bfloat16,
    trust_remote_code=True
).to(device)

model = PeftModel.from_pretrained(model, lora_adapter_path)

model.eval()

# Load processor with template behavior from training
processor = AutoProcessor.from_pretrained(base_model_path, trust_remote_code=True)

def clean_generated_code(text):
    """Truncate the generated code at 'endmodule' and append it to ensure completeness."""
    truncated = re.split(r"endmodule", text, maxsplit=1)[0]
    return truncated.strip() + "\nendmodule"

def load_image(image_path):
    """Load an image from disk and convert it to RGB format."""
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"Image not found: {image_path}")
    return Image.open(image_path).convert("RGB")

def generate_code(prompt, image_path):
    """
    Generate Verilog code based on the input prompt and image.

    Steps:
    1. Load the image from disk.
    2. Parse the prompt into text before and after the image tag.
    3. Format the input in chat style with image and text.
    4. Preprocess using processor and move tensors to the target device.
    5. Use the model to generate code tokens.
    6. Decode and clean the result.
    """
    image = load_image(image_path)
    before_text, after_text = split_prompt_at_image_tag(prompt)

    # Construct chat-style input
    messages = [{"role": "user", "content": []}]
    if before_text:
        messages[0]["content"].append({"type": "text", "text": before_text})
    messages[0]["content"].append({"type": "image"})
    if after_text:
        messages[0]["content"].append({"type": "text", "text": after_text})

    # Convert messages to input string for model
    input_text = processor.apply_chat_template(messages, add_generation_prompt=True)

    # Prepare model inputs (image and text) as tensors
    inputs = processor(image, input_text, add_special_tokens=False, return_tensors="pt").to(device)

    # Generate output token IDs using sampling
    generate_ids = model.generate(
        **inputs,
        max_new_tokens=8192,
        temperature=0.8,
        top_p=0.9,
        do_sample=True
    )

    # Decode token IDs to readable text
    output_text = processor.decode(generate_ids[0], skip_special_tokens=True)
    return output_text

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

def split_prompt_at_image_tag(prompt):
    """Split the prompt at <image> or <img> tag (case-insensitive)."""
    parts = re.split(r"<\s*image\s*>|<\s*img\s*>", prompt, flags=re.IGNORECASE)
    if len(parts) == 2:
        return parts[0].strip(), parts[1].strip()
    else:
        return prompt.strip(), None

def process_files(base_path, num_modules_min, num_modules_max, num_tests):
    """
    Main processing loop:
    Traverse through all modules and test sets, read the description and image,
    call the model, and write the generated Verilog code.
    """
    for i in range(num_modules_min, num_modules_max + 1):
        module_name = f'module{i}'
        for j in range(1, num_tests + 1):
            test_name = f'test{j}'
            description_path = os.path.join(base_path, module_name, test_name, 'description')
            code_path = os.path.join(base_path, module_name, test_name, 'code')
            os.makedirs(code_path, exist_ok=True)

            file_index = 0
            while True:
                desc_file = os.path.join(description_path, f"description{file_index}.txt")
                image_name_file = os.path.join(description_path, f"image_name{file_index}.txt")

                if not os.path.exists(desc_file) or not os.path.exists(image_name_file):
                    break  # No more description-image pairs

                with open(desc_file, "r") as f:
                    prompt = f.read().strip()
                with open(image_name_file, "r") as f:
                    image_filename = f.read().strip()

                image_path = os.path.join(description_path, image_filename)
                if not os.path.exists(image_path):
                    print(f"[Skipping] Image not found: {image_filename}")
                    file_index += 1
                    continue

                print(f"[Processing] {module_name}/{test_name}/description{file_index}.txt + {image_filename}")

                try:
                    generated_code = generate_code(prompt, image_path)
                    cleaned_code = clean_module_code(generated_code)
                    txt_out_path = os.path.join(code_path, f"llm_code{file_index}.txt")
                    verilog_out_path = os.path.join(code_path, f"llm_code{file_index}.v")

                    with open(txt_out_path, "w") as f:
                        f.write(generated_code)
                    with open(verilog_out_path, "w") as f:
                        f.write(cleaned_code)

                except Exception as e:
                    print(f"[Error] Failed to process {desc_file}: {e}")

                file_index += 1

            print(f"[Done] {module_name}/{test_name}")
        print(f"[Completed] All tests in {module_name}")

if __name__ == "__main__":
    base_directory = ".."
    num_modules_min = 1
    num_modules_max = 27
    num_tests = 5

    start_time = time.time()
    process_files(base_directory, num_modules_min, num_modules_max, num_tests)
    end_time = time.time()

    print(f"\n[Total Runtime] {end_time - start_time:.2f} seconds")
