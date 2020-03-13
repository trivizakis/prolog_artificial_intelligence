%assignment 4 NLP
%trivizakis MP143
%
%
%douleyei mono: sentence(Meaning,[the,dog, chases, a, cat],[]). 
%
%
:- op(100,xfy,&).
:- op(150,xfx,'=>').
sentence(VP)-->noun_phrase(Num,Actor), verb_phrase(Num,Actor,VP), {reduce(VP, NP, S)}.
noun_phrase(Num,NP)-->determiner(Num,D), noun(Num,NP), {reduce(D, Num, NP)}.
noun_phrase(Num,NP)-->noun(Num,NP).
verb_phrase(Num,Actor,VP)-->trans_verb(Num,Actor,Y,VP),noun_phrase(_Anything,Y).%, {reduce(TV, NP, VP)}.
verb_phrase(Num,Actor,VP)-->intrans_verb(Num,Actor,VP).

determiner(_)-->[the]. %singular or plural
determiner(singular)-->[a]. %determiner(X,Prop,Assn,exists(X,Prop & Assn)) --> [a].
determiner(plural)-->[some].
determiner(_)-->[any].
determiner((X^P)^(X^Q)^all(X, P=>Q)) --> [every].

noun(singular,dog)-->[dog].
noun(singular,cat)-->[cat].
noun(singular,boy)-->[boy].
noun(singular,girl)-->[girl].
trans_verb(plural,X,Y,chase(X,Y))-->[chase].
trans_verb(plural,X,Y,see(X,Y))-->[see].
trans_verb(plural,X,Y,say(X,Y))-->[say].
intransverb(plural,Actor,believe(Actor))-->[believe].

noun(plural,dog) --> [X], {generate_morph(dog,s,X)}.
trans_verb(singular,Z,Y,chase(Z,Y)) --> [X],{generate_morph(chase,s,X)}.
trans_verb(singular,Z,Y,chase(Z,Y)) --> [X],{generate_morph(chase,ed,X)}.
%intrans_verb(singular) --> [X],{generate_morph(chase,s,X)}.

%pos 8a to kanw na elegxei dynamiaka ola ta noun kai verb?			
%noun(plural) --> [X], {generate_morph(noun(singular),s,X)}. %8elw na elegxo ola ta noun kai na epistrefei to X derived?
%verb(singular) --> [X],{generate_morph(verb(plural),s,X)}. %8elw na elegxo ola ta verb  to X derived?

generate_morph(BaseForm,Suffix,DerivedForm):-
name(BaseForm,BaseFormCharList), name(Suffix,SuffCharList),
morph(BaseFormCharList,SuffCharList,DerivedFormCharList),
name(DerivedForm,DerivedFormCharList).

morph("fe","s","ves") :- !.
morph("e","ed","ed") :- !.
morph("see","ed","saw") :- !.%exceptions
morph("say","ed","said") :- !.

morph([],Suffix,Suffix).
morph([H|T],Suf,[H|Rest]) :- morph(T,Suf,Rest).


% sentence(Meaning, [a,dog, chases, some, cats],[]).
%Meaning = exist(_A,dog(_A)&exist(_B,cats(_B)&chases(_A,_B)))
%
%?- sentence(Meaning, [a,dog, chase, some, cats],[]).
%no