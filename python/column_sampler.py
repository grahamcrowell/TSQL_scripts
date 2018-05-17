#! /usr/bin/python
import os
import csv
from collections import *

def main():
    path = "/Users/gcrowell/Documents/git/scripts/python/lhs.csv"
    lhs_data = []
    
    with open(path) as csvfile:
        header = csvfile.readline().split("|")
        data_lines = map(lambda line: line.split("|"), csvfile.readlines(10))

if __name__ == '__main__':
    # lhs = {key: value for key,value in [("key1","left value1"),("key2","value2")]}
    # rhs = {key: value for key,value in [("key1","right value1"),("key2","value2")]}
    # merged_dict = [foo for foo in zip(lhs.keys(),zip(lhs.values(),rhs.values()))]
    # merged_dict = {foo[0]:foo[1] for foo in zip(lhs.keys(),zip(lhs.values(),rhs.values()))}
    # print(merged_dict)
    main()
