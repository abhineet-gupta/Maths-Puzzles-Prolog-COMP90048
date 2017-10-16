/* 
Author   : Abhineet Gupta
Origin   : Semester 2, 2017; Project 2 of COMP90048
Purpose  : Solving a maths puzzle via constraint logic programming.

Description: A maths puzzle in the form of a square grid of squares...
...is provided. The grid could be 2x2, 3x3 or 4x4.
The puzzle has the following constraints:
    1) Barring the column and row headers, each of the squares...
        ...must be filled with a digit 1-9 with a unique row and column...
    2) Diagonal contains the same value
    3) heading of each row and column is either the sum or product of...
        ...its values.

The puzzle is supplied as a list of lists and visualised as follows:
---------------------------------------------------------
|           Puzzle             |         Solution        |
---------------------------------------------------------
        14 | 10 | 35 |                 | 14 |10 | 35 |
    14 |   |    |    |              14 | 7  | 2 | 1  | 
    15 |   |    |    |              15 | 3  | 7 | 5  |
    28 |   |  1 |    |              28 | 4  | 1 | 7  |

The approach taken to solve this puzzle was:
    - ensure all lists are of equal length
    - separate the row and column headers from the inner square grid
    - ensure diagonals are the same
    - for each row:
        - ensure all elements are distinct
        - ensure all elements are between 1 and 9
        - check if the row header is either the sum or product of the row
        - if the value of the row header is more than what is possible...
            ...for the sum of the row's digits, only check for it being...
            ...the product. This saves significant time.

Once all these constaints are expressed, only ONE set of numbers will...
...satisfy them and that will be presented as the solution.
*/

% Library for constraint programming functions e.g. all_distinct
:- use_module(library(clpfd)).

% Puzzle is provided as a list of lists (rows)
puzzle_solution(Puzzle) :-
    % # of rows = # of columns
    maplist(same_length(Puzzle), Puzzle),

    % strip headers; Remove inner square
    strip_inner_square(Puzzle, InnerPuzzleRows, ColHead, RowHead),
    
    % diagonal values are the same
    same_diagonals(InnerPuzzleRows),

    % check for row headers to be sum or product
    maplist(sum_or_prod, InnerPuzzleRows, RowHead),

    % transpose the inner puzzle to turn columns to rows
    transpose(InnerPuzzleRows, InnerPuzzleCols),
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
    all_distinct(L),            % distinct values in row
    maplist(between(1,9), L),   % values between 1-9

    % if header value is more than possible for sum, only check for product
    length(L, N),
    ( Val < N*9 ->
        sum_and_prod(L, Val)
    ;
        prod_list(L, Val)
    ).

% test each row's header for both: being a sum or a product
sum_and_prod(L, Val) :-
    sum_list(L, Val);
    prod_list(L, Val).

% Multiply 2 numbers
product(A, B, Y) :- 
    Y is A*B.

% Find product of list elements
prod_list([], 1).
prod_list([L|Ls], P) :- 
    foldl(product, Ls, L, P).
