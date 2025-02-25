%% based on https://github.com/sarat-chandra-varanasi/event-calculus-scasp/blob/main/train_example/bec_theory.lp

%? NOTE -- made some modifications based on axioms and to make examples work
%? marked with %! <<<<<
%?      e.g. 
%?          - moved BEC4 before BEC6                                    --> solver kept looping in BEC6 when the solution was if BEC4 (initialyP from init state)
%?          - "<" instead of "=<" e.g. for holdsAt based on initiates   --> TODO to match the axioms
%?          - moved all time constraints to the top of each rule        --> TODO makes sence to constraint time ASAP to avoid pointless exploration (also some original rules already had this, so made the other ones consistent)
%?          - added max time to all time related things                 --> was there for some and missing for others
%?          - BEC3 trajectory moved up                                  --> avoids looping over initiates(..) for events that do not have any trajectories
%?          - moved "releases" up in all axioms                         --> to hopefully make "not_released" easier to prove
%?          - moved "happens" above initiates/terminates                --> happens is part of the narrative so its easier to prove unless triggered events are used, this helps the telephone.pl example (the example has cyclic dependency of initiates/terminates predicates so the solver gets stuck in an infinite recursion of exploring initiates-->holdsat-->initiates-->...)
%?          - added can_initiates/can_terminates                        --> same as initiates/terminates but with no preconditions -- now we have can_initiate-->happens-->initiates which prevents unneccessary "happens" preconditions to be explored if the event can not have an effect on the fluent at all -- this was needed to make axioms work alarmclock.pl (avoids infinite loops)
%?          - added can_releases
%?          - removed "not terminates/initiates"                        --> TODO "not " in general seems risky, is a bit faster and seems to behave the same like this
%?          - changed can_initiates/can_terminates/can_releases to only have two parameters (no time)
%?          - used can_* in findall predicates instead of just event(E) --> to limit the size of the event list
%?          - modified not_stoppedin and not_releasedin findall rules   --> findall only finds event times that are in the interval, which makes it so that the ones outside of the interval will not be included in the model (shouldnt be because not relevant)
%?          - added can_trajectory to try and avoid loops over trajectories
%?          - there was a typo in "not_initiated"                       --> not_startedIn never worked up till now... this could change a lot of experiments
%?          - removed all fluent(F), event(E)                           --> functionality replaced by can_* rules, removing extra work
%?          - there was a typo in "in released" in the body of "not_released"
%?          - removed unnecessary time constraints
%?          - removed the last param of "not_terminated/released/initiated(..., yes/no)" --> rules with "no" were never used
%?          - added a cached_trajectory predicate                       --> used for incremental solving seems to be a little bit faster
%?          - added initialyR and trajectory from time 0                --> used for fluents which are released starting at time 0
%?          - added or_ rules                                           --> avoid cache issues
%?          - made max time constraints include the max time            --> so that we can use maxtime itself in predicate parameters
%?          - using sup/2 and inf/2 in not_stopped/startedIn            --> the previous semantic did not work well for events which happen at an interval of T (trigger time), now fixed (succeed if nothing inside, intead of succeed if something outside)
%?          - added not_interrupted/4 (and other associated predicates) --> its a configurable code shared by all the initiates/terminates/releases, before there was duplicit code which only differed in the use of initiates/terminates/releases
%?          - not_stoppedIn/startedIn custom for intervals/constants    --> different implemenations for each combination of interval/single_value for T1 and T2 (both intervals w/wo instersection, both single values, one iterval and one value)

can_terminatesOrReleases(Event, Fluent) :- can_releases(Event, Fluent).
can_terminatesOrReleases(Event, Fluent) :- can_terminates(Event, Fluent).
can_initiatesOrReleases(Event, Fluent) :- can_releases(Event, Fluent).
can_initiatesOrReleases(Event, Fluent) :- can_initiates(Event, Fluent).

%-----------------------------------------------------------------------------------------------------------------------

%% MODIFIED BASIC EVENT CALCULUS (BEC) THEORY 

%% ALWAYS USE A MAX_TIME USING max_time(MaxTime)
%% USE holdsAt(F, T) TO QUERY FLUENTS, AND not_holdsAt(F, T) TO QUERY NEGATIONS


