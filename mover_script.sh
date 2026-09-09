#!/bin/bash
# the source file where the csv and json files lives & the json_and_csv directory, both files destination
SFPATH="/mnt/c/Users/godwi/Desktop/cde/source_files/"
JCPATH="/mnt/c/Users/godwi/Desktop/cde/json_and_csv/"
#the source and destination directory are created
mkdir -p $SFPATH $JCPATH

#this create file 'sample files' & and write i love you inside of it.
echo "I love you" > $SFPATH/sample1.txt
echo '{"name": "Alex", "age": 28, "isDeveloper": true}' > $SFPATH/sample2.json
echo "total,reveue,stocks" > $SFPATH/sample3.csv
echo "presentations slides" > $SFPATH/samples4.csv
echo '{"account_ame": "Alex", "age": 28, "isDeveloper": true}' > $SFPATH/sample5.json

# This block is to find both the csv and json files
# once the file has been found, they are move through a pipe operator
# A pipe operator only receives stream of text as output and list, for this to work ''xargs' command was added
# xargs command put the list into an argument '{}'
# The argument preceed as the output of both the .csc/.json files
# the output is moved to $JCPATH
find $SFPATH  -name "*.csv" | xargs -I {} mv {} $JCPATH
find $SFPATH  -name "*.json" | xargs -I {} mv {} $JCPATH
