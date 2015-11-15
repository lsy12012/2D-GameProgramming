import random
import json
import os

from pico2d import *

import game_framework
import title_state


snowball = []
name = "MainState"

RedBoy = None
Snowfield = None
font = None


class Snowfield:
    def __init__(self):
        self.image = load_image('background1.png')

    def draw(self):
        self.image.draw(400, 300)

class Redboy:
    def __init__(self):
        self.x, self.y = 400, 90
        self.frame = 0
        self.image = load_image('redboy.png')
        self.left = 0
        self.right = 0
        self.down = 0
        self.up = 0

    def update(self):
        if(self.left) == True:
            self.x -= 0.5
            self.frame = 0

        elif(self.right) == True:
            self.x += 0.5
            self.frame = 0

        elif(self.down) == True:
            self.y -= 0.5
            self.frame = 0

        elif(self.up) == True:
            self.y += 0.5
            self.frame = 0

    def draw(self):
        self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)

    def get_bb(self):
        return self.x - 50, self.y - 50, self.x + 50, self.y + 50

    def draw_bb(self):
        draw_rectangle(*self.get_bb())

    def throwsnow(self):
         throw = Snow(self.x, self.y)
         snowball.append(throw)

class Enemy:
     def __init__(self):
        self.x, self.y = random.randint(100, 700), 500
        self.frame = 0
        self.dir = 0.1
        self.image = load_image('enemy1.png')

     def update(self):
        self.x += self.dir
        if(self.x > 800):
            self.dir*=-1
        elif(self.x < 0):
            self.dir*=-1


     def draw(self):
        self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)

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


#snowball = [Snow() for i in range (10)]
def enter():
    global redboy, snowfield, enemy, snow, snowball
    redboy = Redboy()
    snowfield = Snowfield()
    enemy = Enemy()
#    snow = Snow()
    snowball = []

def exit():
    global redboy, snowfield
    del(redboy)
    del(snowfield)


def pause():
    pass

def resume():
    pass

def handle_events():
    global running
    global state
    events = get_events()
    for event in events:
        if(event.type) == SDL_QUIT:
            game_framework.quit()
        elif(event.type) == SDL_KEYDOWN:
            if(event.key) == SDLK_ESCAPE:
                game_framework.change_state(title_state)

            elif(event.key) == SDLK_a:
                redboy.left = True
                redboy.right = False

            elif(event.key) == SDLK_d:
                redboy.left = False
                redboy.right = True

            elif(event.key) == SDLK_s:
                redboy.up = False
                redboy.down = True

            elif(event.key) == SDLK_w:
                redboy.up = True
                redboy.down = False

            elif(event.key) == SDLK_SPACE:
                #snow.up = True
                redboy.throwsnow()

        elif(event.type) == SDL_KEYUP:
            if(event.key) == SDLK_a:
                redboy.left = False
            elif(event.key) == SDLK_d:
                redboy.right = False
            elif(event.key) == SDLK_s:
                redboy.down = False
            elif(event.key) == SDLK_w:
                redboy.up = False


def update():
    redboy.update()
    enemy.update()
   # snow.update()
    for member in snowball:
        member.update()


def draw():
    clear_canvas()
    snowfield.draw()
    redboy.draw()
    enemy.draw()
    #snow.draw()
    for member in snowball:
        member.draw()

    update_canvas()





