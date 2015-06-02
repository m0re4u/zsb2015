%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%		Jonathan Gerbscheid & Michiel van der Meer				%%
%%				10787852 & 10749810								%%
%%					Zoeken, Sturen en Bewegen					%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- [minimax].
%:- [alphabeta].

% List of moves from Pos, returns list of possible moves, fails if no moves are possible
moves(Pos,PosList):-
	min_to_move(Pos),
	bagof(X,move(Pos,X), PosList)
	;
	max_to_move(Pos),
	bagof(X,countermove(Pos,X), PosList).

move(Pos,X):-
	select(0,Pos,1,X).
	
countermove(Pos,X):-
	select(0,Pos,2,X).
	
% Value of a terminal node
% full hardcode
/*
staticval([1,1,1,_,_,_,_,_,_],-1).
staticval([_,_,_,1,1,1,_,_,_],-1).
staticval([_,_,_,_,_,_,1,1,1],-1).
staticval([1,_,_,1,_,_,1,_,_],-1).
staticval([_,1,_,_,1,_,_,1,_],-1).
staticval([_,_,1,_,_,1,_,_,1],-1).
staticval([1,_,_,_,1,_,_,_,1],-1).
staticval([_,_,1,_,1,_,1,_,_],-1).

staticval([2,2,2,_,_,_,_,_,_],1).
staticval([_,_,_,2,2,2,_,_,_],1).
staticval([_,_,_,_,_,_,2,2,2],1).
staticval([2,_,_,2,_,_,2,_,_],1).
staticval([_,2,_,_,2,_,_,2,_],1).
staticval([_,_,2,_,_,2,_,_,2],1).
staticval([2,_,_,_,2,_,_,_,2],1).
staticval([_,_,2,_,2,_,2,_,_],1).

staticval([_,_,_,_,_,_,_,_,_],0).
*/

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

staticval([_,_,_,_,_,_,_,_,_],0).

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

visual(Pos):-
	replace(0,-,Pos,Pos1),
	replace(1,x,Pos1,Pos2),
	replace(2,o,Pos2,Pos3),
	Pos3 = [A,B,C,D,E,F,G,H,I],
	writeln('  -----------'),
	write(' | '), write(A), write(' | '), write(B), write(' | '), write(C), write('  | '),nl,writeln(' | -----------|'),
	write(' | '), write(D), write(' | '), write(E), write(' | '), write(F), write('  | '),nl,writeln(' | -----------|'),
	write(' | '), write(G), write(' | '), write(H), write(' | '), write(I), write('  | '),nl,writeln('  -----------').

replace(_, _, [], []).
replace(O, R, [O|T], [R|T2]) :- replace(O, R, T, T2).
replace(O, R, [H|T], [H|T2]) :- H \= O, replace(O, R, T, T2).

tictactoe:-
	write('Enter a position for the first cross: '),
	read(N),
	X is N -1,
	StartPos = [0,0,0,0,0,0,0,0,0],
	replaceind(StartPos,X,1,NewPos),
	minimax(NewPos,FinalPos,_),
	visual(FinalPos),
	writeln('Your opponent has moved'),
	gameloop(FinalPos,[X]).

gameloop(Pos,_):-
	staticval(Pos,X),
	X == -1,
	writeln('You won!').
gameloop(Pos,_):-
	staticval(Pos,X),
	X == 1,
	writeln('You were beaten convincinly!').
gameloop(Pos,_):-
	\+ member(0,Pos),
	writeln('You tied!').
gameloop(Pos, Mademoves):-
	write('Enter the next position: '),
%	writeln(Mademoves),
	read(N),
	X is N -1,
	\+ member(X,Mademoves),
	NewMademoves = [X|Mademoves],
	replaceind(Pos,X,1,NewPos),
	minimax(NewPos,FinalPos,_),
	visual(FinalPos),
	member(0,Pos),
	gameloop(FinalPos, NewMademoves).



replaceind([_|T], 0, X, [X|T]).
replaceind([H|T], I, X, [H|R]):- I > 0, I1 is I-1, replaceind(T, I1, X, R).




