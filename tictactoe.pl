%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%		Jonathan Gerbscheid & Michiel van der Meer				%%
%%				10787852 & 10749810								%%
%%					Zoeken, Sturen en Bewegen					%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:- [minimax].
:- [alphabeta].

% List of moves from Pos, returns list of possible moves, fails if no moves are 
% possible
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Visualization of the game, not necessary for the algorithms to work
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
	writeln('You were convincingly beaten!').
gameloop(Pos,_):-
	\+ member(1,Pos),
	\+ member(2,Pos),
	writeln('You tied!').
gameloop(Pos, Mademoves):-
	member(0,Pos),
	write('Enter the next position: '),
	read(N),
	X is N -1,
	\+ member(X,Mademoves),
	NewMademoves = [X|Mademoves],
	replaceind(Pos,X,1,NewPos),
	minimax(NewPos,FinalPos,_),
	visual(FinalPos),
	gameloop(FinalPos, NewMademoves).

replaceind([_|T], 0, X, [X|T]).
replaceind([H|T], I, X, [H|R]):- I > 0, I1 is I-1, replaceind(T, I1, X, R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Minimax and AlphaBeta test routines for performance difference.
	Done by using the same position and compairing calculation times
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
--- minimax algorithm --- Test 1 ---
?- time(minimax([0,0,0,0,0,0,0,0,0],X,Y)).
% 75,404,856 inferences, 9.563 CPU in 9.626 seconds (99% CPU, 7885177 Lips)
X = [0, 0, 0, 0, 0, 0, 0, 0, 1],
Y = 0.

--- AlphaBeta algorithm --- Test 1 ---
?- time(alphabeta([0,0,0,0,0,0,0,0,0],0,0,X,Y)).
% 13,876,469 inferences, 2.059 CPU in 2.123 seconds (97% CPU, 6738724 Lips)
X = [0, 0, 0, 0, 0, 0, 0, 0, 1],
Y = 0.

--- minimax algorithm --- Test 2 ---
?- time(minimax([0,0,0,0,0,0,0,0,1],X,Y)).
% 8,363,422 inferences, 1.061 CPU in 1.057 seconds (100% CPU, 7884020 Lips)
X = [0, 0, 0, 0, 0, 0, 2, 0, 1],
Y = 0.

--- AlphaBeta algorithm --- Test 2 ---
?- time(alphabeta([0,0,0,0,0,0,0,0,1],0,0,X,Y)).
% 2,466,467 inferences, 0.328 CPU in 0.350 seconds (94% CPU, 7528850 Lips)
X = [0, 0, 0, 0, 0, 0, 2, 0, 1],
Y = 0.

--- minimax algorithm --- Test 3 ---
?- time(minimax([0,0,0,1,0,0,2,0,1],X,Y)).
% 148,968 inferences, 0.031 CPU in 0.030 seconds (104% CPU, 4774585 Lips)
X = [0, 0, 0, 1, 0, 2, 2, 0, 1],
Y = 0.

--- AlphaBeta algorithm --- Test 3 ---
?- time(alphabeta([0,0,0,1,0,0,2,0,1],0,0,X,Y)).
% 96,476 inferences, 0.031 CPU in 0.028 seconds (111% CPU, 3092160 Lips)
X = [0, 0, 0, 1, 0, 2, 2, 0, 1],
Y = 0.
*/




