% #show happens/2, holdsAt/2, initiallyN/1, initiallyP/1.
% #show initiates/3, terminates/3, releases/3, stoppedIn/3, startedIn/3, trajectory/4.

%%max_time(100).

%% to get around cache issues
happens(E, T) :- or_happens(E, T).
not_happens(E, T) :- or_not_happens(E, T).
not_happensIn(E, T1, T2) :- or_not_happensIn(E, T1, T2).
not_happensInInc(E, T1, T2) :- or_not_happensInInc(E, T1, T2).
not__happens(E, T) :- or_not__happens(E, T).
holdsAt(Fluent, T) :- or_holdsAt(Fluent, T).
holdsAt(Fluent, T, Fluent2OrDuration) :- or_holdsAt(Fluent, T, Fluent2OrDuration).
holdsAt(Fluent, T, Fluent2, Duration) :- or_holdsAt(Fluent, T, Fluent2, Duration).
not_holdsAt(Fluent, T) :- or_not_holdsAt(Fluent, T).
not_holdsAt(Fluent, T, Duration) :- or_not_holdsAt(Fluent, T, Duration).
stoppedIn(T1, Fluent, T2) :- or_stoppedIn(T1, Fluent, T2).
startedIn(T1, Fluent, T2) :- or_startedIn(T1, Fluent, T2).
not_stoppedIn(T1, Fluent, T2) :- or_not_stoppedIn(T1, Fluent, T2).
not_startedIn(T1, Fluent, T2) :- or_not_startedIn(T1, Fluent, T2).
trajectory(Fluent1, T1, Fluent2, T2) :- or_trajectory(Fluent1, T1, Fluent2, T2).
selfend_trajectory(Fluent1, T1, Event, T2) :- or_selfend_trajectory(Fluent1, T1, Event, T2).
initiates(Event, Fluent, T) :- or_initiates(Event, Fluent, T).
terminates(Event, Fluent, T) :- or_terminates(Event, Fluent, T).
releases(Event, Fluent, T) :- or_releases(Event, Fluent, T).
% initiallyN/1. % TODO might be needed eventualy
% initiallyP/1. % TODO might be needed eventualy



% TODO "becomes"
initiatedAt(Fluent, T) :- 
    can_initiates(Event, Fluent),
    happens(Event, T),
    initiates(Event, Fluent, T).
terminatedAt(Fluent, T) :- 
    can_terminates(Event, Fluent),
    happens(Event, T),
    terminates(Event, Fluent, T).





%% BEC1 - StoppedIn(t1,f,t2)
or_stoppedIn(T1, Fluent, T2) :-
    %T1 .>=. 0,                                                         %! <<<<<
    T1 .<. T, T .<. T2,                                                 %! <<<<<
    max_time(T3), T2 .=<. T3,                                            %! <<<<<
    can_terminates(Event, Fluent),                                      %! <<<<<
    happens(Event, T),                                                  %! <<<<<
    terminates(Event, Fluent, T).
    %not releases(Event, Fluent, T),    % TODO OR rules

or_stoppedIn(T1, Fluent, T2) :-
    %T1 .>=. 0,                                                         %! <<<<<
    T1 .<. T, T .<. T2,                                                 %! <<<<<
    max_time(T3), T2 .=<. T3,                                            %! <<<<<
    can_releases(Event, Fluent),                                        %! <<<<<
    happens(Event, T),
    releases(Event, Fluent, T).
    %not terminates(Event, Fluent, T).   % TODO OR rules


%% BEC2 - StartedIn(t1,f,t2)
or_startedIn(T1, Fluent, T2) :-
    %T1 .>=. 0,                                                         %! <<<<<
    T1 .<. T, T .<. T2,                                                 %! <<<<<
    max_time(T3), T2 .=<. T3,
    can_initiates(Event, Fluent),                                       %! <<<<<
    happens(Event, T),                                                  %! <<<<<
    initiates(Event, Fluent, T).
    
