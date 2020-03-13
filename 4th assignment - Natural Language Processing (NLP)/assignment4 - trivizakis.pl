%assignment 4 NLP
%trivizakis MP143
%
sentence-->noun_phrase(Num), verb_phrase(Num).
noun_phrase(Num)-->determiner(Num), noun(Num).
noun_phrase(Num)-->noun(Num).
verb_phrase(Num)-->verb(Num),noun_phrase(_Anything).
verb_phrase(Num)-->verb(Num).

determiner(_)-->[the]. %singular or plural
determiner(singular)-->[a].
determiner(plural)-->[some].
determiner(_)-->[any].

noun(singular)-->[dog].
noun(singular)-->[cat].
noun(singular)-->[boy].
noun(singular)-->[girl].
verb(plural)-->[chase].
verb(plural)-->[see].
verb(plural)-->[say].
verb(plural)-->[believe].

noun(plural) --> [X], {generate_morph(dog,s,X)}.
verb(singular) --> [X],{generate_morph(chase,s,X)}.

%pos 8a to kanw na elegxei dynamiaka ola ta noun kai verb
%noun(plural) --> [X], {generate_morph(noun(singular),s,X)}. %8elw na elegxo ola ta noun kai na epistrefei to X derived
%verb(singular) --> [X],{generate_morph(verb(plural),s,X)}. %8elw na elegxo ola ta verb  to X derived

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