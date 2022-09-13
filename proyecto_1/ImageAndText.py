import numpy as np
from PIL import Image
from constants import *



def array_image(image_path):
    img       = Image.open(image_path).convert('L') #Grayscale image
    array_img = np.asarray(img)
    return array_img

def image_to_text(i_n, i_m, j_n, j_m, array_img):
    sliced_array = array_img[i_n:i_m, j_n:j_m]
    np.savetxt(TEXT_PATH, sliced_array, fmt='%d', newline='\n') 

def read_text(filename):
    output = np.loadtxt(filename)
    img = Image.fromarray(output.astype(np.uint8),'L')
    img.save(OUT_IMAGE_PATH)
    

""" img  = array_image(IMAGE_PATH)
image_to_text(0, 128, 0, 128, img) 
read_text(TEXT_PATH) """
