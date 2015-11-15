import game_framework

from pico2d import *

from redboy import Redboy

from snowball import Snow

name = "collision"

redboy = None
snowball = None
def create_world():
    global redboy, snowball
    redboy = Redboy()
    snowball = [Snow () for i in range()]


def destroy_world():
    global redboy, snowball

    del(redboy)
    del(snowball)

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

    if left_a > right_b : return False
    if right_a < left_b : return False
    if top_a < bottom_b : return False
    if bottom_a > top_b : return False

    return True

def update(frame_time):
    redboy.update(frame_time)
    for ball in snowball:
        ball.update(frame_time)

    for ball in snowball:
        if collide(redboy, snowball):
            snowball.remove(ball)


def draw(frame_time):
    clear_canvas()
    redboy.draw()
    for ball in snowball:
        ball.draw()


    redboy.draw_bb()
    for ball in snowball:
        ball.draw_bb()

    update_canvas()
