__author__ = 'lsy'

import game_framework
import stage3
from pico2d import *


name = "TitleState"
image = None
bgm = None

def enter():
    global image, bgm
    image = load_image("image\\stage3.png")
    bgm = load_music('sound\\newstage.wav')
    bgm.set_volume(64)
    bgm.play(1)

def exit():
    global image
    del(image)

def handle_events():
    events = get_events()
    for event in events:
        if event.type == SDL_QUIT:
            game_framework.quit()
        else:
            if(event.type, event.key) == (SDL_KEYDOWN, SDLK_ESCAPE):
                game_framework.quit()
            elif (event.type, event.key) == (SDL_KEYDOWN, SDLK_SPACE):
                game_framework.change_state(stage3)


def draw():
    clear_canvas()
    image.draw(400, 300)
    update_canvas()


def update():
    pass

def pause():
    pass


def resume():
    pass






