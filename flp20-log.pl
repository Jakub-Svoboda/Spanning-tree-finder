% FLP FIT VUTBR - Spanning tree finder
% Jakub Svoboda (xsvobo0z)
% 15.4.2020

%	------------------------ MAIN ------------------------
main :-
	prompt(_, ''),				%disable |:
	readLines(Input),			%read from stdin
	removeSpaces(Input, Result),
	write(Result),
	nl,
	halt.


removeSpaces([], []).
removeSpaces([X|Rest], [Remainder|Result]) :- 
	nth0(1, X, _, Remainder),
	removeSpaces(Rest,Result).


readLines(Ls) :-
	readLine(L,C),
	( C == end_of_file, Ls = [] ;
	  readLines(LLs), Ls = [L|LLs]
	).

readLine(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		readLine(LL,_),% atom_codes(C,[Cd]),
		[C|LL] = L).

%True when a character C is end of line or end of file
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).
