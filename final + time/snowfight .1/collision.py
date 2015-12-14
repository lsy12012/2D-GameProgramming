__author__ = 'lsy'


from pico2d import *

import game_framework


from redboy import RedBoy
from stage1 import Snow
#from snowfield import Snowfield



name = "collision"

redboy = None
snowballs = None


def create_world():
    global redboy
    redboy = RedBoy()




def destroy_world():
    global redboy

    del(redboy)





def enter():
    open_canvas()
    game_framework.reset_time()
    create_world()


def exit():
    destroy_world()
    close_canvas()


def pause():
    pass


def resume():
    pass


def handle_events(frame_time):
    events = get_events()
    for event in events:
        if event.type == SDL_QUIT:
            game_framework.quit()
        else:
            if (event.type, event.key) == (SDL_KEYDOWN, SDLK_ESCAPE):
                game_framework.quit()
            else:
                redboy.handle_event(event)



def collide(a, b):
    left_a, bottom_a, right_a, top_a = a.get_bb()
    left_b, bottom_b, right_b, top_b = b.get_bb()

    if left_a > right_b: return False
    if right_a < left_b: return False
    if top_a < bottom_b: return False
    if bottom_a > top_b: return False

    return True



def update(frame_time):
    redboy.update(frame_time)






def draw(frame_time):
    clear_canvas()
    #grass.draw()
    redboy.draw()


    #grass.draw_bb()
    redboy.draw_bb()


    update_canvas()






