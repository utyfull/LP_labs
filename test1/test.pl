n_factorial(0, 1).

n_factorial(N, F) :-
    N > 0,                  
    N1 is N - 1,             
    n_factorial_acc(N1, N, F). 

n_factorial_acc(0, Acc, Acc).  
n_factorial_acc(N, Acc, F) :-  
    N > 0,                   
    N1 is N - 1,             
    NewAcc is Acc * N,      
    n_factorial_acc(N1, NewAcc, F). 