import random
from pico2d import*



snowball=[]

class Snow:

    def __init__(self, x, y):
        self.x, self.y = x, y
        self.frame = 0
        self.dir = 1
        self.image = load_image('snowball2.png')

    def update(self):
        self.y += self.dir
        if(self.y > 600):
            self.y = 0
            del snowball[0]

    def draw(self):
       # self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)
        self.image.draw(self.x, self.y + 30)

    def get_bb(self):
        return self.x - 10, self.y - 10, self.x + 10, self.y + 10

    def draw_bb(self):
        draw_rectangle(*self.get_bb())