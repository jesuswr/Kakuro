:- use_module(library(apply)).
:- use_module(library(clpfd)).
:- use_module(library(aggregate)).

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

print_row([]).
print_row([H|T]) :- var(H), write('_, '), print_row(T). 
print_row([H|T]) :- ground(H), write(H), write(', '), print_row(T). 

print_matrix([]).
print_matrix([H|T]) :- write('['), print_row(H), write(']'), nl, print_matrix(T).





% Chequear que los blank esten en linea
check_direction([], _, _).
check_direction([blank(_,_) | []], _, _).
check_direction([blank(X1, Y1) | [blank(X2, Y2) | Blanks]], DX, DY) :-
    X2 is X1 + DX,
    Y2 is Y1 + DY,
    check_direction([blank(X2, Y2) | Blanks], DX, DY).

% Chequear que cada clue este bien (der o abajo), le anado blank(X,Y)
% para que revise que esta justo arriba o a la izq de los blank
down_or_right_aux(clue(X, Y, Sum, Blanks)) :-
    (check_direction([blank(X,Y) | Blanks], 0, 1); 
     check_direction([blank(X,Y) | Blanks], 1, 0)).

% Funcion para revisar que cada clue vaya hacia abajo o hacia la derecha
down_or_right([]).
down_or_right([Clue | Clues]) :-
    down_or_right_aux(Clue),
    down_or_right(Clues).

% funcion para sacar las coordenadas de la clue
get_xy(clue(X,Y,_,_), xy(X,Y)).

% funcion que revisa si no hay mas de 2 clue en una casilla
max_two_clues(Clues) :-
    maplist(get_xy, Clues, XYs),
    aggregate(max(C,E),aggregate(count,member(E, XYs),C),max(CNT, _)),
    CNT =< 2.

% Funcion para revisar que todo lo que necesita cumplir las clues este bien
valid_clues(Clues) :-
    down_or_right(Clues),
    max_two_clues(Clues).





% Transformar los Blanks a un arreglo de var/ground de lo que sacamos
% de la matriz
get([], _, []).
get([blank(X, Y) | Blanks], Mat, L) :-
    get(Blanks, Mat, L1),
    at(Mat, Y, X, RET),
    L = [RET | L1].

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

% Resolver un clue
solve(clue(_, _, Sum, Blanks), Mat) :- 
    get(Blanks, Mat, L),
    valid_vals(L, Sum),
    all_distinct(L).

% Resolver muchos clues
solve_clues([],_).
solve_clues([Clue | Clues], Mat) :-
    solve_clues(Clues, Mat),
    solve(Clue, Mat).





% Funcion para sacar los valores de la matriz hacia la solucion
solution(_, _, [], []).
solution(_, Y, [[] | K], Solution) :-
    NewY is Y+1,
    solution(1, NewY, K, Solution).
solution(X, Y, [[L | Ls] | K], Solution) :-
    var(L),
    NewX is X + 1,
    solution(NewX, Y, [Ls | K], Solution).
solution(X, Y, [[L | Ls] | K], NewSolution) :-
    ground(L),
    NewX is X + 1,
    solution(NewX, Y, [Ls | K], Solution),
    NewSolution = [fill(blank(X,Y), L) | Solution].





% [clue(1,1,3, [blank(1,2), blank(1,3)]), clue(2,1,8, [blank(2,2), blank(2,3)])]
valid(kakuro(Clues), Solution) :-
    valid_clues(Clues),
    matrix(Mat),
    solve_clues(Clues, Mat),
    solution(1,1, Mat, Solution),
    print_matrix(Mat).





readKakuro(Kakuro) :-
    seeing(Old),
    write('Escriba el nombre del archivo:'),
    nl,
    read(New),
    see(New),
    read(Kakuro),
    seen,
    see(Old).