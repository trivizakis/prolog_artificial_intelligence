% assignment 2
% Trivizakis Eleftherios ΜΠ143
%
%Exercise 1
%
absolute(X,Y):- X>=0,Y=:=X,!.
absolute(X,Y):- Y is -X.
%
%Exercise 2
%
type(X,Y):- atom(X), Y='atom',!.
type(X,Y):- integer(X), Y='integer',!.
type(X,Y):- number(X), \+(integer(X)), Y ='real',!.
type(X,Y):- var(X), Y='variable',!.
type([H|T],Y):- Y='list',!.
type(X,Y):- nonvar(X), Y='compound',!.
%
%Exercise 3
%
save_KB:-tell('kb.pl'), see('kb_old.pl'), createNewCopy, seen, told.

createNewCopy:- read(X), \+(X=end_of_file), write(X),write('.'),nl, createNewCopy.
createNewCopy.
%
%Exercise 4
%
:-consult(kb).
update_KB:- write('-Make a choice: \n'),
			write('  1. for changing a record from the KB\n'),
			write('  2. for creating a new record in the KB\n'),
			write('  3. for deleting a record from the KB\n'),
			write(' Any other choice for Exit\n'),
			read(X),action(X),update_KB.
update_KB.
action(1):-
				change_record,!;
				write('There is no student with that number...\n').
action(2):-
				write('\nGive name: '),
				read(Name),
				write('\nGive departmend: '),
				read(Dept),
				write('\nGive telephone number: '),
				read(Tel),
				write('\nGive courses like a list [course1,course2,..,courseN]: '),
				read(Course),
				create_record([Name,Dept,Tel,[Course]]),!;
				write('Creation Fail!\n').
action(3):-
				delete_record,!;
				write('Delete Fail!\n').

action(AnyOther):-write('Thank you!'),!,fail.

change_record:-
				write('Give id\n'),
				read(Sid),integer(Sid),
				student(Sid,Z), %get student
				write('Change student by giving a list like [Name,Dept,Tel,[Course]]'),read(StudentList),
				retract(student(Sid,Z)),
				assert(student(Sid,StudentList)),save_existing_file.
			
create_record(StudentList):-
				students(L), %get max Sid
				maxElement(L,Max_ID),
				New_ID is Max_ID+1,					
				assertz(student(New_ID,StudentList)), % add student to kb				
				append(L,[New_ID],NewL),
				retract(students(_)),
				asserta(students(NewL)),					
				max_student_id(X),NewX is X+1,
				retract(max_student_id(_)),
				asserta(max_student_id(NewX)),%add new max to kb			
				save_existing_file.

delete_record:-
				write('Give id\n'),
				read(Sid),integer(Sid),
				retract(student(Sid,List)), %remove student from kb
				max_student_id(X),NewX is X-1, %lower the Sid
				retract(max_student_id(_)), 
				asserta(max_student_id(NewX)),%add new max to kb
				students(L),
				delete_ID(Sid,L,NewL),
				retract(students(_)),
				asserta(students(NewL)),
				save_existing_file. %save updated file

save_existing_file:- write('File saved. '),nl, tell('kb_updated.pl'),
				write(':-dynamic max_student_id/1,students/1,student/2.'),nl,
				max_student_id(X), write(max_student_id(X)),write('.'),nl,
				students(Y),write(students(Y)),write('.'),nl,
				students(Z),write_student(Z),told.
		
write_student([H|T]):-student(H,X),write(student(H,X)),write('.'),nl,write_student(T).
write_student(_).				

delete_ID(X,[H|T],L):-X=:=H,L=T.
delete_ID(X,[H|T],L):-X=\=H, delete_ID(X,T,L1),L=[H|L1].

maxElement([X],X).
maxElement([X|Tail],M):-maxElement(Tail,M1),max(X,M1,M).
max(X,Y,X):-X>Y.
max(X,Y,Y):-X=<Y.
%
%Exercise 5
%

replace_var_args(Term, ArgList, NewTerm):- Term=..TermList,
										   actual_replace_var(TermList,ArgList,[],OutList),
										   [Functor|Args]=OutList,
										   NewTerm=..[Functor|Args].	
										   
actual_replace_var([],[],WantedTermList,OutList):- OutList = WantedTermList.
actual_replace_var(L,[],WantedTermList,OutList):- append(WantedTermList,L,WantedTerm), OutList = WantedTerm.	
actual_replace_var([],L,WantedTermList,OutList):- OutList = WantedTermList.
			   					   
actual_replace_var([H|T],ArgList,Term,OutList):- nonvar(H),
										 append(Term,[H],WantedTerm), 
										 actual_replace_var(T,ArgList,WantedTerm,OutList).
actual_replace_var([H|T],[X|S],Term,OutList):- var(H), 
									   append(Term,[X],WantedTerm),
									   actual_replace_var(T,S,WantedTerm,OutList).