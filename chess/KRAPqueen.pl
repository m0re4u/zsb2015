% -*- Mode: Prolog -*-
% $Id: KRAPqueen.pl,v 1.1 2004/05/31 19:47:25 mtjspaan Exp $

% King and Queen vs king in Advice Language 0

% all rules

else_rule :: if their_king_edge and kings_close
	then [ mate_in_2, squeeze, approach, keeproom, divide_in_2, divide_in_3 ].

else_rule :: if true
	then [ squeeze, approach, keeproom, divide_in_2, divide_in_3].
	
% pieces of advice
% structure:
% advice( NAME, BETTERGOAL: HOLDINGGOAL: USMOVECONSTRAINT: 
%		THEMMOVECONSTRAINT ).


advice( mate_in_2, 
	mate :
	not queenlost and their_king_edge :
	( depth = 0 ) and legal then ( depth = 2 ) and checkmove:
	( depth = 1 ) and legal ).
	
advice( mate_in_3, 
	mate :
	not queenlost and their_king_edge :
	( depth = 0 ) and legal then ( depth = 2 ) and legal then ( depth = 4 ) and checkmove:
	( depth = 1 ) and legal then ( depth = 2 ) and legal ).
	
advice( squeeze, 
	newroomsmaller and not queenexposed and queendivides and not stalemate :
	not queenlost :
	( depth = 1 ) and queenmove:
	nomove ).
	
advice( approach, 
okapproachedsquare and not queenexposed and not stalemate and (queendivides or lpatt) and (roomgt2 or not our_king_edge):
	not queenlost:
	( depth = 0 ) and kingdiagfirst:
	nomove ).

advice( keeproom, 
themtomove and not queenexposed and queendivides and okorndle and (roomgt2 or not our_king_edge):
	not queenlost:
	( depth = 0 ) and kingdiagfirst:
	nomove ).

advice( divide_in_2, 
themtomove and queendivides and not queenexposed:
	not queenlost:
	( depth < 3 ) and legal:
	( depth < 2 ) and legal ).

advice( divide_in_3, 
themtomove and queendivides and not queenexposed:
	not queenlost:
	( depth < 5 ) and legal:
	( depth < 4 ) and legal ).

