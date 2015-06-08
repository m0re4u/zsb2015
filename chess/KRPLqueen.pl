% -*- Mode: Prolog -*-

% Position is represented by Side..Wx : Wy..Qx : Qy .. Bx : By .. Depth
% Side is side to move next ( us or them )
% Wx, Wy are X and Y coordinates of the white king
% Qx, Qy are X and Y coordinates of the white queen
% Bx, By are the X and Y coordinates of the black king
% depth is depth of position in the search tree

mode(queen).

% call the general original move predicates for queen moves etc.
move(A,B,C,D):-
        moveGeneral(A,B,C,D).

% Queen moves!		
move( queenmove, us..W..Qx : Qy..B..D, Qx:Qy - QM, them..W..QM..B..D1 ):-
	D1 is D + 1,
	coord( I ),		% integer between 1 and 8
	% move horizontally of vertically
	(
		% horizontal
		QM = Qx : I
	;
		% vertical
		QM = I : Qy
	;	
		% low left to high right
		X is Qx + I,
		Y is Qy + I,
		X =< 8,
		Y =< 8,
		QM = X:Y
	;
		% high left to low right
		X is Qx + I,
		Y is Qy - I,
		X =< 8,
		Y >= 1,
		QM = X:Y
	;
		% low right to high left
		X is Qx - I,
		Y is Qy + I,
		X >= 1,
		Y =< 8,
		QM = X:Y
	;
		% high right to low left
		X is Qx - I,
		Y is Qy - I,
		X >= 1,
		Y >= 1,
		QM = X:Y
	),
    QM \== Qx : Qy,	% Must have moved
	not inway( Qx : Qy, W, QM ), 	% white king not in way
	not inway( (Qx : Qy), B, QM ). 	% black king not in way


move( checkmove, Pos, Qx : Qy - Qx1 : Qy1, Pos1 ):-
	wk( Pos, W ), 			% white king position
	wq( Pos, Qx : Qy ),		% white queen position
	bk( Pos, Bx : By ),		% black king position
	coord(I),				% for diagonal line check
	% place black king and white queen on line(hor, vert, diag)
	( 
		% horizontal
		Qx1 = Bx,
		Qy1 = Qy
	;
		% vertical
		Qx1 = Qx,
		Qy1 = By
	;	
		% low left to high right  
		Qx1 is Bx + I,
		Qy1 is By + I,
		Qx1 =< 8,
		Qy1 =< 8
	;
		% high left to low right
		Qx1 is Bx + I,
		Qy1 is By - I,
		Qx1 =< 8,
		Qy1 >= 1
	;
		% low right to high left
		Qx1 is Bx - I,
		Qy1 is By + I,
		Qx1 >= 1,
		Qy1 =< 8
	;
		% high right to low left
		Qx1 is Bx - I,
		Qy1 is By - I,
		Qx1 >= 1,
		Qy1 >= 1
	),
	% not the white king between the queen and black king
	not inway( Qx1 : Qy, W, Bx : By ),
	move( queenmove, Pos, Qx : Qy - Qx1 : Qy1, Pos1 ).
	
move(move_queen_away, Pos, Qx : Qy - Qx1 : Qy1, Pos1):-
	wq( Pos, Qx : Qy ),		% white queen position
	wk( Pos, W ), 			% white king position
	(
		(	% low left
			Qx < 4,
			Qy < 4,
			Qx1 is Qx + 1,
			Qy1 is Qy + 1
		;	% high left
			Qx < 4,
			Qy > 5,
			Qx1 is Qx + 1,
			Qy1 is Qy - 1
		;	% low right
			Qx > 5,
			Qy < 4,
			Qx1 is Qx - 1,
			Qy1 is Qy + 1
		;	% high right
			Qx > 5,
			Qy > 5,
			Qx1 is Qx - 1,
			Qy1 is Qy - 1
		),
		not inway( Qx : Qy, W, Qx1 : Qy1 )
	;
		(
			Qx < 4,
			Qx1 is Qx + 2
		;
			Qx > 5,
			Qx1 is Qx - 2
		)
	).

move( legal, us..P, M, P1 ) :-
	(
		MC = kingdiagfirst
	;
		MC = queenmove
	),
	move( MC, us..P, M, P1 ).

queenexposed( Side..W..Q..B.._D, _ ) :-
	dist( W, Q, D1 ),
	dist( B, Q, D2 ),
	(
		Side = us, !, 
      		D1 > D2 + 1
	;
		Side = them, !,
		D1 > D2
	).


queendivides( _Side..Wx : Wy..Qx : Qy..Bx : By.._D, _ ) :-
	ordered( Wx, Qx, Bx ), !;
	ordered( Wy, Qy, By ).

queenlost( _.._W..B..B.._ ,_).	% queen has been captured

queenlost( them..W..Q..B.._ ,_) :-
	ngb( B, Q ),	% black king attacks queen
	not ngb( W, Q ).	% white king does not defend

queensame(us..W..Q..B.._,them.._..Q.._.._).

