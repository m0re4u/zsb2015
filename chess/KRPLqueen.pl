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

move(queenmove, us..W..Qx : Qy..B..D,Qx:Qy - QM, them..W..QM..B..D1):-
	D1 is D + 1,
	%coord(I),			% int between 1 - 8
	%move horizontally or vertically
	(
		/*QM = Qx : I
		;
		QM = I : Qy
		;*/
		A is Qx + 1,
		B is Qy + 1,
		QM = A : B
	), 
	QM \== Qx : Qy, 		% must move
	Q = Qx:Qy,
	not inway(Q, W, QM),	% white king not in way
	not inway(Q, B, QM).	% black king not in way
	
move(checkmove, Pos, Qx : Qy - Qx1 : Qy1, Pos1):-
	wk(Pos, W),	% white king pos
	wq(Pos, Qx:Qy),	% white queen pos
	bk(Pos, Bx:By),	% black king pos
	% place white queen and black king on a line
	(
		Qx1 = Bx,
		Qy1 = Qy
	;
		Qx1 = Qx,
		Qy1 = By
	;
		coord(I),
		M is I - 1,
		Qx1 is Bx - M,
		Qx2 is By - M
	;
		coord(I),
		M is I - 1,
		Qx1 is Bx + M,
		Qx2 is By + M
	;
		coord(I),
		M is I - 1,
		Qx1 is Bx - M,
		Qx2 is By + M
	;
		coord(I),
		M is I - 1,
		Qx1 is Bx + M,
		Qx2 is By - M
	),
	% no white king in between queen and black king
	not inway(Qx1 : Qy, W, Bx : By),
	move(queenmove, Pos, Qx : Qy - Qx1 : Qy1, Pos1).
	
move(legal, us..P, M, P1):-
	(
		MC = kingdiagfirst
	;
		MC = queenmove
	),
	move(MC, us..P, M, P1).
	
queenexposed(Side..W..Q..B.._D, _):-
	dist(W, Q, D1),
	dist(B, Q, D2),
	(
		Side = us,!,
		D1 > D2 + 1
	;
		Side = them,!,
		D1 > D2
	).

queendivides(_Side..Wx : Wy..Qx : Qy..Bx : By.._D, _):-
	ordered(Wx, Qx, Bx),!;
	ordered(Wy, Qy, By).
	
queenlost(_.._..B..B.._, _). % queen has fallen

queenlost(them..W..Q..B.._, _):-
	ngb(B,Q),		% black king attacks queen
	not ngb(W,Q).	% white king does not defend
	
did_not_move_queen(us.._..Qx:Qy.._.._,them.._..Qx:Qy.._.._).