or_startedIn(T1, Fluent, T2) :-
    %T1 .>=. 0,                                                         %! <<<<<
    max_time(T3), T2 .=<. T3,
    T1 .<. T, T .<. T2,                                                 %! <<<<<
    can_releases(Event, Fluent),                                        %! <<<<<
    happens(Event, T),
    releases(Event, Fluent, T).                                         %! <<<<<
    %not initiates(Event, Fluent, T).                                   %! <<<<<

% TODO NEW AXIOM
%% BEC3 - holdsAt(f,t) -- cached version
% cached_trajectory_skip will only hold for an exact instance of T1, Fluent2, and T2.
% Only provides the value of Fluent2 and one particual T2.
or_holdsAt(Fluent2, T2) :-
    increment_trajectory_start_time(INC_START_T), T2 .=<. INC_START_T,
    T2 .>=. 0,
    cached_trajectory_skip(Fluent1, 0, Fluent2, T2).  
or_holdsAt(Fluent2, T2) :-
    increment_trajectory_start_time(INC_START_T), T1 .<. INC_START_T, T2 .=<. INC_START_T,
    T1 .>. 0, T1 .<. T2,                              
    cached_trajectory_skip(Fluent1, T1, Fluent2, T2). 

% TODO NEW AXIOM
% cached_trajectory works the same as a regular trajectory except that it
% will only be usable for a specific T1 and some TMax, and will use a cached 
% starting value of the continuous fluent.
or_holdsAt(Fluent2, T2) :-
    increment_trajectory_start_time(INC_START_T), T2 .<. INC_START_T,
    T2 .>=. 0,
    cached_trajectory_start_and_end(Fluent1, 0, TMax),
    T2 .<. TMax,
    cached_trajectory(Fluent1, 0, Fluent2, T2). 
or_holdsAt(Fluent2, T2) :-
    increment_trajectory_start_time(INC_START_T), T1 .<. INC_START_T, T2 .<. INC_START_T,
    T1 .>. 0, T1 .<. T2,                        
    cached_trajectory_start_and_end(Fluent1, T1, TMax),
    T2 .<. TMax,               
    cached_trajectory(Fluent1, T1, Fluent2, T2).

% TODO NEW AXIOM
% cached trajectory for trajectories which cross over increments
or_holdsAt(Fluent2, T2) :-
    increment_trajectory_start_time(INC_START_T), T2 .>. INC_START_T, TSplit .=. INC_START_T,
    T2 .>=. 0,
    max_time(T3), T2 .=<. T3,        
    cached_running_trajectory_at(Fluent1, TSplit),
    cached_trajectory_start_and_end(Fluent1, 0, TSplit),
    cached_trajectory(Fluent1, 0, Fluent2, T2),
    not_stoppedIn(TSplit, Fluent1, T2).
or_holdsAt(Fluent2, T2) :-
    increment_trajectory_start_time(INC_START_T), T1 .<. INC_START_T, T2 .>. INC_START_T, TSplit .=. INC_START_T,
    T1 .>. 0, T1 .<. T2,                   
    max_time(T3), T2 .=<. T3,     
    cached_running_trajectory_at(Fluent1, TSplit),
    cached_trajectory_start_and_end(Fluent1, T1, TSplit),
    cached_trajectory(Fluent1, T1, Fluent2, T2),
    not_stoppedIn(TSplit, Fluent1, T2).


%% BEC4 - holdsAt(f,t)
or_holdsAt(Fluent, T) :-
    T .>=. 0,
    max_time(T3), T .=<. T3,                                             %! <<<<<
    initiallyP(Fluent),
    not_stoppedIn(0, Fluent, T).
%    not not_holdsAt(Fluent, T).
 
% TODO NEW AXIOM
or_holdsAt(Fluent2, T2) :-
    T2 .>=. 0, 
    max_time(T3), T2 .=<. T3,
    can_trajectory(Fluent1, 0, Fluent2, T2),
    initiallyP(Fluent1),
    initiallyR(Fluent2),
    trajectory(Fluent1, 0, Fluent2, T2),
    not_stoppedIn(0, Fluent1, T2).
%    not not_holdsAt(Fluent, T).

