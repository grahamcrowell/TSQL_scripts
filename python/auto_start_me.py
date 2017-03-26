import datetime
out = r"C:\Users\gcrowell\out.txt"

f = open(out,'a')
f.write('{}\n'.format(str(datetime.datetime.today())))
f.close()