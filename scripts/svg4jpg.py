import os
from svglib.svglib import svg2rlg
from reportlab.graphics import renderPM

def convert_svgs_in_folder(input_folder, output_folder, scale=1, dpi=50):
    """Convert all SVG files in the folder to JPG files"""
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Traverse all the files in the folder
    for filename in os.listdir(input_folder):
        if filename.endswith(".svg"):
            input_path = os.path.join(input_folder, filename)
            output_filename = filename.replace(".svg", ".jpg")
            output_path = os.path.join(output_folder, output_filename)

            try:
                drawing = svg2rlg(input_path)
                drawing.width *= scale
                drawing.height *= scale
                drawing.scale(scale, scale)
                renderPM.drawToFile(drawing, output_path, fmt="JPEG", dpi=dpi)
                print(f"Correct! Converted {input_path} to {output_path}")
            except Exception as e:
                print(f"Error! Failed to convert {input_path} to JPG: {e}")

input_folder = "svg"
output_folder = "jpg_50dpi"
convert_svgs_in_folder(input_folder, output_folder)
