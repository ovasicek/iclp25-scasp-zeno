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
%
% also tries to better deal with different types of calls in regards to T1 and T2
%   1) if both T1 and T2 are points (not intervals), then everything is easy
%   2) if one is an interval and the other a point, then there cannot be any changes to he inner bound -- event more inner than the bound means failure (not moving of the bound!) other events mean adjusting the outer bound
%   3) if both are intervals without an intersection, then its similar to the previous one (events in between the intervals mean fail and should not adjust the inner bounds, other events adjust the outer bounds)
%   4) if both are intervals with an intersection, then everything gets complicated and no tricks are possible 
not_interrupted(Type_TermInitRel, Fluent, T1, T2) :- 
    findall(E, findall_can_interrupts(Type_TermInitRel, E, Fluent, T1, T2), EventList),
    not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2).

findall_can_interrupts(Type_TermInitRel, E, F, T1, T2) :-
    T .>. T1, T .<. T2,
    can_interrupts(Type_TermInitRel, E, F, T).
    
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_1(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_2a(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_2b(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_3(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_N(Type_TermInitRel, Fluent, EventList, T1, T2) :- not_interrupted_4(Type_TermInitRel, Fluent, EventList, T1, T2).


% version 1
not_interrupted_1(Type_TermInitRel, Fluent, EventList, T1, T2) :-
    inf(T1, T1inf), sup(T1, T1sup), is_not_interval(T1inf, T1sup),
    inf(T2, T2inf), sup(T2, T2sup), is_not_interval(T2inf, T2sup),
    not_interrupted_1_fail(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_1_fail(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_1_fail(Type_TermInitRel, H, Fluent, T, T1, T2),List),
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
    inf(T1, T1inf), sup(T1, T1sup), is_interval(T1inf, T1sup),
    inf(T2, T2inf), sup(T2, T2sup), is_not_interval(T2inf, T2sup),
    not_interrupted_2a_fail(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_2a_adjust_eq(Type_TermInitRel, Fluent, EventList, T1, T2),
    not_interrupted_2a_adjust_gt(Type_TermInitRel, Fluent, EventList, T1, T2).
not_interrupted_2a_fail(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2a_fail(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_2a_fail(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_2a_fail(Type_TermInitRel, _, [], _, _).
not_interrupted_2a_adjust_eq(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2a_adjust_eq(Type_TermInitRel, H, Fluent, T, T1, T2),List),
    all_entirely_outside_of_interval(List, T1, T2),
    not_interrupted_2a_adjust_eq(Type_TermInitRel, Fluent, Tail, T1, T2).
not_interrupted_2a_adjust_eq(Type_TermInitRel, _, [], _, _).
not_interrupted_2a_adjust_gt(Type_TermInitRel, Fluent, [H|Tail], T1, T2) :-
    findall(T, interrupt_2a_adjust_gt(Type_TermInitRel, H, Fluent, T, T1, T2),List),
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


% version 4
not_interrupted_4(Type_TermInitRel, Fluent, EventList, T1, T2) :-
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


% other helper predicates
can_interrupts(initiates, E, Fluent, T) :- can_initiates(E, Fluent, T).
can_interrupts(terminates, E, Fluent, T) :- can_terminates(E, Fluent, T).
can_interrupts(releases, E, Fluent, T) :- can_releases(E, Fluent, T).

interrupts(initiates, E, F, T) :- initiates(E, F, T).
interrupts(terminates, E, F, T) :- terminates(E, F, T).
interrupts(releases, E, F, T) :- releases(E, F, T).

% succeds if the variable is a non-infinite interval (needs to have both bounds) 
is_interval(Xinf, Xsup) :- Xinf .<>. Xsup.

% succeds if the variable is a single point (not an interval)
is_not_interval(Xinf, Xsup) :- Xinf .=. Xsup.

% succeds if X and Y have an intersection as intervals (overlap)
have_intersection(Xinf, Xsup, Yinf, Ysup) :- Xinf .=<. Yinf, Xsup .=<. Yinf.
have_intersection(Xinf, Xsup, Yinf, Ysup) :- Yinf .=<. Xinf, Ysup .=<. Xinf.

% succeds if X and Y have no intersection as intervals (no overlap)
no_intersection(Xinf, Xsup, Yinf, Ysup) :- Xsup .<. Yinf.
no_intersection(Xinf, Xsup, Yinf, Ysup) :- Ysup .<. Xinf.

% check that all intervals/values of T's do not permit any values inside of the (T1, T2) interval (which can both also be intervals...)
all_entirely_outside_of_interval([H|T], T1, T2) :- sup(H, Hsup), Hsup .=<. T1, all_entirely_outside_of_interval(T, T1, T2).
all_entirely_outside_of_interval([H|T], T1, T2) :- inf(H, Hinf), Hinf .>=. T2, all_entirely_outside_of_interval(T, T1, T2).
all_entirely_outside_of_interval([], _, _).