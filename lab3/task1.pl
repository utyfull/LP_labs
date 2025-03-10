% ----------------------------------------------
% Начальное и конечное состояние
% ----------------------------------------------
initial_state(state(left,left,left,left)).
goal_state(state(right,right,right,right)).

% ----------------------------------------------
% Проверка безопасности состояния
% ----------------------------------------------
safe(state(F,W,G,C)) :-
    \+ (W = G, F \= W),
    \+ (G = C, F \= G).

% ----------------------------------------------
% Вспомогательный предикат для смены стороны
% ----------------------------------------------
opposite(left, right).
opposite(right, left).

% Фермер плывёт один
farmer_move(state(F,W,G,C), state(F2,W,G,C)) :-
    opposite(F,F2),
    safe(state(F2,W,G,C)).

% Фермер везёт волка
farmer_move(state(F,W,G,C), state(F2,W2,G,C)) :-
    W = F,
    opposite(F,F2),
    W2 = F2,
    safe(state(F2,W2,G,C)).

% Фермер везёт козу
farmer_move(state(F,W,G,C), state(F2,W,G2,C)) :-
    G = F,
    opposite(F,F2),
    G2 = F2,
    safe(state(F2,W,G2,C)).

% Фермер везёт капусту
farmer_move(state(F,W,G,C), state(F2,W,G,C2)) :-
    C = F,
    opposite(F,F2),
    C2 = F2,
    safe(state(F2,W,G,C2)).

% ----------------------------------------------
% Поиск в глубину (DFS)
% ----------------------------------------------
solve_dfs :-
    initial_state(Start),
    goal_state(Goal),
    dfs([Start], Goal, Path),
    print_solution(Path).

dfs(Path, Goal, Path) :-
    last(Path,Goal).
dfs(Path, Goal, Result) :-
    last(Path,Current),
    farmer_move(Current,Next),
    \+ member(Next,Path),
    append(Path,[Next],NewPath),
    dfs(NewPath, Goal, Result).

% ----------------------------------------------
% Поиск в ширину (BFS)
% ----------------------------------------------
solve_bfs :-
    initial_state(Start),
    goal_state(Goal),
    bfs([[Start]], Goal, Path),
    print_solution(Path).

bfs([Path|_], Goal, Path) :-
    last(Path,Goal).
bfs([Path|OtherPaths], Goal, Result) :-
    last(Path,Current),
    findall(NextPath,
            ( farmer_move(Current,Next),
              \+ member(Next,Path),
              append(Path,[Next],NextPath)
            ),
            NextPaths),
    append(OtherPaths, NextPaths, NewPaths),
    bfs(NewPaths, Goal, Result).

% ----------------------------------------------
% Поиск с итерационным погружением (IDFS)
% ----------------------------------------------
% Идея итерационного поиска в глубину: мы пытаемся запускать поиск в глубину
% с ограничением глубины, увеличивая ограничение до тех пор, пока не найдём решение.

solve_idfs :-
    initial_state(Start),
    goal_state(Goal),
    between(1,100,DepthLimit),
    depth_limited_search([Start], Goal, DepthLimit, Path),
    print_solution(Path),
    !.

depth_limited_search(Path,Goal,_,Path) :-
    last(Path,Goal).
depth_limited_search(Path,Goal,DepthLimit,Result) :-
    DepthLimit > 0,
    last(Path,Current),
    farmer_move(Current,Next),
    \+ member(Next,Path),
    NewDepthLimit is DepthLimit - 1,
    append(Path,[Next],NewPath),
    depth_limited_search(NewPath,Goal,NewDepthLimit,Result).

% ----------------------------------------------
% Вывод решения
% ----------------------------------------------
print_solution(Path) :-
    write('Solution path:'), nl,
    print_states(Path).

print_states([]).
print_states([S|Rest]) :-
    write(S), nl,
    print_states(Rest).