%% BEC3 - holdsAt(f,t)
or_holdsAt(Fluent2, T2) :-
    T1 .>. 0, T1 .<. T2,                                                %! <<<<<
    max_time(T3), T2 .=<. T3,                                            %! <<<<<
    can_trajectory(Fluent1, T1, Fluent2, T2),                           %! <<<<<
    can_initiates(Event, Fluent1),                                      %! <<<<<
    happens(Event, T1),                                                 %! <<<<<
    initiates(Event, Fluent1, T1),
    trajectory(Fluent1, T1, Fluent2, T2),                               %! <<<<<
    not_stoppedIn(T1, Fluent1, T2).
%    not not_holdsAt(Fluent2, T2).

% TODO another new axiom approach -- holdsAt/3
% TODO - third parameter Fluent1 tries to say to only ever consider a specified trajectory
or_holdsAt(Fluent2, T2, Fluent1) :-
    T1 .>. 0, T1 .<. T2,                                                %! <<<<<
    max_time(T3), T2 .=<. T3,                                            %! <<<<<
    can_trajectory(Fluent1, T1, Fluent2, T2),                           %! <<<<<
    can_initiates(Event, Fluent1),                                      %! <<<<<
    happens(Event, T1),                                                 %! <<<<<
    initiates(Event, Fluent1, T1),
    trajectory(Fluent1, T1, Fluent2, T2),                               %! <<<<<
    not_stoppedIn(T1, Fluent1, T2).

% TODO another new axiom approach -- holdsAt/4
% TODO - fourth parameter is exact duration (set Duration as >= something to get minimum duration)
or_holdsAt(Fluent2, T2, Fluent1, Duration) :-
    Duration .>. 0,
    T1 .>. 0, T1 .<. T2,                                                %! <<<<<
    max_time(T3), T2 .=<. T3,                                            %! <<<<<
    T2 .=. T1 + Duration,                                           %! <<<<<
    can_trajectory(Fluent1, T1, Fluent2, T2),                           %! <<<<<
    can_initiates(Event, Fluent1),                                      %! <<<<<
    happens(Event, T1),                                                 %! <<<<<
    initiates(Event, Fluent1, T1),
    trajectory(Fluent1, T1, Fluent2, T2),                               %! <<<<<
    not_stoppedIn(T1, Fluent1, T2).


% TODO another new axiom approach -- holdsAt/3 (different /3)
% TODO - third parameter is exact duration (set Duration as >= something to get minimum duration)
or_holdsAt(Fluent, T, Duration) :-
    Duration .>. 0,
    T .=. Duration,                                           %! <<<<<
    T .>=. 0,
    max_time(T3), T .=<. T3,                                             %! <<<<<
    initiallyP(Fluent),
    not_stoppedIn(0, Fluent, T).
or_holdsAt(Fluent, T2, Duration) :-
    Duration .>. 0,
    T1 .>. 0, T1 .<. T2,                                                %! <<<<<
    max_time(T3), T2 .=<. T3,                                            %! <<<<<
    T2 .=. T1 + Duration,                                           %! <<<<<
    can_initiates(Event, Fluent),                                       %! <<<<<
    happens(Event, T1),                                                 %! <<<<<
    initiates(Event, Fluent, T1),
    not_stoppedIn(T1, Fluent, T2).

% TODO another new axiom approach -- not_holdsAt/3 (different /3)
% TODO - third parameter is minimum duration (set Duration as >= something to get minimum duration)
or_not_holdsAt(Fluent, T, Duration) :-
    Duration .>. 0,
    T .=. Duration,                                           %! <<<<<
    T .>=. 0,
    max_time(T3), T .=<. T3,
    initiallyN(Fluent),
    not_startedIn(0, Fluent, T).
or_not_holdsAt(Fluent, T2, Duration) :-
    Duration .>. 0,
    T1 .>. 0, T1 .<. T2,                                                %! <<<<<
    max_time(T3), T2 .=<. T3,                                            %! <<<<<
    T2 .=. T1 + Duration,                                           %! <<<<<
    can_terminates(Event, Fluent),                                       %! <<<<<
    happens(Event, T1),                                                 %! <<<<<
    terminates(Event, Fluent, T1),
    not_startedIn(T1, Fluent, T2).


