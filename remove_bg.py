from PIL import Image, ImageDraw
import sys

def make_transparent_circle(input_path, output_path):
    img = Image.open(input_path).convert("RGBA")
    data = img.getdata()
    
    # Find bounding box of non-black pixels
    min_x = img.width
    min_y = img.height
    max_x = 0
    max_y = 0
    
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = data[y * img.width + x]
            if r > 10 or g > 10 or b > 10: # threshold for non-black
                if x < min_x: min_x = x
                if y < min_y: min_y = y
                if x > max_x: max_x = x
                if y > max_y: max_y = y
                
    if max_x < min_x:
        print("Image is entirely black!")
        sys.exit(1)
        
    # Crop to bounding box
    img = img.crop((min_x, min_y, max_x, max_y))
    
    # Create circular mask
    mask = Image.new("L", (img.width, img.height), 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, img.width, img.height), fill=255)
    
    # Apply mask
    result = Image.new("RGBA", (img.width, img.height), (0,0,0,0))
    result.paste(img, (0, 0), mask=mask)
    
    result.save(output_path, format="PNG")
    print("Done")

if __name__ == "__main__":
    make_transparent_circle("assets/images/logo fina berry.png", "assets/images/logo fina berry.png")
