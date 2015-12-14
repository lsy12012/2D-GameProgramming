import random
import json
import os

from pico2d import *


import game_framework
import title_state
import change_state


snowball = []
snowball2 = []
name = "MainState"

RedBoy = None
Snowfield = None
font = None


class Snowfield:
    def __init__(self):
        self.image = load_image('image\\background1.png')

    def draw(self):
        self.image.draw(400, 300)

    def get_bb(self):
        return 475, 150, 600, 250

    def draw_bb(self):
        draw_rectangle(*self.get_bb())

class HP:
    def __init__(self):
        self.image = load_image('image\\hpgauge.png')

    def draw(self):
        self.image.draw(400, 300)



class Redboy:
    PIXEL_PER_METER = (10.0 / 0.3)  # 10 pixel 30cm
    RUN_SPEED_KMPH = 20.0           # Km / Hour
    RUN_SPEED_MPM = (RUN_SPEED_KMPH * 1000.0 / 60.0)
    RUN_SPEED_MPS = (RUN_SPEED_MPM / 60.0)
    RUN_SPEED_PPS = (RUN_SPEED_MPS * PIXEL_PER_METER)

    def __init__(self):
        self.x, self.y = 400, 90
        self.frame = 0
        self.image = load_image('image\\redboy.png')
        self.left = 0
        self.right = 0
        self.down = 0
        self.up = 0

    def update(self):
        if(self.left) == True:
            self.x -= 1
            self.frame = 0

        elif(self.right) == True:
            self.x += 1
            self.frame = 0

        elif(self.down) == True:
            self.y -= 1
            self.frame = 0

        elif(self.up) == True:
            self.y += 1
            self.frame = 0


        def clamp(minimum, x, maximum):
            return max(minimum, min(x, maximum))


        def clamp(minimum, y, maximum):
            return max(minimum, min(y, maximum))

        self.x = clamp(50, self.x, 750)
        self.y = clamp(50, self.y, 550)


    def draw(self):
        self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)

    def get_bb(self):
        return self.x - 40, self.y - 40, self.x + 40, self.y + 40

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
        self.image = load_image('image\\enemy4.png')

     def update(self):
        self.x += self.dir
        if(self.x > 750):
            self.dir*=-1
        elif(self.x < 50):
            self.dir*=-1


     def draw(self):
        self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)

     def get_bb(self):
         return self.x - 20, self.y - 20, self.x + 20, self.y + 20

     def draw_bb(self):
         draw_rectangle(*self.get_bb())

     def throwsnow(self):
         throw = Snow2(self.x, self.y)
         snowball2.append(throw)


class Snow:
    def __init__(self, x, y):
        self.x, self.y = x, y
        self.frame = 0
        self.dir = 1
        self.image = load_image('image\\snowball.png')

    def update(self):
        self.y += self.dir
        if(self.y > 600):
            self.y = 0
            del snowball[0]

    def draw(self):
       # self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)
        self.image.draw(self.x, self.y + 30)

    def get_bb(self):
        return self.x - 10, self.y + 20, self.x + 10, self.y + 40

    def draw_bb(self):
        draw_rectangle(*self.get_bb())



class Snow2:
    def __init__(self, x, y):
        self.x, self.y = x, y
        self.frame = 0
        self.dir = 1
        self.image = load_image('image\\snowball.png')

    def update(self):
        self.y -= self.dir
        if(self.y < 0):
            self.y = 600
            del snowball2[0]

    def draw(self):
       # self.image.clip_draw(self.frame * 100, 0, 100, 100, self.x, self.y)
        self.image.draw(self.x, self.y + 30)

    def get_bb(self):
        return self.x - 10, self.y + 20, self.x + 10, self.y + 40

    def draw_bb(self):
        draw_rectangle(*self.get_bb())



#snowball = [Snow() for i in range (10)]
def enter():
    global redboy, snowfield, enemies, snow, snowball, snowball2, hpgauge
    redboy = Redboy()
    snowfield = Snowfield()
    enemies = [Enemy() for i in range (3)]
#    snow = Snow()
    hpgauge = HP()
    snowball = []
    snowball2 = []

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
        elif(event.type) == SDL_KEYDOWN and SDL_MOUSEBUTTONDOWN:
            if(event.key) == SDLK_ESCAPE:
                game_framework.change_state(title_state)

            elif(event.key) == SDLK_LEFT:
                redboy.left = True
                redboy.right = False

            elif(event.key) == SDLK_RIGHT:
                redboy.left = False
                redboy.right = True

            elif(event.key) == SDLK_DOWN:
                redboy.up = False
                redboy.down = True

            elif(event.key) == SDLK_UP:
                redboy.up = True
                redboy.down = False

            elif(event.key) == SDLK_SPACE:
                redboy.throwsnow()

            elif(event.key) == SDLK_a:
                for enemy in enemies:
                    enemy.throwsnow()


        elif(event.type) == SDL_KEYUP:
            if(event.key) == SDLK_LEFT:
                redboy.left = False
            elif(event.key) == SDLK_RIGHT:
                redboy.right = False
            elif(event.key) == SDLK_DOWN:
                redboy.down = False
            elif(event.key) == SDLK_UP:
                redboy.up = False


def collide(a, b):
    left_a, bottom_a, right_a, top_a = a.get_bb()
    left_b, bottom_b, right_b, top_b = b.get_bb()

    if left_a > right_b : return False
    if right_a < left_b : return False
    if top_a < bottom_b : return False
    if bottom_a > top_b : return False

    return True


def update():
    redboy.update()
    for enemy in enemies:
        enemy.update()

    for member in snowball:
        member.update()

    for member in snowball:
        for enemy in enemies:
            if collide(member, enemy):
                enemies.remove(enemy)
                snowball.remove(member)

    for member in snowball2:
        member.update()

    for member in snowball2:
        if collide(member, redboy):
            redboy.remove(redboy)
            snowball2.remove(member)

    if (len(enemies) == 0):
        game_framework.change_state(change_state)




def draw():
    clear_canvas()
    snowfield.draw()
    redboy.draw()
    for enemy in enemies:
        enemy.draw()

    redboy.draw_bb()



    for enemy in enemies:
        enemy.draw_bb()

    for member in snowball:
        member.draw_bb()

    for member in snowball:
        member.draw()

    for member in snowball2:
        member.draw()

    for member in snowball2:
        member.draw_bb()
    update_canvas()





