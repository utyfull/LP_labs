:- discontiguous older/2.
:- discontiguous follows_path/2.

profession(engineer).
profession(lawyer).
profession(mechanic).
profession(economist).
profession(teacher).

older(teacher, engineer).
older(engineer, brother).

older(economist, mechanic).

not_blood_relative(lawyer, teacher).

solution(HusbandProfession, WifeProfession, SonProfession, SisterProfession, FatherProfession) :-
    profession(HusbandProfession),
    profession(WifeProfession),
    profession(SonProfession),
    profession(SisterProfession),
    profession(FatherProfession),

    HusbandProfession \= WifeProfession,
    HusbandProfession \= SonProfession,
    HusbandProfession \= SisterProfession,
    HusbandProfession \= FatherProfession,
    WifeProfession \= SonProfession,
    WifeProfession \= SisterProfession,
    WifeProfession \= FatherProfession,
    SonProfession \= SisterProfession,
    SonProfession \= FatherProfession,
    SisterProfession \= FatherProfession,

    (HusbandProfession = lawyer ; WifeProfession = lawyer),
    (FatherProfession = teacher ; SisterProfession = teacher),
    SonProfession = mechanic,
    FatherProfession = economist,
    HusbandProfession = engineer,
    older(economist, mechanic).
