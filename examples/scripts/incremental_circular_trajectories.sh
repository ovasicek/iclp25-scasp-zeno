#!/bin/bash

#
# incrementally looks for occurrences of events marked with incr_event(E) and caches them as incr_happens(E,T)
#


ROOTDIR="$(dirname "$(realpath "$0")")"

# arguments
DEBUG=false
CONTINUE=false
HELP_MESSAGE="Usage: $0 [-d|-c] model axioms [args_for_final_run]"
if [ $# -eq 2 ]; then
    if [ "$1" == "-d" ]; then
        echo "$HELP_MESSAGE"
        exit 1
    fi
    if [ "$1" == "-c" ]; then
        echo "$HELP_MESSAGE"
        exit 1
    fi

    model="$1"
    axioms="$2"
    
elif [ $# -eq 3 ]; then
    if [ "$1" == "-d" ]; then
        DEBUG=true
        model="$2"
        axioms="$3"
    elif [ "$1" == "-c" ]; then
        CONTINUE=true
        model="$2"
        axioms="$3"
    else
        model="$1"
        axioms="$2"
        argsLastRun="$3"
    fi
elif [ $# -eq 4 ]; then
    model="$2"
    axioms="$3"
    argsLastRun="$4"
    if [ "$1" == "-d" ]; then
        DEBUG=true
    elif [ "$1" == "-c" ]; then
        CONTINUE=true
    else
        echo "$HELP_MESSAGE"
        exit 1
    fi
else
    echo "$HELP_MESSAGE"
    exit 1
fi

# get non-path version of narrative and model
modelName=$(echo "$model" | sed "s|^.*/\([^/]*\)$|\1|")

# if the CONTINUE argument is set and we have the *-model-increments.pl file, then just rerun the final query and exit
if $CONTINUE && test -f ./tmp-$modelName-model-increments.pl; then
    outputFinal=$({ /usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" oscasp -s0 --dcc $argsLastRun $axioms $model ./tmp-$modelName-model-increments.pl ; } 2>&1)
    echo "$outputFinal" | head -n -6
    exit
fi

# clear previous run just in case
rm -f ./tmp-$modelName-model-increments.pl && touch ./tmp-$modelName-model-increments.pl
rm -f ./tmp-$modelName-query-*.pl
rm -f ./tmp-$modelName-query-*.out


# extract max time configuration for the query, stop increments at some timepoint to make things faster if the query does not care about times greater that that
echo "% QUERY 0:
    ?- incr_query_max_time(MaxTime)." > ./tmp-$modelName-query-0.pl
output0=$({ /usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" oscasp -s1 --dcc $axioms $model ./tmp-$modelName-query-0.pl ; } 2>&1)
if $DEBUG; then echo "$output0" > ./tmp-$modelName-query-0.out; else rm -rf ./tmp-$modelName-query-0.pl; fi

if [ $(echo "$output0" | grep -c "ERROR:") -ne 0 ]; then
    echo "ERROR"
    echo "$output0" 
    exit 1
fi

if [ $(echo "$output0" | grep -c "no models") -eq 0 ]; then
    incremental_query_max_time__time=$(echo "$output0" | grep "^MaxTime = " | sed "s|MaxTime = ||" | sed "s| *||g")
    incremental_query_max_time=" EventTime .=<. $incremental_query_max_time__time,"
else
    incremental_query_max_time=""
fi

# incrementally construct the solution branch through the narrative
LAST_INCREMENT_TIME="0"
N=0
while true; do
    N=$(($N+1))
    echo "% increment $N ----------------------------------------------------------- " >> ./tmp-$modelName-model-increments.pl

    # run N.1: cache the earliest happens(E,T) of incr_event(E) in increment N
    echo "% QUERY $N.1:
        ?- EventTime .>. $LAST_INCREMENT_TIME,$incremental_query_max_time incr_event(Event), happens(Event, EventTime)." > ./tmp-$modelName-query-$N.1.pl

    output1=$({ /usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" oscasp -s0 --dcc $axioms $model ./tmp-$modelName-model-increments.pl ./tmp-$modelName-query-$N.1.pl ; } 2>&1)
    if $DEBUG; then echo "$output1" > ./tmp-$modelName-query-$N.1.out; else rm -rf ./tmp-$modelName-query-$N.1.pl; fi
    if [ $(echo "$output1" | grep -c "no models") -eq 0 ]; then
        EventTimes=$(echo "$output1" | grep "^EventTime #\?>\?= " | sed "s|EventTime #\?>\?= ||" | sed "s|,EventTime.*||" | sed "s| *||g")
        Events=$(echo "$output1" | grep "^Event = " | sed "s|Event = ||" | sed "s| *||g")

        # find the earliest event occurrence time from run N.1
        # and make all occurrences at that timepoint into facts
        # (all the ones after can be influenced by its incremental effect)
        earliestEventTime=$(echo "$EventTimes" | tail -n 1 | head -n 1)
        toPrintAsFacts=""
        for j in $(seq 1 $(echo "$EventTimes" | wc -l)); do
            Time=$(echo "$EventTimes" | tail -n $j | head -n 1)
            Event=$(echo "$Events" | tail -n $j | head -n 1)

            # found new min, wipe toPrint
            if echo "$Time < $earliestEventTime" | bc -l &> /dev/null; then
                earliestEventTime="$Time"
                toPrintAsFacts="incr_happens($Event, $Time)."
            # found more events at the same min time, add toPrint
            elif echo "$Time = $earliestEventTime" | bc -l &> /dev/null; then
                toPrintAsFacts=$(echo "$toPrintAsFacts"; echo "incr_happens($Event, $Time).")
            fi
        done

        # new happens fact from run N.1
        echo "$toPrintAsFacts" >> ./tmp-$modelName-model-increments.pl

        LAST_INCREMENT_TIME="$earliestEventTime"
    else
        break
    fi
done


# run the actual query of interest from the narrative
FinalQueryN=$(($N+1))
outputFinal=$({ /usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" oscasp -s0 --dcc $argsLastRun $axioms $model ./tmp-$modelName-model-increments.pl ; } 2>&1)
if $DEBUG; then echo "$outputFinal" > ./tmp-$modelName-query-$FinalQueryN.out; fi
echo "$outputFinal" | head -n -6

# clean tmp files
if ! $DEBUG && ! $CONTINUE; then rm -f ./tmp-$modelName-model-increments*.pl; fi