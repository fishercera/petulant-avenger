#! /usr/bin/python

count = 0
read_name = "read" + str(count)
print(read_name)




with open("file") as InFile:
    for line in InFile:
        OutFile=open("outfile", "a")
        if ">" in line:
            count=count+1
            read_name=">read_"+str(count)+"/n"
            newLine=read_name
        else:
            newLine=line
        OutFile.write(newLine)
        OutFile.close()


