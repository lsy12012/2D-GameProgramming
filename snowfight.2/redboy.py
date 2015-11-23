__author__ = 'lsy'


import random

from pico2d import *

snowball = []

class RedBoy:
    PIXEL_PER_METER = (10.0 / 0.3)           # 10 pixel 30 cm
    RUN_SPEED_KMPH = 20.0                    # Km / Hour
    RUN_SPEED_MPM = (RUN_SPEED_KMPH * 1000.0 / 60.0)
    RUN_SPEED_MPS = (RUN_SPEED_MPM / 60.0)
    RUN_SPEED_PPS = (RUN_SPEED_MPS * PIXEL_PER_METER)

    TIME_PER_ACTION = 0.5
    ACTION_PER_TIME = 1.0 / TIME_PER_ACTION
    FRAMES_PER_ACTION = 8

    image = None

    LEFT_WALK, RIGHT_WALK, DOWN_WALK, UP_WALK, STAND, THROW = 0, 1, 2, 3, 4, 5

    def __init__(self):
        self.x, self.y = 0, 90
        self.frame = 0
        self.life_time = 0.0
        self.total_frames = 0.0
        self.dir = 0
        self.dir2 = 0
        self.state = self.STAND
        #self.image = load_image('redboy.png')
        if RedBoy.image == None:
            RedBoy.image = load_image('redboy.png')


    def update(self, frame_time):
        def clamp(minimum, x, maximum):
            return max(minimum, min(x, maximum))

    def update(self, frame_time):
        def clamp(minimum, y, maximum):
            return max(minimum, min(y, maximum))

        self.life_time += frame_time
        distance = RedBoy.RUN_SPEED_PPS * frame_time
        self.total_frames += RedBoy.FRAMES_PER_ACTION * RedBoy.ACTION_PER_TIME * frame_time
        #self.frame = int(self.total_frames) % 8
        self.x += (self.dir * distance)
        self.y += (self.dir2 * distance)

        self.x = clamp(50, self.x, 750)
        self.y = clamp(50, self.y, 550)


    def draw(self):
        self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)

    def get_bb(self):
        return self.x - 50, self.y - 50, self.x + 50, self.y + 50

    def draw_bb(self):
        draw_rectangle(*self.get_bb())

    def throwsnow(self):
        throw = Snow(self.x, self.y)
        snowball.append(throw)

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
            if self.state in (self.LEFT_WALK,):
                self.state = self.STAND
                self.dir = 0
        elif (event.type, event.key) == (SDL_KEYUP, SDLK_RIGHT):
            if self.state in (self.RIGHT_WALK,):
                self.state = self.STAND
                self.dir = 0

        if (event.type, event.key) == (SDL_KEYDOWN, SDLK_DOWN):
            if self.state in (self.STAND, self.UP_WALK):
                self.state = self.DOWN_WALK
                self.dir2 = -1
        elif (event.type, event.key) == (SDL_KEYDOWN, SDLK_UP):
            if self.state in (self.STAND, self.DOWN_WALK):
                self.state = self.UP_WALK
                self.dir2 = 1
        elif (event.type, event.key) == (SDL_KEYUP, SDLK_DOWN):
            if self.state in (self.DOWN_WALK,):
                self.state = self.STAND
                self.dir2 = 0
        elif (event.type, event.key) == (SDL_KEYUP, SDLK_UP):
            if self.state in (self.UP_WALK,):
                self.state = self.STAND
                self.dir2 = 0

        elif (event.type, event.key) == (SDL_KEYDOWN, SDLK_SPACE):
            if self.state in (self.LEFT_WALK, self.DOWN_WALK, self.UP_WALK, self.RIGHT_WALK, self.STAND):
                self.state = self.THROW

      


class Enemy:
     PIXEL_PER_METER = (10.0 / 0.3)           # 10 pixel 30 cm
     RUN_SPEED_KMPH = 20.0                    # Km / Hour
     RUN_SPEED_MPM = (RUN_SPEED_KMPH * 1000.0 / 60.0)
     RUN_SPEED_MPS = (RUN_SPEED_MPM / 60.0)
     RUN_SPEED_PPS = (RUN_SPEED_MPS * PIXEL_PER_METER)

     TIME_PER_ACTION = 0.5
     ACTION_PER_TIME = 1.0 / TIME_PER_ACTION
     FRAMES_PER_ACTION = 8

     def __init__(self):
        self.x, self.y = random.randint(100, 700), 500
        self.frame = 0
        self.dir = 0.1
        self.image = load_image('enemy2.png')

     def update(self):
        self.x += self.dir
        if(self.x > 800):
            self.dir*=-1
        elif(self.x < 0):
            self.dir*=-1


     def draw(self):
        self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)

     def get_bb(self):
        return self.x - 50, self.y - 50, self.x + 50, self.y + 50

     def draw_bb(self):
        draw_rectangle(*self.get_bb())



class Snow:

    image = None

    def __init__(self, x, y):
        self.x, self.y = x, y
        self.frame = 0
        self.dir = 1
        self.image = load_image('snowball.png')

    def update(self, frame_time):
        self.y += self.dir
        if(self.y > 600):
            self.y = 0
            del snowball[0]

    def draw(self):
        self.image.draw(self.x, self.y + 30)

    def get_bb(self):
        return self.x - 10, self.y - 10, self.x + 10, self.y + 10

    def draw_bb(self):
        draw_rectangle(*self.get_bb())
