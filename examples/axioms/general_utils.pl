% ----------------------------------------------------------------------------------------------------------------------
% utils                         ----------------------------------------------------------------------------------------

min(A,B,A) :- A .=<. B.
min(A,B,B) :- B .<. A.

max(A,B,A) :- A .>=. B.
max(A,B,B) :- B .>. A.

% prove that E did not happen in a time interval (excluding the edges)
not_happensIn(E, T1, T2) :-
    findall(T, not_happensInFindall(E, T, T1, T2), List),
    outside(List, T1, T2).

    not_happensInFindall(E, T, T1, T2) :- 
        T .>. T1, T .<. T2,
        happens(E, T).

    outside([H|T], T1, T2) :- sup(H, Hsup), Hsup .=<. T1, outside(T, T1, T2).
    outside([H|T], T1, T2) :- inf(H, Hinf), Hinf .>=. T2, outside(T, T1, T2).
    outside([], _, _).


% prove that E did not happen at T
not_happens(E, T) :-
    not_happensInInc(E, T, T).


% prove that E did not happen in a time interval (including the edges)
not_happensInInc(E, T1, T2) :-
    findall(T, not_happensInIncFindall(E, T, T1, T2), List),
    outsideInc(List, T1, T2).

    not_happensInIncFindall(E, T, T1, T2) :- 
        T .>=. T1, T .=<. T2,
        happens(E, T).

    outsideInc([H|T], T1, T2) :- sup(H, Hsup), Hsup .<. T1, outsideInc(T, T1, T2).
    outsideInc([H|T], T1, T2) :- inf(H, Hinf), Hinf .>. T2, outsideInc(T, T1, T2).
    outsideInc([], _, _).
