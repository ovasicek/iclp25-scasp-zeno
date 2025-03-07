% small version:
%   no trajectory related axioms and no releases
%   no new axioms
% and no can_* rules with terminates/initiates before happens in axioms
%   can_* rules and order preserved inside of not_stoppedIn/startedIn so that axioms with initiallyP/N work fine (BEC4/5)
%   this limits the non-termination to other axioms where it is easier to understand/visualize (BEC6/7)

%% BEC1 - StoppedIn(t1,f,t2)
stoppedIn(T1, Fluent, T2) :-
    T1 .<. T, T .<. T2,
    terminates(Event, Fluent, T),
    happens(Event, T).


%% BEC2 - StartedIn(t1,f,t2)
startedIn(T1, Fluent, T2) :-
    T1 .<. T, T .<. T2,
    initiates(Event, Fluent, T),
    happens(Event, T).


%% BEC4 - holdsAt(f,t)
holdsAt(Fluent, T) :-
    T .>=. 0,
    max_time(T3), T .=<. T3,
    initiallyP(Fluent),
    not_stoppedIn(0, Fluent, T).


%% BEC6 - holdsAt(f,t)
holdsAt(Fluent, T2) :-
    T1 .>. 0, T1 .<. T2,
    max_time(T3), T2 .=<. T3,
    initiates(Event, Fluent, T1),
    happens(Event, T1),
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
    terminates(Event, Fluent, T1),
    happens(Event, T1),
    not_startedIn(T1, Fluent, T2).


%% Helper for BEC1
not_stoppedIn(T1, Fluent, T2) :-
    T1 .=<. T2,
    findall(E, findall_can_terminates(E, Fluent, T1, T2), EventList),
    not_terminated(Fluent, EventList, T1, T2).

findall_can_terminates(E, F, T1, T2) :- 
    T .>. T1, T .<. T2,
    can_terminates(E, F, T).

not_terminated(_, [], _, _).
not_terminated(Fluent, [H|X], T1, T2) :-
    findall(T, terminated(H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_terminated(Fluent, X, T1, T2).

terminated(E, F, T, T1, T2) :-
    T .>. T1, T .<. T2,
    can_terminates(E, F, T),
    happens(E, T),
    terminates(E, F, T).


%% Helper for BEC2
not_startedIn(T1, Fluent, T2) :-
    T1 .=<. T2,
    findall(E, findall_can_initiates(E, Fluent, T1, T2), EventList),
    not_initiated(Fluent, EventList, T1, T2).

findall_can_initiates(E, F, T1, T2) :- 
    T .>. T1, T .<. T2,
    can_initiates(E, F, T).

not_initiated(_, [], _, _).
not_initiated(Fluent, [H|X], T1, T2) :-
    findall(T, initiated(H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_initiated(Fluent, X, T1, T2).

initiated(E, F, T, T1, T2) :-
    T .>. T1, T .<. T2,
    can_initiates(E, F, T),
    happens(E, T),
    terminates(E, F, T).


% check that all intervals/values of T's do not permit any values inside of the (T1, T2) interval (which can both also be intervals...)
all_entirely_outside_of_interval([H|T], T1, T2) :- sup(H, Hsup), Hsup .=<. T1, all_entirely_outside_of_interval(T, T1, T2).
all_entirely_outside_of_interval([H|T], T1, T2) :- inf(H, Hinf), Hinf .>=. T2, all_entirely_outside_of_interval(T, T1, T2).
all_entirely_outside_of_interval([], _, _).