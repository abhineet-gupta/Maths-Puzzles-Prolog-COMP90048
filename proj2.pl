%  Author   : Abhineet Gupta
%  Origin   : Oct 2017
%  Purpose  : Project 2 of COMP90048: solving maths puzzles via ...
%               constraint logic programming
%
%  Description: 
%   

use_module(library(clpr)).
use_module(library(clpfd)).

puzzle_solution(Puzzle) :-    

    ensure_loaded(library(clpfd)), ensure_loaded(library(clpr)),

    % # of rows = # of columns
    maplist(same_length(Puzzle), Puzzle),

    % strip headers; Remove inner square
    strip_inner_square(Puzzle, InnerPuzzleRows, ColHead, RowHead),
    
    % diagonal values are the same
    same_diagonals(InnerPuzzleRows),

    % all values within each row are unique
    maplist(all_distinct, InnerPuzzleRows),

    % all values in the puzzle between 1 & 9
    append(InnerPuzzleRows, Vs), maplist(between(1,9), Vs),

    % all values within each column are unique
    transpose(InnerPuzzleRows, InnerPuzzleCols), maplist(all_distinct, InnerPuzzleCols),
    
    % check for row headers to be sum or product
    maplist(sum_or_prod, InnerPuzzleRows, RowHead),

    % check for col headers to be sum or product
    maplist(sum_or_prod, InnerPuzzleCols, ColHead).

    
% --------HELPER FUNCTIONS-------------
% Removes row and column headers to leave the inner puzzle
strip_inner_square([[_H|CHead]|Rest], Inner, CHead, RHead) :-
    maplist(remFirstElem, Rest, RHead, Inner).

% removes first element in list
remFirstElem([H|T], H, T).

% check all diagonal values to be the same
same_diagonals([_]).
same_diagonals([H|T]) :-
    [D1|_T1] = H,
    strip_inner_square([H|T], [HI|TI], _, _),
    [D1|_T2] = HI,
    same_diagonals([HI|TI]).

% Check if list elements sum or multipy to a value
sum_or_prod(L, Val) :-
    sum_list(L, Val);
    prod_list(L, Val).

% Find product of list elements
product(A, B, Y) :- Y is A*B.
prod_list([], 1).
prod_list([L|Ls], P) :- foldl(product, Ls, L, P).