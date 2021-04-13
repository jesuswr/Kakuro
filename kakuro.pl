:- use_module(library(apply)).
:- use_module(library(clpfd)).
:- use_module(library(aggregate)).
:- use_module(library(lists)).

% Matriz para unificar los valores con las casillas
length_list(N, List) :- length(List, N).
generate_matrix(Cols, Rows, Matrix) :-
    length_list(Rows, Matrix),
    maplist(length_list(Cols), Matrix).

% Acceder a matriz
at(Mat, Row, Col, Val) :- nth1(Row, Mat, ARow), nth1(Col, ARow, Val).

print_row([]).
print_row([H|T]) :- var(H), write('_, '), print_row(T). 
print_row([H|T]) :- ground(H), write(H), write(', '), print_row(T). 

print_matrix([]).
print_matrix([H|T]) :- write('['), print_row(H), write(']'), nl, print_matrix(T).





% Scar Blanks
get_blanks(clue(_,_,_,Blanks), Blanks).

% Sacar la coordenada mas grande de un blank
get_max_xy_blank(blank(X,Y), X) :- X >= Y.
get_max_xy_blank(blank(X,Y), Y) :- Y > X.

% Sacar la coordenada mas grande de los blanks
max_xy(Clues, Max) :-
    maplist(get_blanks, Clues, BlanksAux),
    flatten(BlanksAux, Blanks),
    maplist(get_max_xy_blank, Blanks, L),
    max_list(L, Max).





% Chequear que los blank esten en linea
check_direction([], _, _).
check_direction([blank(_,_) | []], _, _).
check_direction([blank(X1, Y1) | [blank(X2, Y2) | Blanks]], DX, DY) :-
    X2 is X1 + DX,
    Y2 is Y1 + DY,
    check_direction([blank(X2, Y2) | Blanks], DX, DY).

% Chequear que cada clue este bien (der o abajo), le anado blank(X,Y)
% para que revise que esta justo arriba o a la izq de los blank
down_or_right_aux(clue(X, Y, _, Blanks)) :-
    (check_direction([blank(X,Y) | Blanks], 0, 1); 
     check_direction([blank(X,Y) | Blanks], 1, 0)).

% Revisar que cada clue vaya hacia abajo o hacia la derecha
down_or_right([]).
down_or_right([Clue | Clues]) :-
    down_or_right_aux(Clue),
    down_or_right(Clues).

% Sacar las coordenadas de la clue o blank
get_xy_clue(clue(X,Y,_,_), xy(X,Y)).
get_xy_blank(blank(X,Y), xy(X,Y)).

% Revisa si no hay mas de 2 clue en una casilla
max_two_clues(Clues) :-
    maplist(get_xy_clue, Clues, XYs),
    aggregate(max(C,E),aggregate(count,member(E, XYs),C),max(CNT, _)),
    CNT =< 2.

% Ver si los clues y blanks tienen alguna pos en comun
clue_blank_intersect(Clues) :-
    maplist(get_xy_clue, Clues, XYCs),
    maplist(get_blanks, Clues, BlanksAux),
    flatten(BlanksAux, Blanks),
    maplist(get_xy_blank, Blanks, XYBs),
    intersection(XYCs, XYBs, L),
    L \= [].

% Revisar que los X Y de la clue sean >= 1
positive([]).
positive([clue(X, Y, _, _) | Clues]) :-
    X >= 1, Y >= 1,
    positive(Clues).

% Revisar que todo lo que necesita cumplir las clues este bien
valid_clues(Clues) :-
    down_or_right(Clues),
    max_two_clues(Clues),
    not(clue_blank_intersect(Clues)),
    positive(Clues).





% Transformar los Blanks a un arreglo de var/ground de lo que sacamos
% de la matriz
get([], _, []).
get([blank(X, Y) | Blanks], Mat, L) :-
    get(Blanks, Mat, L1),
    at(Mat, Y, X, RET),
    L = [RET | L1].

% Consegir una solucion valida para un segmento
valid_vals([], 0).
valid_vals([9 | Xs], GoalSum) :-
    GoalSum >= 9, 
    NewGoalSum is GoalSum - 9,
    valid_vals(Xs, NewGoalSum).
valid_vals([8 | Xs], GoalSum) :-
    GoalSum >= 8, 
    NewGoalSum is GoalSum - 8,
    valid_vals(Xs, NewGoalSum).
valid_vals([7 | Xs], GoalSum) :-
    GoalSum >= 7, 
    NewGoalSum is GoalSum - 7,
    valid_vals(Xs, NewGoalSum).
valid_vals([6 | Xs], GoalSum) :-
    GoalSum >= 6, 
    NewGoalSum is GoalSum - 6,
    valid_vals(Xs, NewGoalSum).
valid_vals([5 | Xs], GoalSum) :-
    GoalSum >= 5, 
    NewGoalSum is GoalSum - 5,
    valid_vals(Xs, NewGoalSum).
valid_vals([4 | Xs], GoalSum) :-
    GoalSum >= 4, 
    NewGoalSum is GoalSum - 4,
    valid_vals(Xs, NewGoalSum).
valid_vals([3 | Xs], GoalSum) :-
    GoalSum >= 3, 
    NewGoalSum is GoalSum - 3,
    valid_vals(Xs, NewGoalSum).
valid_vals([2 | Xs], GoalSum) :-
    GoalSum >= 2, 
    NewGoalSum is GoalSum - 2,
    valid_vals(Xs, NewGoalSum).
valid_vals([1 | Xs], GoalSum) :-
    GoalSum >= 1, 
    NewGoalSum is GoalSum - 1,
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





% Sacar los valores de la matriz hacia la solucion
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





% Predicado principal
valid(kakuro(Clues), Solution) :-
    valid_clues(Clues),
    max_xy(Clues, Max),
    generate_matrix(Max, Max, Mat),
    solve_clues(Clues, Mat),
    solution(1,1, Mat, Solution),
    print_matrix(Mat),
    !.





% Leer el kakuro
readKakuro(Kakuro) :-
    seeing(Old),
    write('Escriba el nombre del archivo:'),
    nl,
    read(New),
    see(New),
    read(Kakuro),
    seen,
    see(Old).