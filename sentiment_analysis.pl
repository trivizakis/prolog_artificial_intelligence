:-consult(dict).

print_sentiment(Value) :-
	Value > 0,
	write('positive').
print_sentiment(Value) :-
	Value < 0,
	write('negative').
print_sentiment(Value) :-
	Value = 0,
	write('neutral').

value_of(positive, 1).
value_of(negative, -1).
value_of(_, 0).

prevTokValue([],CurrentValue,CurrentValue).
prevTokValue([_, inc], CurrentValue, OutputValue) :-
	OutputValue is CurrentValue * 2, !.
prevTokValue([_, dec], CurrentValue, OutputValue) :-
	OutputValue is CurrentValue / 2, !.
prevTokValue([_, inv], CurrentValue, OutputValue) :-
	OutputValue is CurrentValue * -1, !.
prevTokValue([_, _], CurrentValue, CurrentValue):- !.

sentence_score([], _, 0).	
sentence_score([[Word, Tag]|Tail], PrevToken, TotalScore) :- 
	value_of(Tag, ValueTag),
	prevTokValue(PrevToken, ValueTag, CurScore),
	CurToken = [Word, Tag],!,
	sentence_score(Tail, CurToken, TotalofRest),
	TotalScore is CurScore + TotalofRest.

tag_sentence([Word |Reststring], Reststring, [Word, Category]) :-
	dict(Word,Category).
tag_sentence([Word |Reststring], Reststring, [Word, nothing]) :-
	\+(dict(Word,_)).
tag_sentences([],String, String).
tag_sentences(String, Reststring, [Subtree|Subtrees]) :-
	tag_sentence(String, String1, Subtree),
	tag_sentences(String1, Reststring, Subtrees).

sentiment(String,Value) :-
        write(String),write('\n'),
        tag_sentences(String, [], TaggedResult),
        write(TaggedResult),write('\n'),!,
		sentence_score(TaggedResult, [], Value),!,
		%totalScore(Value),
		write(Value),
		write('\nThe sentence is: '), print_sentiment(Value), nl.