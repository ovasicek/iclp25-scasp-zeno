%% BEC1 - StoppedIn(t1,f,t2)
stoppedIn(T1, Fluent, T2) :-
    T1 .<. T, T .<. T2,
    can_terminates(Event, Fluent, T),
    happens(Event, T),
    terminates(Event, Fluent, T).

stoppedIn(T1, Fluent, T2) :-
    T1 .<. T, T .<. T2,
    can_releases(Event, Fluent, T),
    happens(Event, T),
    releases(Event, Fluent, T).


%% BEC2 - StartedIn(t1,f,t2)
startedIn(T1, Fluent, T2) :-
    T1 .<. T, T .<. T2,
    can_initiates(Event, Fluent, T),
    happens(Event, T),
    initiates(Event, Fluent, T).
    
startedIn(T1, Fluent, T2) :-
    T1 .<. T, T .<. T2,
    can_releases(Event, Fluent, T),
    happens(Event, T),
    releases(Event, Fluent, T).


%% BEC4 - holdsAt(f,t)
holdsAt(Fluent, T) :-
    T .>=. 0,
    max_time(T3), T .=<. T3,
    initiallyP(Fluent),
    not_stoppedIn(0, Fluent, T).


%% BEC3 - holdsAt(f,t)
holdsAt(Fluent2, T2) :-
    T1 .>. 0, T1 .<. T2,
    max_time(T3), T2 .=<. T3,
    can_trajectory(Fluent1, T1, Fluent2, T2),
    can_initiates(Event, Fluent1, T1),
    happens(Event, T1),
    initiates(Event, Fluent1, T1),
    trajectory(Fluent1, T1, Fluent2, T2),
    not_stoppedIn(T1, Fluent1, T2).


% new axiom approach -- holdsAt/3
% - third parameter Fluent1 tries to say to only ever consider a specified trajectory
holdsAt(Fluent2, T2, Fluent1) :-
    T1 .>. 0, T1 .<. T2,
    max_time(T3), T2 .=<. T3,
    can_trajectory(Fluent1, T1, Fluent2, T2),
    can_initiates(Event, Fluent1, T1),
    happens(Event, T1),
    initiates(Event, Fluent1, T1),
    trajectory(Fluent1, T1, Fluent2, T2),
    not_stoppedIn(T1, Fluent1, T2).


% new axiom approach -- holdsAt/4
% - adds a fourth parameter to the holdsAt/3 right above
% - fourth parameter is exact duration (set Duration as >= something to get minimum duration)
holdsAt(Fluent2, T2, Fluent1, Duration) :-
    Duration .>. 0,
    T1 .>. 0, T1 .<. T2,
    max_time(T3), T2 .=<. T3,
    T2 .=. T1 + Duration,
    can_trajectory(Fluent1, T1, Fluent2, T2),
    can_initiates(Event, Fluent1, T1),
    happens(Event, T1),
    initiates(Event, Fluent1, T1),
    trajectory(Fluent1, T1, Fluent2, T2),
    not_stoppedIn(T1, Fluent1, T2).


% new axiom approach -- holdsAt/3 (different /3)
% - third parameter is exact duration (set Duration as >= something to get minimum duration)
holdsAt(Fluent, T, Duration) :-
    Duration .>. 0,
    T .=. Duration,
    T .>=. 0,
    max_time(T3), T .=<. T3,
    initiallyP(Fluent),
    not_stoppedIn(0, Fluent, T).
holdsAt(Fluent, T2, Duration) :-
    Duration .>. 0,
    T1 .>. 0, T1 .<. T2,
    max_time(T3), T2 .=<. T3,
    T2 .=. T1 + Duration,
    can_initiates(Event, Fluent, T1),
    happens(Event, T1),
    initiates(Event, Fluent, T1),
    not_stoppedIn(T1, Fluent, T2).


% new axiom approach -- not_holdsAt/3 (different /3)
% - third parameter is exact duration (set Duration as >= something to get minimum duration)
not_holdsAt(Fluent, T, Duration) :-
    Duration .>. 0,
    T .=. Duration,
    T .>=. 0,
    max_time(T3), T .=<. T3,
    initiallyN(Fluent),
    not_startedIn(0, Fluent, T).
