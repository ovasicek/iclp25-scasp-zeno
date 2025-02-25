%% BEC1 - StoppedIn(t1,f,t2)
stoppedIn(T1, Fluent, T2) :-
    T1 .<. T, T .<. T2,
    can_terminates(Event, Fluent),
    happens(Event, T),
    terminates(Event, Fluent, T).

%% BEC4 - holdsAt(f,t)
holdsAt(Fluent, T) :-
    T .>=. 0, max_time(TMax), T .=<. TMax,
    initiallyP(Fluent),
    not_stoppedIn(0, Fluent, T).

%% BEC6 - HoldsAt(f,t)
holdsAt(Fluent, T) :-
    T1 .<. T, max_time(TMax), T .=<. TMax,
    can_initiates(Event, Fluent),
    happens(Event, T1),
    initiates(Event, Fluent, T1),
    not_stoppedIn(T1, Fluent, T).


%% Helper for BEC1
not_stoppedIn(T1, Fluent, T2) :-
    T1 .=<. T2,
    findall(E, can_terminates(E, Fluent), EventList),
    not_terminated(Fluent, EventList, T1, T2).

not_terminated(_, [], _, _).
not_terminated(Fluent, [H|X], T1, T2) :-
    findall(T, term(H, Fluent, T, T1, T2),List),
    no_terminate(List, T1, T2),
    not_terminated(Fluent, X, T1, T2).

term(E, F, T, T1, T2) :-
    can_terminates(E, F),
    T .>. T1, T .<. T2,
    happens(E, T),
    terminates(E, F, T).

no_terminate([], _, _).
no_terminate([H|T], T1, T2) :- sup(H, Hsup), Hsup .=<. T1, no_terminate(T, T1, T2).
no_terminate([H|T], T1, T2) :- inf(H, Hinf), Hinf .>=. T2, no_terminate(T, T1, T2).