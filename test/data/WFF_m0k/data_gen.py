#! /usr/bin/env python3
import random

LETTERS=list(map(lambda offset: chr(97+offset), range(26)))

def random_value():
    random.shuffle(LETTERS)
    return ''.join(LETTERS[0:random.randint(0,15)])

def generate_table(rows, columns):
    HEADER=""
    for i in range(1,columns+1):
        HEADER += "|col_{}".format(i)
    table=HEADER + "\n"
    for row in range(rows):
        line = ""
        for col in range(columns):
            random_length = random.randint(0,15)
            value = ''.join(random.sample(LETTERS, random_length))
            line += "|r{}c{}_{}".format(row, col, value)
        line += "\n"
        table += line
    return table[0:-1]

print(generate_table(100,20))