import os
import json

def compare_json_and_folder_images(json_path, image_folder):
    # Read the image list from JSON
    with open(json_path, 'r') as f:
        data = json.load(f)

    # Extract all image file names from JSON (remove path prefixes)
    json_images = set()
    for item in data:
        if 'images' in item:
            for img in item['images']:
                print(os.path.basename(img))
                json_images.add(os.path.basename(img))

    # Get all .jpg file names from the folder
    folder_images = set(f for f in os.listdir(image_folder) if f.lower().endswith('.jpg'))

    # Find matches and mismatches
    matched = json_images & folder_images
    only_in_json = json_images - folder_images
    only_in_folder = folder_images - json_images

    # Print results
    print(f"✅ Number of matched images: {len(matched)}")
    print("\n❌ Images listed in JSON but missing in the folder:")
    for img in sorted(only_in_json):
        print("  -", img)

    print("\n❌ Images present in the folder but not mentioned in JSON:")
    for img in sorted(only_in_folder):
        print("  -", img)

# Example usage
compare_json_and_folder_images(".\\150dpi_data.json", ".\\process_jpg_150dpi")
