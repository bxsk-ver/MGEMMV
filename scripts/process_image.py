from PIL import Image
import os
import json
import warnings

# Optional: remove PIL image size limit (use with caution!)
Image.MAX_IMAGE_PIXELS = None
warnings.simplefilter('ignore', Image.DecompressionBombWarning)

# Process a single image
def process_image(image_path, output_dir, json_data, image_name):
    MAX_PIXELS = 10485760  # 10MP upper limit
    PIL_MAX_PIXELS = 89478485  # PIL default limit

    try:
        with Image.open(image_path) as img:
            width, height = img.size
            total_pixels = width * height

            if total_pixels > MAX_PIXELS and total_pixels <= PIL_MAX_PIXELS:
                # Resize
                scale_factor = (MAX_PIXELS / total_pixels) ** 0.5
                new_width = int(width * scale_factor)
                new_height = int(height * scale_factor)
                img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                print(f"[Resized] {image_name}: ({width}, {height}) -> ({new_width}, {new_height})")
                output_path = os.path.join(output_dir, image_name)
                img.save(output_path)
                
            elif total_pixels > PIL_MAX_PIXELS:
                print(f"[Exceeded] {image_name} exceeds PIL limit, removing related JSON entries...")

                # Indices of entries to remove
                to_remove = []
                
                # Traverse all entries
                for idx, entry in enumerate(json_data):
                    # Check each path in the images array
                    if "images" in entry:
                        for img_path in entry["images"]:
                            # Compare by filename
                            if os.path.basename(img_path) == image_name:
                                to_remove.append(idx)
                                break  # Stop after first match
                
                # Delete in reverse order to avoid index shift
                removed_count = 0
                for idx in reversed(sorted(to_remove)):
                    del json_data[idx]
                    removed_count += 1
                
                print(f"    ➤ Removed {removed_count} entries containing {image_name}")
                return  # Do not save image

            else:
                # No processing needed, just save
                output_path = os.path.join(output_dir, image_name)
                img.save(output_path)
                print(f"[Keep] {image_name} does not need resizing, saved as is.")

    except Exception as e:
        print(f"[Error] Failed to process {image_name}: {e}")


# Process all images in a directory
def process_images_in_directory(input_dir, output_dir, json_file):
    with open(json_file, 'r', encoding='utf-8') as f:
        json_data = json.load(f)

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for filename in os.listdir(input_dir):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
            image_path = os.path.join(input_dir, filename)
            process_image(image_path, output_dir, json_data, filename)

    # Save the updated JSON
    updated_json_file = os.path.join('.', '150dpi_data.json')
    with open(updated_json_file, 'w', encoding='utf-8') as f:
        json.dump(json_data, f, ensure_ascii=False, indent=4)

    print(f"\n✅ Updated JSON saved to {updated_json_file}")

# Run the function
input_directory = 'jpg_150dpi'
output_directory = 'process_jpg_150dpi'
json_file = 'combined_descriptions.json'

process_images_in_directory(input_directory, output_directory, json_file)
