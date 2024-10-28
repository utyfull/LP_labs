:- consult('one.pl').

% Функция для вычисления среднего балла для каждого предмета
average_grade(Subject, Average) :-
    findall(Grade, grade(_, Subject, Grade), Grades), 
    length(Grades, Count),                           
    sumlist(Grades, Total),                        
    (Count > 0 -> Average is Total / Count ; Average is 0). 

print_average_grades :-
    findall(Subject, subject(Subject, _), Subjects), 
    forall(member(Subject, Subjects), (
        average_grade(Subject, Average),
        format('Средний балл по ~w: ~2f~n', [Subject, Average])
    )).

% Функция для подсчета не сдавших студентов в каждой группе
not_passed_students(Group, Count) :-
    findall(Student, (student(Group, Student), grade(Student, _, Grade), Grade < 3), Students),
    length(Students, Count).

% Функция для получения списка всех групп
all_groups(Groups) :-
    setof(Group, Student^student(Group, Student), Groups).

% Функция для подсчета не сдавших студентов по всем группам
all_not_passed(Result) :-
    all_groups(Groups),
    findall((Group, Count), (member(Group, Groups), not_passed_students(Group, Count)), Result).

% Функция для подсчета не сдавших студентов по каждому предмету
not_passed_students_subject(Subject, Count) :-
    findall(Student, (grade(Student, Subject, Grade), Grade < 3), Students),
    length(Students, Count).

% Функция для получения списка всех предметов
all_subjects(Subjects) :-
    setof(Subject, Name^subject(Subject, Name), Subjects).

% Функция для подсчета не сдавших студентов по всем предметам
not_passed_subjects(Result) :-
    all_subjects(Subjects),
    findall((Subject, Count), (member(Subject, Subjects), not_passed_students_subject(Subject, Count)), Result).