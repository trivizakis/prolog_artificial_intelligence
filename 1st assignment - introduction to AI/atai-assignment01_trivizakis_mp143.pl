% Eleftherios Trivizakis, ΜΠ143
%
%	exercise 1
%

parent(panos,john).
parent(elene,john).
parent(aris,ann).
parent(mary1,ann).
parent(john,mary2).
parent(john,kostas).
parent(john,manolis).
parent(ann,mary2).
parent(ann,kostas).
parent(ann,manolis).
male(john).
male(kostas).
male(manolis).
male(panos).
male(aris).
female(mary1).
female(mary2).
female(ann).
female(elene).

father(X,Y):-parent(X,Y), male(X).
mother(X,Y):-parent(X,Y), female(X).
grandfather(X,Y):-parent(X,Z), parent(Z,Y), male(X).
grandmother(X,Y):-parent(X,Z), parent(Z,Y), female(X).
sister(X,Y):-parent(Z,X), parent(Z,Y), female(X),X\=Y. % \= δεν ενοποιείται
brother(X,Y):-parent(Z,X), parent(Z,Y), male(X),X\=Y,male(Z).
descendant(X,Y):-parent(Y,X);(parent(Y,Z),descendant(Z,X)).
ancestor(X,Y):-parent(X,Y);(parent(X,Z),ancestor(Z,Y)).

%
%	exercise 2
%

edge(a,b).
edge(a,d).
edge(b,c).
edge(c,d).
edge(d,e).
edge(b,e).

connected(X,X).
connected(X,Y):-edge(X,Y).
connected(X,Y):-edge(X,Z),connected(Z,Y).

%
%	exercise 3
%

affinity(john,ann,spouse).
type_of_service(ann,hospitalization).
insurance_cover(john,hospitalization).
insurance_support(john,full).
type_of_insurance(john,family).
requested_compensation(john,5000).

compensation(Insured,Poso):-
			insurance_cover(Insured,hospitalization),
			type_of_service(Patient,hospitalization),
			(insurance_support(Insured,Idos),
			 (
			  (Idos=partial,
			  (requested_compensation(Insured,Poso);(requested_compensation(Insured,ToPoso),Poso<ToPoso)));
			  (Idos=full, (Poso='all money'; Poso=Poso))
			  )
			).

compensation(Patient,Poso):-
			(patient_support(Insured,Patient),insurance_cover(Insured,hospitalization)),
						insurance_support(Insured,Idos),
						(
						 (Idos=partial,(requested_compensation(Insured,Poso);(requested_compensation(Insured,ToPoso),Poso<ToPoso)));
						 (Idos=full, (Poso='all money'; Poso=Poso))
						).
						
patient_support(Insured,Patient):-
			affinity(Insured,Patient,spouse),type_of_insurance(Insured,family).

%
%	exercise 4
%
unique(X,[X|T]):- \+(member(X,T)).
unique(X,[H|T]):- \+(X=H),unique(X,T).
%
%	exercise 5
%
del(H,[H|T],T1) :- del(H,T,T1).
del(X,[H|T],[H|T1]) :- H\=X, del(X,T,T1).
del(_,[],[]).

one_occurrence([H|T],[H|T2]) :- del(H,T,T1), one_occurrence(T1,T2).
one_occurrence([],[]).
%
%	exercise 6
%
%αλφα in the head of clause
max_El([X],X).
max_El([X|T], M):- max_El(T, M), M >= X.
max_El([X|T], X):- max_El(T, M), X >  M.
%βητα in the body of clause
maxEl([X],X).
maxEl([X|Tail],M):-maxEl(Tail,M1),max(X,M1,M).
max(X,Y,X):-X>Y.
max(X,Y,Y):-X=<Y.
%
%	exercise 7
%
%αλφα in the head of clause
occur2([],X,0).		
occur2([X|T],X,N):-
			occur2(T,X,N2),
			N is N2 + 1.
occur2([H|T],X,N):-
			occur2(T,X,N).
			
%βητα in the body of clause
occur(Arxiki,X,N):-
				ocur(Arxiki,X,0,N).
ocur([],X,N,N).
ocur([X|T],X,Count,N):-
				Num is Count + 1,
				ocur(T,X,Num,N).				
ocur([H|T],X,Count,N):-
				ocur(T,X,Count,N).
%
%	exercise 8
%
insertSort(L1,L2) :-
  insertSort1(L1,[],L2).
 
insertSort1([],L,L).
insertSort1([H|T],L1,L) :-
  insert(L1,H,L2),
  insertSort1(T,L2,L).
 
insert([],X,[X]).
insert([H|T],X,[X,H|T]) :- X =< H.
insert([H|T],X,[H|T2]) :-
  insert(T,X,T2).