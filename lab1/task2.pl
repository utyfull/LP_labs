:- consult('one.pl').

% Предикат для вычисления среднего балла по предмету
average_grade(SubjectCode, Average) :-
    findall(Grade, grade(_, SubjectCode, Grade), Grades),  
    length(Grades, Count),
    Count > 0, 
    sum_list(Grades, Sum),
    Average is Sum / Count.

% Подсчет не сдавших студентов для каждого предмета
count_failing_students_subject(SubjectCode, Count) :-
    findall(Student,
        (grade(Student, SubjectCode, Grade), Grade < 3),
        FailingStudents),  
    list_to_set(FailingStudents, UniqueFailingStudents),  % Уникальные имена студентов
    length(UniqueFailingStudents, Count).  

% Обработка и вывод количества не сдавших студентов по предметам
count_failing_students_per_subject :-
    subject(SubjectCode, SubjectName),
    count_failing_students_subject(SubjectCode, Count),
    format('Количество не сдавших студентов по ~w (~w): ~d~n', [SubjectCode, SubjectName, Count]),
    fail.
count_failing_students_per_subject. 

% Подсчет не сдавших студентов для каждой группы
count_failing_students(Group, Count) :-
    findall(Student,
        (grade(Student, Group, Grade), Grade < 3),
        FailingStudents),  
    list_to_set(FailingStudents, UniqueFailingStudents),  % Уникальные имена студентов
    length(UniqueFailingStudents, Count). 

% Подсчет не сдавших студентов по группам
count_failing_students_per_group :-
    findall(Group, grade(_, Group, _), Groups),  
    list_to_set(Groups, UniqueGroups),  % Уникальные группы
    count_failing_students_in_groups(UniqueGroups).

% Подсчет не сдавших студентов в уникальных группах
count_failing_students_in_groups([]). 
count_failing_students_in_groups([Group | Tail]) :-
    count_failing_students(Group, Count),
    format('Количество не сдавших студентов в группе ~w: ~d~n', [Group, Count]),
    count_failing_students_in_groups(Tail).

% Запуск всех запросов
run_tests :-
    format('~nСредний балл по предметам:~n', []),
    findall(SubjectCode, subject(SubjectCode, _), Subjects),
    print_average_grades(Subjects),
    format('~nКоличество не сдавших студентов по предметам:~n', []),
    count_failing_students_per_subject,
    format('~nКоличество не сдавших студентов по группам:~n', []),
    count_failing_students_per_group.

% Вывод средних баллов по предметам
print_average_grades([]).
print_average_grades([SubjectCode | Tail]) :-
    average_grade(SubjectCode, Average),
    subject(SubjectCode, SubjectName),
    format('Средний балл по ~w (~w): ~2f~n', [SubjectCode, SubjectName, Average]),
    print_average_grades(Tail).