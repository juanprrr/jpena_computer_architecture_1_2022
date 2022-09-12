import tkinter as tk
from tkinter import *
from PIL import ImageTk, Image
from tkinter.messagebox import showinfo

class App(tk.Tk):
  def __init__(self):
    super().__init__()

    self.title('Proyecto 1 - Arqui')
    self.geometry('800x600')

    self.c = tk.Canvas(self, height=512, width=512, bg='white')
    self.load_image()
    self.c.pack()
    self.c.bind('<Configure>', self.create_grid)
  
  def load_image(self):
    self.pic = ImageTk.PhotoImage(Image.open("proyecto_1/bird.png"))
    self.c.create_image(0, 0,anchor=NW, image=self.pic)

  def create_grid(self, event=None):
    w = self.c.winfo_width() # Referencia de ancho
    h = self.c.winfo_height() #Referencia de alto
    self.c.delete('grid_line') # quitar grid_line

    # lineas verticales
    for i in range(0, w, 128):
        self.c.create_line([(i, 0), (i, h)], tag='grid_line')

    # Lineas horizontales
    for i in range(0, h, 128):
        self.c.create_line([(0, i), (w, i)], tag='grid_line')


if __name__ == "__main__":
  app = App()

  app.mainloop()