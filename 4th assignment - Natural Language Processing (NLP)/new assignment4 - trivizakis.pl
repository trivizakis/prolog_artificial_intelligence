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

noun(N) --> [X], { morph(noun(N),X) }.
verb(N) --> [X], { morph(verb(N),X) }.


morph(noun(singular),dog).       % Singular nouns
morph(noun(singular),cat).
morph(noun(singular),boy).
morph(noun(singular),girl).
%morph(noun(singular),child).

%morph(noun(plural),children).    % Irregular plural nouns

morph(noun(plural),X) :-         % Rule for regular plural nouns
     remove_s(X,Y),
     morph(noun(singular),Y).
	 
% Plural verbs
morph(verb(plural),chase).       
morph(verb(plural),see).
morph(verb(plural),say).
morph(verb(plural),believe).

% Rule for singular verbs
morph(verb(singular),X) :-       
     remove_s(X,Y),
     morph(verb(plural),Y).
	 
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