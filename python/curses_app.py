#! /usr/bin/python
# curses_app
import sys
import os
import logging
import curses
import time
import timing # https://stackoverflow.com/questions/1557571/how-do-i-get-time-of-a-python-programs-execution/1557906#1557906

def start():
    # init curses
    stdscr = curses.initscr()
    # turn of key stroke echo
    curses.noecho()
    # get each key stroke (don't wait for enter)
    curses.cbreak()
    begin_x = 20; begin_y = 7
    height = 5; width = 40
    win = curses.newwin(height, width, begin_y, begin_x)
    stdscr.addstr(0, 0, "Current mode: Typing mode", curses.A_REVERSE)
    stdscr.refresh()
    time.sleep(1)
    curses.start_color()
    curses.init_pair(1, curses.COLOR_RED, curses.COLOR_WHITE)
    # stdscr.addstr(0, 0, "Current mode: Typing mode", curses.A_REVERSE)
    stdscr.addstr(5,2,"Pretty text", curses.color_pair(1))
    stdscr.refresh()
    time.sleep(1)
    stdscr.addstr(5,4,"Overwrite a part of the screen", curses.A_BOLD)
    stdscr.addstr(2,2,"Back to normal", curses.A_NORMAL)
    stdscr.refresh()
    time.sleep(2)


def end():
    curses.nocbreak()
    curses.echo()
    curses.endwin()
    print()

def curses_app():
    start()
    end()


def main():
    curses_app()


if __name__ == '__main__':
    main()