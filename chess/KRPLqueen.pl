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
		QM = Qx : I
	;
		QM = I : Qy
	),
    QM \== Qx : Qy,	% Must have moved
	Q = Qx:Qy,
	not inway( QM, W, Q ), 	% white king not in way
	not inway( Qx : Qy, W, Q ), 	% white king not in way
	not inway( (Qx : Qy), B, Q ). 	% black king not in way


move( checkmove, Pos, Qx : Qy - Qx1 : Qy1, Pos1 ):-
	wk( Pos, W ), 	% white king position
	wq( Pos, Qx : Qy ),		% white queen position
	bk( Pos, Bx : By ),	% black king position
	% place black king and white queen on line
	( 
      		Qx1 = Bx,
      		Qy1 = Qy
	;
		Qx1 = Qx,
		Qy1 = By
	),
	% not the white king between the queen and black king
	not inway( Qx1 : Qy, W, Bx : By ),
	move( queenmove, Pos, Qx : Qy - Qx1 : Qy1, Pos1 ).

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

