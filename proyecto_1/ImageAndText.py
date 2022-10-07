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

def caller(x1, x2, y1, y2):
    img  = array_image(IMAGE_PATH)
    image_to_text(x1, x2, y1, y2, img) 
    read_text(TEXT_PATH)

def grid_location(posx, posy):
    if posx < GRID_NM0 and posy < GRID_NM0:              #cuadro (0,0)
        caller(0, GRID_NM0, 0, GRID_NM0)
        
    elif posy < GRID_NM0 and GRID_NM0 < posx < GRID_NM1: #cuadro (1,0)
        caller(0, GRID_NM0, GRID_NM0, GRID_NM1)

    elif posy < GRID_NM0 and GRID_NM1 < posx < GRID_NM2: #cuadro (2,0)
        caller(0, GRID_NM0, GRID_NM1, GRID_NM2)

    elif posy < GRID_NM0 and GRID_NM2 < posx < GRID_NM3: #cuadro (3,0)
        caller(0, GRID_NM0, GRID_NM2, GRID_NM3)

    elif GRID_NM0 < posy < GRID_NM1 and posx < GRID_NM0: #cuadro (0,1)
        caller(GRID_NM0, GRID_NM1, 0, GRID_NM0)

    elif GRID_NM1 < posy < GRID_NM2 and posx < GRID_NM0: #cuadro (0,2)
        caller(GRID_NM1, GRID_NM2, 0, GRID_NM0)

    elif GRID_NM2 < posy < GRID_NM3 and posx < GRID_NM0: #cuadro (0,3)
        caller(GRID_NM2, GRID_NM3, 0, GRID_NM0)

    elif GRID_NM0 < posy < GRID_NM1 and GRID_NM0 < posx < GRID_NM1: #cuadro (1,1)
        caller(GRID_NM0, GRID_NM1, GRID_NM0, GRID_NM1)

    elif GRID_NM1 < posy < GRID_NM2 and GRID_NM0 < posx < GRID_NM1: #cuadro (1,2)
        caller(GRID_NM1, GRID_NM2, GRID_NM0, GRID_NM1)

    elif GRID_NM2 < posy < GRID_NM3 and GRID_NM0 < posx < GRID_NM1: #cuadro (1,3)
        caller(GRID_NM2, GRID_NM3, GRID_NM0, GRID_NM1)

    elif GRID_NM0 < posy < GRID_NM1 and GRID_NM1 < posx < GRID_NM2: #cuadro (2,1)
        caller(GRID_NM0, GRID_NM1, GRID_NM1, GRID_NM2)

    elif GRID_NM1 < posy < GRID_NM2 and GRID_NM1 < posx < GRID_NM2: #cuadro (2,2)
        caller(GRID_NM1, GRID_NM2, GRID_NM1, GRID_NM2)

    elif GRID_NM2 < posy < GRID_NM3 and GRID_NM1 < posx < GRID_NM2: #cuadro (2,3)
        caller(GRID_NM2, GRID_NM3, GRID_NM1, GRID_NM2)

    elif GRID_NM0 < posy < GRID_NM1 and GRID_NM2 < posx < GRID_NM3: #cuadro (3,1)
        caller(GRID_NM0, GRID_NM1, GRID_NM2, GRID_NM3)

    elif GRID_NM1 < posy < GRID_NM2 and GRID_NM2 < posx < GRID_NM3: #cuadro (3,2)
        caller(GRID_NM1, GRID_NM2, GRID_NM2, GRID_NM3)

    elif GRID_NM2 < posy < GRID_NM3 and GRID_NM2 < posx < GRID_NM3: #cuadro (3,3)
        caller(GRID_NM2, GRID_NM3, GRID_NM2, GRID_NM3)

    else:
        return
