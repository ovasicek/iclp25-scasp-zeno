#!/bin/sh

ROOTDIR="$(dirname "$(realpath "$0")")"


# commandline arguments
if [ $# -ge 2 ]; then
    MODEL_NAME="$1"
    shift
    SOURCE_FILES="$@"
else
    echo "Usage: $0 model_name source_file1 source_file2 ..."
    exit 1
fi

# clear the output file
echo "" > $MODEL_NAME-preprocessed.pl

# create "can_something(event, fluent)." for rules like "initiates(event1, fluent1, T) :- holdsAt(...), happens(...), ... ."
cat $SOURCE_FILES | grep -v " %//NO_PREPROCESS" | grep -E "^ *(initiates|terminates|releases)" | sed -E "s| *:-.*$|.|" | sed -E "s/(initiates|terminates|releases)/can_\1/g" | sed -E "s|, *T *\)|)|g" >> $MODEL_NAME-preprocessed.pl

# create "can_trajectory(fluent1, T1, fluent2, T2)." for rules like "trajectory(fluent1, T1, fluent2, T2) :- holdsAt(...), happens(...), ... ."
cat $SOURCE_FILES | grep -v " %//NO_PREPROCESS" | grep -E "^ *trajectory" | sed -E "s| *:-.*$|.|" | sed -E "s|trajectory|can_trajectory|g" >> $MODEL_NAME-preprocessed.pl

sorted=$(cat $MODEL_NAME-preprocessed.pl | LC_ALL=C.UTF-8 sort | uniq)
echo "$sorted" > $MODEL_NAME-preprocessed.pl