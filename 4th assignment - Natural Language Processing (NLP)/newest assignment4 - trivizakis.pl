%assignment 4 NLP
%trivizakis MP143
%
sentence(VP)-->noun_phrase(Num,Actor), verb_phrase(Num, Actor, VP).
noun_phrase(Num, NP)-->determiner(Num), noun(Num, NP).
noun_phrase(Num, NP)-->noun(Num, NP).
verb_phrase(Num,Actor,VP)-->trans_verb(Num,Actor,Y,VP),noun_phrase(_Anything,Y).
verb_phrase(Num, Actor, VP)-->intrans_verb(Num,Actor,VP).

determiner(_)-->[the]. %singular or plural
determiner(singular)-->[a].
determiner(plural)-->[some].
determiner(_)-->[any].

noun(N,NP) --> [X], { morph(noun(N,NP),X) }.
trans_verb(N,Actor,Y,VP) --> [X], { morph(verb(N,Actor,Y,VP),X) }.
intrans_verb(N,Actor,VP) --> [X], { morph(verb(N,Actor,VP),X) }.


morph(noun(singular,dog),dog).       % Singular nouns
morph(noun(singular,cat),cat).
morph(noun(singular,boy),boy).
morph(noun(singular,girl),girl).
%morph(noun(singular,child),child).

%morph(noun(plural,children),children).    % Irregular plural nouns

morph(noun(plural,NP),X) :-         % Rule for regular plural nouns
     remove_s(X,Y),
     morph(noun(singular,NP),Y).
	 
% Plural verbs
morph(trans_verb(plural,chase(X,Y)),chase).       
morph(intrans_verb(plural,see(X,Y)),see).
morph(trans_verb(plural,say(X,y)),say).
morph(intrans_verb(plural,believe(X,Y)),believe).

% Rule for singular verbs
morph(verb(singular,Actor,VP),X) :-       
     remove_s(X,Y),
     morph(verb(plural,Actor,VP),Y).
	 
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
	 
%target
%
%sentence(Meaning, [a,dog, chases, some, cats],[]).