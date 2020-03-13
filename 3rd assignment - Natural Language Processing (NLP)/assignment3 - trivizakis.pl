%assignment 3 NLP
%trivizakis MP143
%Exercise 1
reverse([],[]).  
reverse([X],[X]).  
reverse([X|Xs],R):- 
  reverse(Xs,T),        
  append(T,[X],R).    
	
%Exercise 2
sentence-->noun_phrase, verb_phrase.
noun_phrase-->determiner, noun.
noun_phrase-->noun.
verb_phrase-->verb, noun_phrase.
verb_phrase-->verb.


determiner-->[the].
determiner-->[a].
%determiner-->['nil'].

noun-->[dog].
noun-->[cat].
noun-->[boy].
noun-->[girl].

verb-->[chased].
verb-->[saw].
verb-->[said].
verb-->[believed].

%Exercise 3
%in file assignment3.1 - trivizakis.pl