% TODO NEW AXIOM
% doing separate instances for each EndEvent to avoid a slowdown 
%or_happens(EndEvent, T2) :-
%    can_selfend_trajectory(EndEvent),
%    T1 .>. 0, T1 .<. T2,                                                
%    max_time(T3), T2 .=<. T3,                                            
%    can_selfend_trajectory(Fluent1, T1, EndEvent, T2),                  
%    can_initiates(Event, Fluent1),                                      
%    happens(Event, T1),                                                 
%    initiates(Event, Fluent1, T1),
%    selfend_trajectory(Fluent1, T1, EndEvent, T2),
%    not_stoppedIn(T1, Fluent1, T2).
%    not not_holdsAt(Fluent2, T2).


%% BEC6 - holdsAt(f,t)
or_holdsAt(Fluent, T2) :-
    T1 .>. 0, T1 .<. T2,                                                %! <<<<<
    max_time(T3), T2 .=<. T3,                                            %! <<<<<
    can_initiates(Event, Fluent),                                       %! <<<<<
    happens(Event, T1),                                                 %! <<<<<
    initiates(Event, Fluent, T1),
    not_stoppedIn(T1, Fluent, T2).
%    not not_holdsAt(Fluent, T).


%% BEC5 - not holdsAt(f,t)
or_not_holdsAt(Fluent, T) :-
    T .>=. 0,
    max_time(T3), T .=<. T3,
    initiallyN(Fluent),
    not_startedIn(0, Fluent, T).
%    not holdsAt(Fluent, T).


%% BEC7 - not holdsAt(f,t)
or_not_holdsAt(Fluent, T2) :-
    T1 .>. 0,
    T1 .<. T2,                                                          %! <<<<<
    max_time(T3), T2 .=<. T3,
    can_terminates(Event, Fluent),                                      %! <<<<<
    happens(Event, T1),                                                 %! <<<<<
    terminates(Event, Fluent, T1),
    not_startedIn(T1, Fluent, T2).
%    not holdsAt(Fluent, T2).


%% Helper for BEC1                                              %! <<<<<
or_not_stoppedIn(T1, Fluent, T2) :-
    %T1 .>=. 0,                                                         %! <<<<<
    %max_time(T3), T2 .=<. T3,
    T1 .=<. T2,                                                          %! <<<<<
    %not_terminated(Fluent, T1, T2),
    not_interrupted(terminates, Fluent, T1, T2),
    %not_released(Fluent, T1, T2).
    not_interrupted(releases, Fluent, T1, T2).


%% Helper for BEC2                                             %! <<<<<
or_not_startedIn(T1, Fluent, T2) :-
    %T1 .>=. 0,                                                         %! <<<<<
    %max_time(T3), T2 .=<. T3,
    T1 .=<. T2,                                                          %! <<<<<
    %not_initiated(Fluent, T1, T2),
    not_interrupted(initiates, Fluent, T1, T2),
    %not_released(Fluent, T1, T2).
    not_interrupted(releases, Fluent, T1, T2).



%//%% Potentially useful -- not_stoppedIn which excules an event (to maybe avoid loops)
%//can_terminatesOrReleasesExcluded(E, Fluent, Excl) :- 
%//    can_terminatesOrReleases(E, Fluent),
%//    E .<>. Excl.
%//not_stoppedInExcl(T1, Fluent, T2, ExclEvent) :-
%//    max_time(T3), T2 .=<. T3,
%//    findall(E, can_terminatesOrReleasesExcluded(E, Fluent, ExclEvent), EventList),
%//    not_terminated(Fluent, EventList, T1, T2),
%//    not_released(Fluent, EventList, T1, T2).


can_interrupt(initiates, E, Fluent) :-
    can_initiates(E, Fluent).
can_interrupt(terminates, E, Fluent) :-
    can_terminates(E, Fluent).
can_interrupt(releases, E, Fluent) :-
    can_releases(E, Fluent).

interrupts(initiates, E, F, T) :-
    initiates(E, F, T).
interrupts(terminates, E, F, T) :-
    terminates(E, F, T).
interrupts(releases, E, F, T) :-
    releases(E, F, T).

