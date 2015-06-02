%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%		Jonathan Gerbscheid & Michiel van der Meer				%%
%%				10787852 & 10749810								%%
%%					Zoeken, Sturen en Bewegen					%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- [minimax].
include('alphabeta.pl').

% List of moves from Pos, returns list of possible moves, fails if no moves are possible
moves(Pos,PosList):-
	min_to_move(Pos),
	bagof(X,move(Pos,X), PosList)
	;
	max_to_move(Pos),
	bagof(X,countermove(Pos,X), PosList).
	
	

% Value of a terminal node
staticval([A,B,C,D,E,F,G,H,I], Val):-
	A == D,
	A == G,
	returnstaticval(A,Val)
	;
	B == E,
	B == H,
	returnstaticval(B,Val)
	;
	C == F,
	C == I,
	returnstaticval(C,Val)
	;
	A == E,
	A == I,
	returnstaticval(A,Val)
	;
	C == E,
	C == G,
	returnstaticval(C,Val)
	;
	A == B,
	A == C,
	returnstaticval(A,Val)
	;
	D == E,
	D == F,
	returnstaticval(D,Val)
	;
	G == H,
	G == I,
	returnstaticval(G,Val).

returnstaticval(A,Val):-
	A == 1,
	Val = -1.
returnstaticval(A,Val):-
	A == 2,
	Val = 1.	

% count/2 for counting 0's
count([],_,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).	

% Opponents turn
min_to_move(Pos):-
	count(Pos,0,Y),
	\+ 0 =:= Y mod 2,!.
% Your turn
max_to_move(Pos):-
	count(Pos,0,Y),
	0 =:= Y mod 2,!.

move(Pos,X):-
	select(0,Pos,1,X).
	
countermove(Pos,X):-
	select(0,Pos,2,X).
