%last attemp
:- op(100,xfy,&).
:- op(150,xfx,'=>').

sentence(S) --> 
	noun_phrase(N,X,Assn,S), verb_phrase(N,X,Assn).
noun_phrase(N,X,Assn,S) --> 
	determiner(N,X,Prop12,Assn,S),noun(N,X,Prop1),rel_clause(X,Prop1,Prop12).
noun_phrase(N,X,Assn,Assn) --> 
	noun(N,X).
verb_phrase(N,X,Assn) --> 
	trans_verb(N,X,Y,Assn1),noun_phrase(N,Y,Assn1,Assn).
verb_phrase(N,X,Assn) --> 
	intrans_verb(N,X,Assn).
rel_clause(X,Prop1,Prop1 , Prop2) --> 
	[that],verb_phrase(X,Prop2).
rel_clause(_,Prop1,Prop1) --> [].

determiner(singular, X,Prop,Assn,all(X,(Prop => Assn))) --> [every].
determiner(singular, X,Prop,Assn,exists(X,Prop & Assn)) --> [a].
determiner(_, X,Prop,Assn,exists(X,Prop & Assn))-->[the].
determiner(plural, X,Prop,Assn,exists(X,Prop & Assn))-->[some].
determiner(_, X,Prop,Assn,all(X,(Prop => Assn)))-->[any].

noun(plural,Y,dog(Y)) --> [X], {generate_morph(dog,s,X)}.
noun(plural,Y,cat(Y)) --> [X], {generate_morph(cat,s,X)}.
noun(plural,Y,boy(Y)) --> [X], {generate_morph(boy,s,X)}.
noun(plural,Y,girl(Y)) --> [X], {generate_morph(girl,s,X)}.

trans_verb(singular,X,Y,chase(X,Y)) --> [Z], {generate_morph(chase,s,Z)}.
trans_verb(singular,X,Y,see(X,Y)) -->  [Z], {generate_morph(see,s,Z)}.
intrans_verb(singular,X,say(X)) --> [Z], {generate_morph(say,s,Z)}.
intrans_verb(singular,X,believe(X)) --> [Z], {generate_morph(believe,s,Z)}.

noun(singular,X,dog(X)) --> [dog].
noun(singular,X,cat(X)) --> [cat].
noun(singular,X,boy(X)) --> [boy].
noun(singular,X,girl(X)) --> [girl].
trans_verb(plural,X,Y,chase(X,Y)) --> [chase].
trans_verb(plural,X,Y,see(X,Y)) --> [see].
intrans_verb(plural,X,say(X)) --> [say].
intrans_verb(plural,X,believe(X)) --> [believe].


generate_morph(BaseForm,Suffix,DerivedForm):-
name(BaseForm,BaseFormCharList), name(Suffix,SuffCharList),
morph(BaseFormCharList,SuffCharList,DerivedFormCharList),
name(DerivedForm,DerivedFormCharList).

morph("fe","s","ves") :- !. %knife to knives
morph("e","ed","ed") :- !.
morph("see","ed","saw") :- !.%exceptions
morph("say","ed","said") :- !.

morph([],Suffix,Suffix).
morph([H|T],Suf,[H|Rest]) :- morph(T,Suf,Rest).