% succeds if the variable is a non-infinite interval (needs to have both bounds) 
%is_interval(X) :- inf(X, Xinf), sup(X, Xsup), Xinf .<>. Xsup.   % TODO issues with "proved(X)" remembering the wrong things
is_interval(Xinf, Xsup) :- Xinf .<>. Xsup.

% succeds if the variable is a single point (not an interval)
%is_not_interval(X) :- inf(X, Xinf), sup(X, Xsup), Xinf .=. Xsup.   % TODO issues with "proved(X)" remembering the wrong things
is_not_interval(Xinf, Xsup) :- Xinf .=. Xsup.

% succeds if X and Y have an intersection as intervals (overlap)
%have_intersection(X, Y) :- inf(X, Xinf), sup(X, Xsup), inf(Y, Yinf), sup(Y, Ysup), Xinf .=<. Yinf, Xsup .=<. Yinf.  % TODO sup/inf dont give info about equality % TODO issues with "proved(X)" remembering the wrong things
%have_intersection(X, Y) :- inf(X, Xinf), sup(X, Xsup), inf(Y, Yinf), sup(Y, Ysup), Yinf .=<. Xinf, Ysup .=<. Xinf. 
have_intersection(Xinf, Xsup, Yinf, Ysup) :- Xinf .=<. Yinf, Xsup .=<. Yinf.
have_intersection(Xinf, Xsup, Yinf, Ysup) :- Yinf .=<. Xinf, Ysup .=<. Xinf.

% succeds if X and Y have no intersection as intervals (no overlap)
%no_intersection(X, Y) :- sup(X, Xsup), inf(Y, Yinf), Xsup .<. Yinf.     % TODO sup/inf dont give info about equality % TODO issues with "proved(X)" remembering the wrong things
%no_intersection(X, Y) :- inf(X, Xinf), sup(Y, Ysup), Ysup .<. Xinf. 
no_intersection(Xinf, Xsup, Yinf, Ysup) :- Xsup .<. Yinf.
no_intersection(Xinf, Xsup, Yinf, Ysup) :- Ysup .<. Xinf.

% configurable rule that can handle all three types of fluent interruptions (to avoid duplicit code)
% Type_TermInitRel = initiates / terminates / releases
%
% also tries to better deal with different types of calls in regards to T1 and T2
%   1) if both T1 and T2 are points (not intervals), then everything is easy
%   2) if one is an interval and the other a point, then there cannot be any changes to he inner bound -- event more inner than the bound means failure (not moving of the bound!) other events mean adjusting the outer bound
%   3) if both are intervals without an intersection, then its similar to the previous one (events in between the intervals mean fail and should not adjust the inner bounds, other events adjust the outer bounds)
%   4) if both are intervals with an intersection, then everything gets complicated and no tricks are possible 
not_interrupted(Type_TermInitRel, Fluent, T1, T2) :- 
    findall(E, can_interrupt(Type_TermInitRel, E, Fluent), EventList),
    not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2).

