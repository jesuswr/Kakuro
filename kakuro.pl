:- use_module(library(apply)).
:- use_module(library(clpfd)).

% Matriz para unificar los valores con las casillas
matrix([[_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_]]).

% Matriz chiquita para que no se me pegue xD
matrix_small([[_,_,_], [_,_,_], [_,_,_]]).

% Acceder a matriz
at(Mat, Row, Col, Val) :- nth1(Row, Mat, ARow), nth1(Col, ARow, Val).

% Transformar los Blanks a un arreglo de var/ground de lo que sacamos
% de la matriz
get([], _, []).
get([blank(X, Y) | Blanks], Mat, L) :-
    get(Blanks, Mat, L1),
    at(Mat, Y, X, RET),
    L = [RET | L1].

print_matrix([]).
print_matrix([H|T]) :- write(H), nl, print_matrix(T).

% consegir una solucion valida para un segmento
valid_vals([], 0).
valid_vals([1 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 1,
    valid_vals(Xs, NewGoalSum).
valid_vals([2 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 2,
    valid_vals(Xs, NewGoalSum).
valid_vals([3 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 3,
    valid_vals(Xs, NewGoalSum).
valid_vals([4 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 4,
    valid_vals(Xs, NewGoalSum).
valid_vals([5 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 5,
    valid_vals(Xs, NewGoalSum).
valid_vals([6 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 6,
    valid_vals(Xs, NewGoalSum).
valid_vals([7 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 7,
    valid_vals(Xs, NewGoalSum).
valid_vals([8 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 8,
    valid_vals(Xs, NewGoalSum).
valid_vals([9 | Xs], GoalSum) :- 
    NewGoalSum is GoalSum - 9,
    valid_vals(Xs, NewGoalSum).

% Chequear que los blank esten en linea
check_blanks([], _, _).
check_blanks([blank(_,_) | []], _, _).
check_blanks([blank(X1, Y1) | [blank(X2, Y2) | Blanks]], DX, DY) :-
    X2 is X1 + DX,
    Y2 is Y1 + DY,
    check_blanks([blank(X2, Y2) | Blanks], DX, DY).

% Chequear que cada clue este bien, le anado blank(X,Y) para que revise que 
% esta justo arriba o a la izq
check_clue(clue(X, Y, Sum, Blanks)) :-
    (check_blanks([blank(X,Y) | Blanks], 0, 1) ; check_blanks([blank(X,Y) | Blanks], 1, 0)).

% Resolver un clue
solve(clue(_, _, _, []), _, 0).
solve(clue(_, _, Sum, Blanks), Mat) :- 
    get(Blanks, Mat, L),
    valid_vals(L,Sum),
    all_distinct(L).

% Resolver muchos clues, aqui falta revisar cosas para que sea valido
solve_clues([],_).
solve_clues([Clue | Clues], Mat) :-
    check_clue(Clue),
    solve_clues(Clues, Mat),
    solve(Clue, Mat).



% [clue(1,1,3, [blank(1,1), blank(1,2)]), clue(1,1,3, [blank(2,1), blank(2,2)])]
%valid(kakuro(Clues), Solution) :-
%   matrix_small(Mat),
%
%
