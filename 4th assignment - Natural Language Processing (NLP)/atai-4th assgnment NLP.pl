%	
%	Trivizakis Eleftherios, ΜΠ143
%		4th assignment
%
%goals:
%| ?- sentence(Meaning,[a,dog,chases,a,cat],[]).
%| ?- sentence(Meaning,[the,dog,chases,any,cats],[]).
%| ?- sentence(Meaning,[the,dogs,chase,a,cat],[]).
%| ?- sentence(Meaning,[the,dogs,chase,some,cats],[]).
%| ?- sentence(Meaning,[the,dogs,chased,some,cats],[]).
%| ?- sentence(Meaning,[the,dog,chased,some,cats],[]).

:- op(100,xfy,&).
:- op(150,xfx,'=>').

sentence(S) --> 
	noun_phrase(N,X,Assn,S), verb_phrase(N,X,Assn).
noun_phrase(N,X,Assn,S) --> 
	determiner(N,X,Prop12,Assn,S),noun(N,X,Prop1),rel_clause(X,Prop1,Prop12).
noun_phrase(N,X,Assn,Assn) --> 
	noun(N,X,Prop1).
verb_phrase(N,X,Assn) --> 
	trans_verb(N,X,Y,Assn1),noun_phrase(Num,Y,Assn1,Assn).
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
%determiner()-->[]. %NOTHING

noun(N,Actor,_F) --> [X], { morph(noun(N,Actor,_F),X) }.
trans_verb(N,Actor,Y,_F) --> [X], { morph(trans_verb(N,Actor,Y,_F),X) }.
intrans_verb(N,Actor,_F) --> [X], { morph(intrans_verb(N,Actor,_F),X) }.

morph(noun(singular,X,dog(X)),dog).
morph(noun(singular,X,cat(X)),cat).
morph(noun(singular,X,boy(X)),boy).
morph(noun(singular,X,girl(X)),girl).
morph(trans_verb(plural,X,Y,chase(X,Y)),chase).
morph(trans_verb(plural,X,Y,see(X,Y)),see).
morph(intrans_verb(plural,X,say(X)),say).
morph(trans_verb(plural,X,believe(X)),believe).

% Rule for singular nouns
%morph(noun(plural,Actor,_),children).    % Irregular plural nouns

morph(noun(plural,Actor,_E),X) :-         % Rule for regular plural nouns
     remove_s(X,Y),
     morph(noun(singular,Actor,_R),Y).
	 
% Rule for singular verbs & past tense
morph(intrans_verb(singular,Actor,_),X) :-       
     remove_s(X,Y),
     morph(intrans_verb(plural,Actor,_),Y).
morph(trans_verb(singural,Actor,Actor2,_),X) :-       
     remove_s(X,Y),
     morph(trans_verb(plural,Actor,Actor2,_),Y).
% Rule for singular past tense
morph(intrans_verb(_,Actor,_),X) :-       
     remove_s(X,Y),
     morph(intrans_verb(plural,Actor,_),Y).
morph(trans_verb(_,Actor,Actor2,_),X) :-       
     remove_s(X,Y),
     morph(trans_verb(plural,Actor,Actor2,_),Y).

	 
remove_s(X,X1) :-
     name(X,XList),
     remove_s_list(XList,X1List),
     name(X1,X1List).

remove_s_list("s",[]).			%singular
remove_s_list("saw","see").		%iregular
remove_s_list("said","say").
remove_s_list("d",[]).			%past tense

remove_s_list([Head|Tail],[Head|NewTail]) :-
     remove_s_list(Tail,NewTail).