not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_1(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_2a(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_2b(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_3(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_4(Type_TermInitRel, Fluent, EventList, T1, T2).


% version 1
not_interrupted_1(Type_TermInitRel, Fluent, EventList, T1, T2) :-
    % is_not_interval(T1), is_not_interval(T2), % TODO
    inf(T1, T1inf), sup(T1, T1sup), is_not_interval(T1inf, T1sup),
    inf(T2, T2inf), sup(T2, T2sup), is_not_interval(T2inf, T2sup),
    not_interrupted_1_fail(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_1_fail(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_1_fail(Type_TermInitRel, H, Fluent, T, T1, T2),List),    % TODO the first match could fail the whole thing to be more efficient (or maybe want the lowest T?)
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_1_fail(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_1_fail(Type_TermInitRel, _, [], _, _).
interrupt_1_fail(Type_TermInitRel, E, F, T, T1, T2) :-  % finding any T means we should fail
    T .>. T1,
    T .<. T2,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).


% version 2a
not_interrupted_2a(Type_TermInitRel, Fluent, EventList, T1, T2) :-
    % is_interval(T1), is_not_interval(T2), % TODO
    inf(T1, T1inf), sup(T1, T1sup), is_interval(T1inf, T1sup),
    inf(T2, T2inf), sup(T2, T2sup), is_not_interval(T2inf, T2sup),
    not_interrupted_2a_fail(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_2a_adjust_eq(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_2a_adjust_gt(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_2a_fail(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2a_fail(Type_TermInitRel, H, Fluent, T, T1, T2),List),    % TODO the first match could fail the whole thing to be more efficient (or maybe want the lowest T?)
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_2a_fail(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_2a_fail(Type_TermInitRel, _, [], _, _).
not_interrupted_2a_adjust_eq(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2a_adjust_eq(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_2a_adjust_eq(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_2a_adjust_eq(Type_TermInitRel, _, [], _, _).
not_interrupted_2a_adjust_gt(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2a_adjust_gt(Type_TermInitRel, H, Fluent, T, T1, T2),List),   % TODO we are only interested in the lowest T, could make findall search more efficient
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_2a_adjust_gt(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_2a_adjust_gt(Type_TermInitRel, _, [], _, _).
interrupt_2a_fail(Type_TermInitRel, E, F, T, T1, T2) :-    % finding a T smaller than upper bound of T1 means we should fail
    T .<. T2,
    sup(T1,T1sup), T .>. T1sup,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).
interrupt_2a_adjust_eq(Type_TermInitRel, E, F, T, T1, T2) :- % checking for a T exactly equal to the upper bound of T1 helps with finding maximum T's (instead of just chekcing .=<.)
    T .<. T2,
    sup(T1,T1sup), T .=. T1sup,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).
interrupt_2a_adjust_gt(Type_TermInitRel, E, F, T, T1, T2) :-   % finding a T smaller than upper bound of T1 means we should adjust the lower bound of T1
    T .<. T2,
    sup(T1,T1sup), T .<. T1sup,
    inf(T1,T1inf), T .>. T1inf,   % always has to be bigger than the inf
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).


% version 2b
not_interrupted_2b(Type_TermInitRel, Fluent, EventList, T1, T2) :-
    % is_not_interval(T1), is_interval(T2), % TODO
    inf(T1, T1inf), sup(T1, T1sup), is_not_interval(T1inf, T1sup),
    inf(T2, T2inf), sup(T2, T2sup), is_interval(T2inf, T2sup),
    not_interrupted_2b_fail(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_2b_adjust_eq(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_2b_adjust_gt(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_2b_fail(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2b_fail(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_2b_fail(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_2b_fail(Type_TermInitRel, _, [], _, _).
not_interrupted_2b_adjust_eq(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2b_adjust_eq(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_2b_adjust_eq(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_2b_adjust_eq(Type_TermInitRel, _, [], _, _).
not_interrupted_2b_adjust_gt(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2b_adjust_gt(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_2b_adjust_gt(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_2b_adjust_gt(Type_TermInitRel, _, [], _, _).
interrupt_2b_fail(Type_TermInitRel, E, F, T, T1, T2) :-    % finding a T smaller than lower bound of T2 means we should fail
    T .>. T1,
    inf(T2,T2inf), T .<. T2inf,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).
interrupt_2b_adjust_eq(Type_TermInitRel, E, F, T, T1, T2) :- % checking for a T exactly equal to the lower bound of T2 helps with finding minimum T's (instead of just chekcing .>=.)
    T .>. T1,
    inf(T2,T2inf), T .=. T2inf,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).
interrupt_2b_adjust_gt(Type_TermInitRel, E, F, T, T1, T2) :-   % finding a T bigger than lower bound of T2 means we should adjust the upper bound of T2
    T .>. T1,
    inf(T2,T2inf), T .>. T2inf,
    sup(T2,T2sup), T .<. T2sup,   % always has to be smaller than the sup
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).


% version 3
not_interrupted_3(Type_TermInitRel, Fluent, EventList, T1, T2) :-
    % is_interval(T1), is_interval(T2), % TODO
    % no_intersection(T1, T2), % TODO
    inf(T1, T1inf), sup(T1, T1sup), is_interval(T1inf, T1sup),
    inf(T2, T2inf), sup(T2, T2sup), is_interval(T2inf, T2sup),
    no_intersection(T1inf, T1sup, T2inf, T2sup),
    not_interrupted_3_fail(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_3_adjust_eq_a(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_3_adjust_eq_b(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_3_adjust_gt(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_3_fail(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_3_fail(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_3_fail(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_3_fail(Type_TermInitRel, _, [], _, _).
not_interrupted_3_adjust_eq_a(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_3_adjust_eq_a(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_3_adjust_eq_a(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_3_adjust_eq_a(Type_TermInitRel, _, [], _, _).
not_interrupted_3_adjust_eq_b(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_3_adjust_eq_b(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_3_adjust_eq_b(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_3_adjust_eq_b(Type_TermInitRel, _, [], _, _).
not_interrupted_3_adjust_gt_a(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_3_adjust_gt_a(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_3_adjust_gt_a(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_3_adjust_gt_a(Type_TermInitRel, _, [], _, _).
not_interrupted_3_adjust_gt_b(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_3_adjust_gt_b(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_3_adjust_gt_b(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_3_adjust_gt_b(Type_TermInitRel, _, [], _, _).
interrupt_3_fail(Type_TermInitRel, E, F, T, T1, T2) :-    % finding a T bigger than the upper bound of T1 and smaller than lower bound of T2 means we should fail
    sup(T1,T1sup), T .>. T1sup,
    inf(T2,T2inf), T .<. T2inf,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).
interrupt_3_adjust_eq_a(Type_TermInitRel, E, F, T, T1, T2) :- % checking for a T exactly equal to the upper bound of T1 helps with finding maximum T's (instead of just chekcing .=<.)
    T .<. T2,
    sup(T1,T1sup), T .=. T1sup,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).
interrupt_3_adjust_eq_b(Type_TermInitRel, E, F, T, T1, T2) :- % checking for a T exactly equal to the lower bound of T2 helps with finding minimum T's (instead of just chekcing .>=.)
    T .>. T1,
    inf(T2,T2inf), T .=. T2inf,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).
interrupt_3_adjust_gt_a(Type_TermInitRel, E, F, T, T1, T2) :-   % finding a T smaller than upper bound of T1 means we should adjust the lower bound of T1
    T .<. T2,
    sup(T1,T1sup), T .<. T1sup,
    inf(T1,T1inf), T .>. T1inf,   % always has to be bigger than the inf
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).
interrupt_3_adjust_gt_b(Type_TermInitRel, E, F, T, T1, T2) :-   % finding a T bigger than lower bound of T2 means we should adjust the upper bound of T2
    T .>. T1,
    inf(T2,T2inf), T .>. T2inf,
    sup(T2,T2sup), T .<. T2sup,   % always has to be smaller than the sup
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).


% version 4     % TODO maybe can do more fancy reasoning regarding how big the intersection is etc...
not_interrupted_4(Type_TermInitRel, Fluent, EventList, T1, T2) :-
    % is_interval(T1), is_interval(T2), % TODO
    % have_intersection(T1, T2), % TODO
    inf(T1, T1inf), sup(T1, T1sup), is_interval(T1inf, T1sup),
    inf(T2, T2inf), sup(T2, T2sup), is_interval(T2inf, T2sup),
    have_intersection(T1inf, T1sup, T2inf, T2sup),
    not_interrupted_4_adjust(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_4_adjust(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_4_adjust(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_4_adjust(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_4_adjust(Type_TermInitRel, _, [], _, _).
interrupt_4_adjust(Type_TermInitRel, E, F, T, T1, T2) :-
    T .>. T1,
    T .<. T2,
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).



% check that all intervals/values of T's do not permit any values inside of the (T1, T2) interval (which can both also be intervals...)
% TODO this might be doable in the interrupt_fail/interrupt_fail_adjust_* inside of findalls, but theres some subtelty to it due to interval reasoning... TODO 
all_entirely_outside_of_interval([H|T], T1, T2) :- sup(H, Hsup), Hsup .=<. T1, all_entirely_outside_of_interval(T, T1, T2). %! <<<<<
all_entirely_outside_of_interval([H|T], T1, T2) :- inf(H, Hinf), Hinf .>=. T2, all_entirely_outside_of_interval(T, T1, T2). %! <<<<<
all_entirely_outside_of_interval([], _, _).