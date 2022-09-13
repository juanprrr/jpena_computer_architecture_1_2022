import tkinter as tk
from tkinter import *
from PIL import ImageTk, Image
from ImageAndText import *


class App(tk.Tk):
  def __init__(self):
    super().__init__()
    self.title(TITLE)
    self.geometry(RESOLUTION)
    self.set_input_canvas()
    self.set_output_canvas()

  def set_input_canvas(self):
    self.create_label("Input", MAIN_CANVAS_X, MAIN_CANVAS_Y-20)
    self.main_canvas = tk.Canvas(self, height=MAIN_CANVAS_H, width=MAIN_CANVAS_W, bg='white')
    self.bg = self.load_image(IMAGE_PATH)
    self.main_canvas.create_image(0, 0,anchor=NW, image=self.bg)
    self.main_canvas.bind('<Configure>', self.create_grid)
    self.main_canvas.bind('<Button-1>', self.track_mouse)
    self.main_canvas.place(x=MAIN_CANVAS_X, y=MAIN_CANVAS_Y)

  def set_output_canvas(self):
    self.create_label("Output", OUT_CANVAS_X, OUT_CANVAS_Y-20)
    self.out_canvas = tk.Canvas(self, height=OUT_CANVAS_H, width=OUT_CANVAS_W, bg='white')
    self.bg_ = self.load_image(OUT_IMAGE_PATH)
    self.out_canvas.create_image(0, 0,anchor=NW, image=self.bg_)
    self.out_canvas.place(x=OUT_CANVAS_X, y=OUT_CANVAS_Y)

  def load_image(self, image_path):
    self.pic = ImageTk.PhotoImage(Image.open(image_path))
    return self.pic
   
  def create_grid(self, event=None):
    w = self.main_canvas.winfo_width() # Referencia de ancho
    h = self.main_canvas.winfo_height() #Referencia de alto
    self.main_canvas.delete('grid_line') # quitar grid_line

    # lineas verticales
    for i in range(0, w, GRID_SIZE):
        self.main_canvas.create_line([(i, 0), (i, h)], tag='grid_line')

    # Lineas horizontales
    for i in range(0, h, GRID_SIZE):
        self.main_canvas.create_line([(0, i), (w, i)], tag='grid_line')

  def create_label(self, label_text:str, _x:int, _y:int):
    self.label = Label(self, text=label_text)
    self.label.place(x=_x, y=_y)

  def track_mouse(self, event):
    self.currentx = self.main_canvas.canvasx(event.x)
    self.currenty = self.main_canvas.canvasy(event.y)
    print("current_x, current_y", self.currentx, self.currenty)

if __name__ == "__main__":
  app = App()

  app.mainloop()