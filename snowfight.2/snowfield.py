__author__ = 'lsy'

import random

from pico2d import *

class Snowfield:
    def __init__(self):
        self.image = load_image('background1.png')

    def draw(self):
        self.image.draw(400, 300)

    def get_bb(self):
        return 470, 150, 600, 250

    def draw_bb(self):
        draw_rectangle(*self.get_bb())

