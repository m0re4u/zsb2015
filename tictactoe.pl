%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%		Jonathan Gerbscheid & Michiel van der Meer				%%
%%				10787852 & 10749810								%%
%%					Zoeken, Sturen en Bewegen					%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

include('minimax.pl').
include('alphabeta.pl').

% List of moves from Pos, returns list of possible moves, fails if no moves are possible
moves(Pos,PosList):-
	bagof(X,countermove(Pos,X), PosList).

% Value of a terminal node
staticval(Pos, Val):-
	

% Opponents turn
%min_to_move(Pos):-

% Your turn
%max_to_move(Pos):-


move(Pos,X):-
	select(0,Pos,1,X).
	
countermove(Pos,X):-
	select(0,Pos,2,X).