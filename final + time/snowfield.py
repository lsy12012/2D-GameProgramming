__author__ = 'lsy'

import random

from pico2d import *

class snowfield:
    def __init__(self):
        self.image = load_image('background1.png')

    def draw(self):
        self.image.draw(400, 30)

    def get_bb(self):
        return 0, 0, 800, 50

    def draw_bb(self):
        draw_rectangle(*self.get_bb())

