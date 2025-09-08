import os
import subprocess
import time
from svglib.svglib import svg2rlg
from reportlab.graphics import renderPM

def convert_json_to_svg(module_dir, module_name, svg_output_dir):
    """Generate SVG file using netlistsvg"""
    json_path = os.path.join(module_dir, f"{module_name}.json")
    svg_path = os.path.join(svg_output_dir, f"{module_name}.svg")

    if not os.path.exists(json_path):
        print(f"error! JSON file not found: {json_path}")
        return None

    print(f"info! Generating SVG for: {json_path}")
    command = f'netlistsvg {json_path} -o {svg_path}'
    try:
        subprocess.run(command, shell=True, check=True)
        return svg_path
    except subprocess.CalledProcessError as e:
        print(f"error! Error generating SVG: {e}")
        return None

def svg_to_jpg(input_path, output_path, scale=1, dpi=100):
    """Convert SVG file to JPG"""
    try:
        drawing = svg2rlg(input_path)
        drawing.width *= scale
        drawing.height *= scale
        drawing.scale(scale, scale)
        renderPM.drawToFile(drawing, output_path, fmt="JPEG", dpi=dpi)
        print(f"info! Converted to JPG: {output_path}")
    except Exception as e:
        print(f"error! Failed to convert {input_path} to JPG: {e}")

def process_folder(input_folder, output_folder):
    total_start = time.time()

    svg_folder = os.path.join(output_folder, "svg")
    jpg_folder = os.path.join(output_folder, "jpg")
    os.makedirs(svg_folder, exist_ok=True)
    os.makedirs(jpg_folder, exist_ok=True)

    # Traverse all JSON files
    for root, _, files in os.walk(input_folder):
        for file in files:
            if file.endswith(".json"):
                start_time = time.time()
                module_name = os.path.splitext(file)[0]
                module_dir = root

                svg_path = os.path.join(svg_folder, f"{module_name}.svg")
                jpg_path = os.path.join(jpg_folder, f"{module_name}.jpg")

                # Skip if the output files already exist
                if os.path.exists(svg_path) and os.path.exists(jpg_path):
                    print(f"skip! {module_name} already exists. Skipping...")
                    continue

                # Step 1: JSON → SVG
                svg_path = convert_json_to_svg(module_dir, module_name, svg_folder)
                if svg_path:
                    # Step 2: SVG → JPG
                    svg_to_jpg(svg_path, jpg_path)

                elapsed = time.time() - start_time
                print(f"info! Processing {file} took {elapsed:.2f} seconds.\n")

    total_elapsed = time.time() - total_start
    print(f"done! All tasks completed in {total_elapsed:.2f} seconds.")


# Run the main function
process_folder(".\\cleaned_json", ".")
