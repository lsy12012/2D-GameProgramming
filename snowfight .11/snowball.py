__author__ = 'lsy'

import random

from pico2d import *

class Snow:

    image = None;

    def __init__(self):
        self.x, self.y = random.randint(200, 790), 60
        if Snow.image == None:
            Snow.image = load_image('image\\snowball.png')

    def update(self, frame_time):
        pass

    def draw(self):
        self.image.draw(self.x, self.y)

    def get_bb(self):
        return self.x - 10, self.y - 10, self.x + 10, self.y + 10

    def draw_bb(self):
        draw_rectangle(*self.get_bb())
