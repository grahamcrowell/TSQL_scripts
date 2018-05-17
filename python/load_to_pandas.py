#! /usr/local/bin/python3
import pandas as pd
import csv
import os

def getColumnNames(path, delimiter):
    header_line = ""
    with open(path) as infile:
        header_line = infile.readline()
    return list(map(lambda token: token.strip(),header_line.split(delimiter)))


def toPandas(path, delimiter):
    return pd.read_table(path, sep=delimiter)


def isManager(path, delimiter, employee_id_column, manager_id_column):
    names = getColumnNames(path, delimiter)
    employee_id_column_idx = names.index(employee_id_column)
    print(employee_id_column_idx)
    manager_id_column_idx = names.index(manager_id_column)
    print(manager_id_column_idx)
    table = pd.read_table(path, sep=delimiter)
    # employee_ids = table[employee_id_column]
    manager_ids = set(table[manager_id_column])
    direct_reports = {}
    for row in table.iterrows():
        print(row)
        employee_id = row[employee_id_column_idx]
        manager_id = row[manager_id_column_idx]
        if manager_id not in direct_reports:
            direct_reports[manager_id] = list()
        direct_reports[manager_id].append(row)
    return direct_reports

def main():
    path1 = "/Users/gcrowell/TEST_DATA/esldata/SaltSpring/20170625/Employee.csv"
    employee_id_column = "EmployeeID"
    manager_id_column = "Direct_ManagerID"
    delimiter = ","
    # print(getColumnNames(path1, delimiter))
    # print(toPandas(path1, delimiter))
    print(isManager(path1, delimiter, employee_id_column, manager_id_column))

if __name__ == '__main__':
    main()
