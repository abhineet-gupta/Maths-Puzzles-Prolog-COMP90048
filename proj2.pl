%  Author   : Abhineet Gupta
%  Origin   : Oct 2017
%  Purpose  : Project 2 of COMP90048: solving maths puzzles via ...
%               constraint logic programming
%
%  Description: 
%   

use_module(library(clpr)).

puzzle_solution(Puzzle) :-
    % # of rows = # of columns
    maplist(same_length(Puzzle), Puzzle),

    % strip headers; Remove inner square
    strip_inner_square(Puzzle, InnerPuzzleRows),

    % all values in the puzzle between 1 & 9
    append(InnerPuzzleRows, Vs), maplist(between(1,9), Vs),

    % all values within each row are unique
    maplist(all_distinct, InnerPuzzleRows),

    % all values within each column are unique
    transpose(InnerPuzzleRows, Columns), maplist(all_distinct, Columns),

    % diagonal values are the same
    same_diagonals(InnerPuzzleRows).

    % check for row headers to be sum or product
    % sum_or_prod()

% --------HELPER FUNCTIONS-------------
% Removes row and column headers to leave the inner puzzle
strip_inner_square([_Header|Rest], Inner) :-
    maplist(remFirstElem, Rest, Inner).

% removes first element in list
remFirstElem([_H|T], T).

% check all diagonal values to be the same
same_diagonals([_]).
same_diagonals([H|T]) :-
    [D1|_T1] = H,
    strip_inner_square([H|T], [HI|TI]),
    [D1|_T2] = HI,
    same_diagonals([HI|TI]).
