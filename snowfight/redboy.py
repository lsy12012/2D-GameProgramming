import random

from pico2d import *

class Redboy:

    PIXEL_PER_METER = (10.0 / 0.3)
    RUN_SPEED_KMPH = 20.0
    RUN_SPEED_MPM = (RUN_SPEED_KMPH * 1000.0 / 60.0)
    RUN_SPEED_MPS = (RUN_SPEED_MPM / 60.0)
    RUN_SPEED_PPS = (RUN_SPEED_MPS * PIXEL_PER_METER)

    TIME_PER_ACTION = 0.5
    ACTION_PER_TIME = 1.0 / TIME_PER_ACTION
    FRAMES_PER_ACTION = 8

    image = None

    LEFT_WALK, RIGHT_WALK, UP_WALK, DOWN_WALK, STAND = 0, 1, 2, 3, 4

    def __init__(self):
        self.x, self.y = 400, 90
        self.frame = 0
        self.image = load_image('redboy.png')
        self.left = 0
        self.right = 0
        self.down = 0
        self.up = 0
        self.life_time = 0.0
        self.tatal_frames = 0.0
        self.dir = 0
        self.state = self.RIGHT_WALK

    def update(self, frame_time):
        def clamp(minimum, x, maximum):
            return max(minimum, min(x, maximum))

        self.life_time += frame_time
        distance = Redboy.RUN_SPEED_PPS * frame_time
        self.total_frames += Redboy.FRAMES_PER_ACTION * Redboy.ACTION_PER_TIME * frame_time
        self.frame = int(self.total_frames) % 8
        self.x += clamp(0, self.x, 800)



    def draw(self):
        self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)


    def get_bb(self):
        return self.x - 50, self.y - 50, self.x + 50, self.y + 50


    def draw_bb(self):
        draw_rectangle(*self.get_bb())


    def handle_event(self, event):
       if (event.type, event.key) == (SDL_KEYDOWN, SDLK_LEFT):
            if self.state in (self.STAND, self.RIGHT_WALK):
                self.state = self.LEFT_WALK
                self.dir = -1
        elif (event.type, event.key) == (SDL_KEYDOWN, SDLK_RIGHT):
            if self.state in (self.STAND, self.LEFT_WALK):
                self.state = self.RIGHT_WALK
                self.dir = 1
        elif (event.type, event.key) == (SDL_KEYUP, SDLK_LEFT):
            if self.state in (self.LEFT_WALK):
                self.state = self.STAND
                self.dir = 0
        elif (event.type, event.key) == (SDL_KEYUP, SDLK_RIGHT):
            if self.state in (self.RIGHT_WALK):
                self.state = self.STAND
                self.dir = 0