% Intermediate implementation of the Advice Language engine.
% follow_strategy( Pos, BestMove, BestSucc, Val):
%    Pos is a position, Val is its terminal value;
%    BestMove from Pos leads to position BestSucc

:- op( 220, xfy, ..).
:- op( 200, xfy, :: ).
:- op( 185, fx, if ).
:- op( 190, xfx, then ).
:- op( 160, xfy, and ).
:- op( 140, fx, not ).

follow_strategy( Pos, BestMove, BestSucc, Val)  :-
  strategy( Pos, MPList), !,               % Legal moves in Pos produce PosList
  best( MPList, BestMove, BestSucc, Val)
  ;
   staticval( Pos, Val).          % Pos has no successors: evaluate statically 

best( Move..Pos, Move, Pos, BestVal)  :-
  nl, write('best of one move'), nl,
  follow_strategy( Pos, Move, Pos, BestVal), !.  

best( [Move..Pos], Move, Pos, BestVal)  :-
  nl, write('best of one list'), nl,
  follow_strategy( Pos, Move, Pos, BestVal), !.  

best( [Move1..Pos1 | MPList], BestPos, BestMove, BestVal)  :-
  nl, write('best of a list with more elements'), nl,
  follow_strategy( Pos1, _, _, Val1),
  best( MPList, Pos2, Move2, Val2),
  betterof( Pos1, Move1, Val1, Pos2, Move2, Val2, BestPos, BestMove, BestVal).

betterof( Pos0, Move0, Val0, _, _, Val1, Pos0, Move0, Val0)  :-        % Pos0 better than Pos1
  min_to_move( Pos0),                                    % MIN to move in Pos0
  Val0 > Val1, !                                         % MAX prefers the greater value
  ;
  max_to_move( Pos0),                                    % MAX to move in Pos0
  Val0 < Val1, !.                                % MIN prefers the lesser value 

betterof( _, _, _, Pos1, Move1, Val1, Pos1, Move1, Val1).           % Otherwise Pos1 better than Pos0

strategy( Pos, MPList) :-
  _Rule :: if Condition then AdviceList,
  nl, write( 'Checking ' ), write( Condition ), nl,
  holds( Condition, Pos ),
  member( AdviceName, AdviceList ),
  nl, write( 'Trying ' ), write( AdviceName ), nl,
  satisfiable( AdviceName, Pos, MPList), MPList \== nil,
  nl, write( 'Found: '), write( MPList), nl, !.

satisfiable( AdviceName, Pos, MPList) :-
  advice( AdviceName, Advice),
  sat_hg( Advice, Pos, MPList).

sat_hg( Advice, Pos, MPList) :-
  holdinggoal( Advice, HG),
  write( 'Trying:  '  ), write( Pos ), nl,
  holds( HG, Pos), 	% holding goal satisfied
  write( 'Holding goal satisfied: ' ), write( HG ), nl,
  sat_bg( Advice, Pos, MPList ).

% satisfy better goal
sat_bg( Advice, Pos, nil ) :-
	max_to_move( Pos ), !,	
	bettergoal( Advice, BG ), 	% retreive better goal
	%write( ' Better goal:  '  ), write( BG ), nl,
	holds( BG, Pos ),	% better goal satisfied
	write( 'Better goal satisfied: ' ), write( BG ), nl, !;
	max_to_move( Pos ), !,	
	bettergoal( Advice, BG ), 	% retreive better goal
        write( 'Better goal failed: '), write( BG), nl. 

sat_bg( Advice, Pos, Move..Pos1 ) :-
	%side( Pos, us ), 	% our turn to move
	%write( 'We move: ' ),
	max_to_move( Pos ), !,	
	usmoveconstr( Advice, UMC ),	% check the movement constraint for this advice
	write( ' constraint: ' ), write( UMC ), nl,
	moveC( UMC, Pos, Move, Pos1 ),	% find a move that satisfies the move constraint
	write( 'Move:  ' ), write( Move ), nl,
	sat_hg( Advice, Pos1, nil ).

sat_bg( Advice, Pos, MPList ) :-
	min_to_move( Pos ), !, 	% their turn to move
	themmoveconstr( Advice, TMC ),	% check the movement constraint for this advice
	write( ' constraint: ' ), write( TMC ), nl,
      % find all moves that satisfies the move constraint
	bagof( Move..Pos1, moveC( TMC, Pos, Move, Pos1 ), MPList ),	
        nl, write( 'Opponent can choose from Moves: '), write( MPList), nl, 
	satall( Advice, MPList ).


% satisfy all positions
satall( _, [], [] ).

% walk through all possible moves
satall( Advice, [ Move..Pos | MPList ], [ Move..FTree | MFTs ] ) :-
	sat_hg( Advice, Pos, FTree ),
	satall( Advice, MPList, MFTs ).


% check if a goal holds for a position

% goal with and: check if both goals are satisfied
holds( Goal1 and Goal2, Pos ) :- 
	!,	
	holds( Goal1, Pos ),
	holds( Goal2, Pos ).

holds( not Goal, Pos ) :-
	!,
	not holds( Goal, Pos ).

holds( Pred, Pos ) :-
	Cond =.. [ Pred, Pos ],
	call( Cond ).

moveC( MC, [o|T], Move, Pos1 ) :-
	moveGeneral( MC, [o|T], Move, Pos1 ).

moveC( MC, [x|T], Move, Pos1 ) :-
	moveGeneral( MC, [x|T], Move, Pos1 ).

% selectors fot components of piece-of-advice
bettergoal( BG : _ , BG ).

holdinggoal( _BG : HG : _ , HG ).

usmoveconstr( _BG: _HG: UMC : _, UMC ).

themmoveconstr( _BG: _HG: _UMC : TMC, TMC ).



