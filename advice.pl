% -*- Mode: Prolog -*-

% Tic-Tac-Toe in Advice Language 0

% all rules

:- op( 200, xfy, :: ).
:- op( 185, fx, if ).
:- op( 190, xfx, then ).
:- op( 140, fx, not ).

default_rule :: if not terminate
	then [ move_random ].

% pieces of advice
% structure:
% advice( NAME, BETTERGOAL, HOLDINGGOAL: USMOVECONSTRAINT: 
%		THEMMOVECONSTRAINT


advice( move_random, 
	victory :
	not loss :
	legal :
        legal).
