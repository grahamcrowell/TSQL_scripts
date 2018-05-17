#! /usr/bin/python
import os
import csv
from collections import *
lhs = "/Users/gcrowell/Documents/git/scripts/python/lhs.csv"
rhs = "/Users/gcrowell/Documents/git/scripts/python/rhs.csv"

class Comparer:
    def __init__(self, lhs_path, rhs_path):
        self.lhs_path = lhs_path
        self.rhs_path = rhs_path
        print("lhs = {}".format(self.lhs_path))
        print("rhs = {}".format(self.rhs_path))
        self.lhs_data = []
        self.rhs_data = []
        with open(self.lhs_path) as csvfile:
            self.lhs_data = [row_dict for row_dict in csv.DictReader(csvfile, delimiter='|')]
        # print(self.lhs_data)
        with open(self.rhs_path) as csvfile:
            self.rhs_data = [row_dict for row_dict in csv.DictReader(csvfile, delimiter='|')]
        # print(self.rhs_data)
        self.lhs_keys = self.lhs_data[0].keys()
        self.rhs_keys = self.rhs_data[0].keys()

    # this assumes the lines in each file have the same order.
    # TODO extend so that files with different orders can still be detected as equivalent
    def line_for_line_compare(self):
        if(self.lhs_data == self.rhs_data):
            print("lhs == rhs")
        else:
            print("not equal")
            if(self.lhs_keys != self.rhs_keys):
                print("keys not equal")
                print("key intersection")
                print(self.lhs_keys & self.rhs_keys)
                print("key lhs - rhs")
                print(self.lhs_keys - self.rhs_keys)
                print("key rhs - lhs")
                print(self.rhs_keys - self.lhs_keys)
            else:
                print("keys equal, comparing line by line")
                for line_idx in range(min(len(self.rhs_data), len(self.lhs_data))):
                    print("comparing line: {}".format(line_idx + 1))
                    lhs_line_dict = self.lhs_data[line_idx]
                    rhs_line_dict = self.rhs_data[line_idx]
                    merged_dict = OrderedDict()
                    for foo in zip(lhs_line_dict.keys(),zip(lhs_line_dict.values(),rhs_line_dict.values())):
                        merged_dict[foo[0]] = foo[1]
                    for key, value in merged_dict.items():
                        if value[0] != value[1]:
                            print("\tnon-equal column: {}\n\t\t'{} != '{}'".format(key, value[0], value[1]))
                        else:
                            print("\tequal value column: '{}'\n\t\t{}".format(key, value[0], value[1]))


def main():
    comp = Comparer(lhs, rhs)
    comp.line_for_line_compare()

    # comp = Comparer(lhs, lhs)
    # comp.line_for_line_compare()


if __name__ == '__main__':
    # lhs = {key: value for key,value in [("key1","left value1"),("key2","value2")]}
    # rhs = {key: value for key,value in [("key1","right value1"),("key2","value2")]}
    # merged_dict = [foo for foo in zip(lhs.keys(),zip(lhs.values(),rhs.values()))]
    # merged_dict = {foo[0]:foo[1] for foo in zip(lhs.keys(),zip(lhs.values(),rhs.values()))}
    # print(merged_dict)
    main()
