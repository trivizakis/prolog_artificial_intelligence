:- op(100,xfy,&).
:- op(150,xfx,'=>').

sentence(S) --> 
	noun_phrase(X,Assn,S), verb_phrase(X,Assn).
noun_phrase(X,Assn,S) --> 
	determiner(X,Prop12,Assn,S),noun(X,Prop1),rel_clause(X,Prop1,Prop12).
noun_phrase(X,Assn,Assn) --> 
	proper_noun(X).
verb_phrase(X,Assn) --> 
	trans_verb(X,Y,Assn1),noun_phrase(Y,Assn1,Assn).
verb_phrase(X,Assn) --> 
	intrans_verb(X,Assn).
rel_clause(X,Prop1,Prop1 , Prop2) --> 
	[that],verb_phrase(X,Prop2).
rel_clause(_,Prop1,Prop1) --> [].

determiner(X,Prop,Assn,all(X,(Prop => Assn))) --> [every].
determiner(X,Prop,Assn,exists(X,Prop & Assn)) --> [a].

noun(X,man(X)) --> [man].
noun(X,woman(X)) --> [woman].
proper_noun(john) --> [john].
proper_noun(annie) --> [annie].
proper_noun(monet) --> [monet].
trans_verb(X,Y,like(X,Y)) --> [likes].
trans_verb(X,Y,admire(X,Y)) --> [admires].
intrans_verb(X,paint(X)) --> [paints].