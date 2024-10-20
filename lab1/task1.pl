my_length([], 0).
my_length([_ | T], Length) :- 
    my_length(T, TLength), 
    Length is TLength + 1.

remove([H | T], H, T).
remove([H | T1], X, [H | T2]) :- 
    remove(T1, X, T2).

permute([], []).
permute(L, [H | Perm]) :- 
    remove(L, H, L1), 
    permute(L1, Perm).

my_append([], X, X).
my_append([H, T1], Y, [H | T2]) :- 
    my_append(T1, Y, T2).

my_sublist([], _).
my_sublist([H1 | T1], [H2 | T2]) :- 
    H1 == H2, 
    my_sublist(T1, T2); 
    my_sublist([H1 | T1], T2).

my_member(H, [H | _]).
my_member(H, [_ | T]) :- 
    my_member(H, T).


% Реализация задания варианта 17 без использования стандартных предикатов
tail_from_element1(_, [], []) :- !.
tail_from_element1(Elem, [Elem | Tail], Tail) :- !.
tail_from_element1(Elem, [_ | T], ResultTail) :-
    tail_from_element1(Elem, T, ResultTail).

% Релизация с использованием стандартных предикатов
tail_from_element2(Elem, List, Tail) :-
    my_append(_, [Elem | Tail], List).

% Реализация варианта 2 без использования стандартных предикатов
multiply_elements1([], 1).  % Базовый случай: произведение пустого списка равно 1.
multiply_elements1([H | T], Product) :-
    multiply_elements1(T, TailProduct),
    Product is H * TailProduct.

% Реализация с использованием стандартного рпедиката foldl
multiply_elements2(List, Product) :-
    foldl(multiply, List, 1, Product).
    
multiply(X, Y, Z) :-
    Z is X * Y.


% Содержательный пример): взять tail_from_element и вычислить произведение хвоста после определенного элемента
product_from_element(List, Elem, Product) :-
    tail_from_element2(Elem, List, Tail),  
    multiply_elements2(Tail, Product). 