not_holdsAt(Fluent, T2, Duration) :-
    Duration .>. 0,
    T1 .>. 0, T1 .<. T2,
    max_time(T3), T2 .=<. T3,
    T2 .=. T1 + Duration,
    can_terminates(Event, Fluent, T1),
    happens(Event, T1),
    terminates(Event, Fluent, T1),
    not_startedIn(T1, Fluent, T2).


%% BEC6 - holdsAt(f,t)
holdsAt(Fluent, T2) :-
    T1 .>. 0, T1 .<. T2,
    max_time(T3), T2 .=<. T3,
    can_initiates(Event, Fluent, T1),
    happens(Event, T1),
    initiates(Event, Fluent, T1),
    not_stoppedIn(T1, Fluent, T2).


%% BEC5 - not holdsAt(f,t)
not_holdsAt(Fluent, T) :-
    T .>=. 0,
    max_time(T3), T .=<. T3,
    initiallyN(Fluent),
    not_startedIn(0, Fluent, T).


%% BEC7 - not holdsAt(f,t)
not_holdsAt(Fluent, T2) :-
    T1 .>. 0,
    T1 .<. T2,
    max_time(T3), T2 .=<. T3,
    can_terminates(Event, Fluent, T1),
    happens(Event, T1),
    terminates(Event, Fluent, T1),
    not_startedIn(T1, Fluent, T2).


%% Helper for BEC1
not_stoppedIn(T1, Fluent, T2) :-
    T1 .=<. T2,
    not_interrupted(terminates, Fluent, T1, T2),
    not_interrupted(releases, Fluent, T1, T2).


%% Helper for BEC2
not_startedIn(T1, Fluent, T2) :-
    T1 .=<. T2,
    not_interrupted(initiates, Fluent, T1, T2),
    not_interrupted(releases, Fluent, T1, T2).


% configurable rule that can handle all three types of fluent interruptions (to avoid duplicit code)
% Type_TermInitRel = initiates / terminates / releases
not_interrupted(Type_TermInitRel, Fluent, T1, T2) :- 
    findall(E, findall_can_interrupts(Type_TermInitRel, E, Fluent, T1, T2), EventList),
    not_interrupted_(Type_TermInitRel, Fluent, EventList, T1, T2).

findall_can_interrupts(Type_TermInitRel, E, F, T1, T2) :-
    T .>. T1, T .<. T2,
    can_interrupts(Type_TermInitRel, E, F, T).

not_interrupted_(Type_TermInitRel, _, [], _, _).
not_interrupted_(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupted(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_(Type_TermInitRel, Fluent, Tail, T1, T2).

interrupted(Type_TermInitRel, E, F, T, T1, T2) :-
    T .>. T1, T .<. T2,
    can_interrupts(Type_TermInitRel, E, F, T),
    happens(E, T),
    interrupts(Type_TermInitRel, E, F, T).

% other helper predicates
can_interrupts(initiates, E, Fluent, T) :- can_initiates(E, Fluent, T).
can_interrupts(terminates, E, Fluent, T) :- can_terminates(E, Fluent, T).
can_interrupts(releases, E, Fluent, T) :- can_releases(E, Fluent, T).

interrupts(initiates, E, F, T) :- initiates(E, F, T).
interrupts(terminates, E, F, T) :- terminates(E, F, T).
interrupts(releases, E, F, T) :- releases(E, F, T).

% check that all intervals/values of T's do not permit any values inside of the (T1, T2) interval (which can both also be intervals...)
all_entirely_outside_of_interval([H|T], T1, T2) :- sup(H, Hsup), Hsup .=<. T1, all_entirely_outside_of_interval(T, T1, T2).
all_entirely_outside_of_interval([H|T], T1, T2) :- inf(H, Hinf), Hinf .>=. T2, all_entirely_outside_of_interval(T, T1, T2).
all_entirely_outside_of_interval([], _, _).