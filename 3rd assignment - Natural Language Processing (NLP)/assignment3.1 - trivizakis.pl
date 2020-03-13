%assignment 3 NLP
%trivizakis MP143
%Exercise 3
sentence-->noun_phrase(Num), verb_phrase(Num).
noun_phrase(Num)-->determiner(Num), noun(Num).
noun_phrase(Num)-->noun(Num).
verb_phrase(Num)-->verb(Num),noun_phrase(N).
verb_phrase(Num)-->verb(Num).

determiner(_)-->[the]. %singular or plural
determiner(singular)-->[a].
%determiner(_)-->['nil'].

noun(plural)-->[dogs].
noun(singular)-->[dog].
noun(plural)-->[cats].
noun(singular)-->[cat].
noun(plural)-->[boys].
noun(singular)-->[boy].
noun(plural)-->[girls].
noun(singular)-->[girl].

verb(plural)-->[chase].
verb(singular)-->[chases].
verb(plural)-->[see].
verb(singular)-->[sees].
verb(plural)-->[say].
verb(singular)-->[says].
verb(plural)-->[believe].
verb(singular)-->[believes].
%Exercises 1+2
%in file assignment3 - trivizakis.pl