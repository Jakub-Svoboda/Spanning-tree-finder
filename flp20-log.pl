/******
* Project: FLP FIT VUTBR - Spanning tree finder - Kostra grafu
* Name: Jakub Svoboda 
* Login: xsvobo0z
* Email: xsvobo0z@stud.fit.vutbr.cz
* Date: 15.4.2020
* 
* How to use: 
* 	Compile:	make
* 	Run: 		./flp20-log < tests/in/in01.txt 		
*	Clean: 		make clean
******/


%	------------------------ MAIN ------------------------
main :-
	prompt(_, ''),									%disable |:
	readLines(Input),								%read from stdin
	removeSpaces(Input, Edges),						%remove spaces between "A B" in input, return a list of edges
	%getVertices(Edges, Vertices),					%Get list of unique vertices
	%length(Vertices, VerLen),						%Get number of vertices
	strToTerm(Edges, EdgesList),					%Convert input lists to a single list
	findall(T, getTree(EdgesList,T), Res),			%Start the search alogirthm
	sortPairs(Res,Ress),							%Sort the two vertices of each edge alphabetically
	sortAll(Ress,X),	   							%Sort all spanning trees alphabetically
	remove_duplicates(X, Res2),						%Remove duplicite spanning trees
	sort(Res2,Res3),								%Sort results
	myPrint(Res3),									%Output
	halt
.

%Convert a list of lists (first agr) to a single list of terms (2nd arg)
strToTerm([],[]).
strToTerm([H|Tail],[Term|Result]) :-
	nth0(0, H, A),
	nth0(1, H, B),
	Term = A-B,
	strToTerm(Tail,Result)
.

%Sort each pair of vertices in a list of pairs. 
%1st argument: the input list
%2nd argument: the processed result
sortPairs([],[]).
sortPairs([Line|List], [SortedLine|Result]) :-
	sortLine(Line,SortedLine),
	sortPairs(List,Result)
.

%Sorts a single line (spanning tree) alphabetically
%1st argument: the spanning three
%2nd argument: the processed result
sortLine([],[]).
sortLine([A-B|Line], [SortedPair|Tail]) :-
	(compare(<,A,B) -> SortedPair = A-B ; SortedPair = B-A ),
	sortLine(Line,Tail)
.

%Sorts all lists in a list
%1st argument: the input
%2nd argument: the sorted list of lists
sortAll([],[]).
sortAll([H|Tail],[HSorted|List]) :-
	sort(H, HSorted),
	sortAll(Tail, List)
.

%Prints output according to the project specification
%1st argument: list of spanning trees to be printed
myPrint([]).
myPrint([Line|List]) :-
	printMyLine(Line),					%print a line
	myPrint(List)						%recursive call
.

%Prints a single line according to the project specifications
%1st argument: a single line (spanning tree) to be printed
printMyLine([]):- nl.
printMyLine([Edge|Line]) :-
	( length(Line, 0) -> 				%if last edge
		printEdge(Edge) ; 				%print wihtout space
		printEdge(Edge),write(" ") 		%print with space
	),
	printMyLine(Line)
.

%Prints a single edge according to the project specification
%1st argument: a single graph edge to be printed
printEdge(A) :-
	format('~w', A)			
.

%Removes duplicate elements of a list
%1st argument: a list from which duplicates shall be removed
%2nd argument: the processed result list
remove_duplicates([], []).								%For empty, just retrace
remove_duplicates([Head | Tail], Result) :- 			%When the head is already present, dont add it
	member(Head, Tail),
	remove_duplicates(Tail, Result).
remove_duplicates([Head | Tail], [Head | Result]) :-	%Else add it to the result
	remove_duplicates(Tail, Result)
.

%True when all elements in first list are present in the second list
%1st argument: a list from which all the elements are checked
%2nd argument: a list where all the elements are searched for
allFromFirstInSecond(List1, List2) :-
	forall(member(Element,List1), member(Element,List2))
.

%Extracts all unique vertices from edges
%1st argument: a list of edges
%2nd argument: result list of all unique vertices
getVertices(Edges,Result3) :-
	flatten(Edges, Result),
	sort(Result,Result2),
	list_to_set(Result2,Result3)
.

%Removes a space between two vertices forming an edge
%1st argument: a list of all edges with spaces
%2nd argument: result list of all edges with spaces removed
removeSpaces([], []).
removeSpaces([X|Rest], [Remainder|Result]) :- 
	nth0(1, X, _, Remainder),
	removeSpaces(Rest,Result).

%Reads a input from stdin into first argument
%1st argument: a list of chars containing the input
readLines(Input) :-
	readLine(Line,Char),					%read a single line
	( Char == end_of_file, Input = [] ;		%if char == EOF, return []
	  readLines(Lines2), 					%else go again
	  Input = [Line|Lines2]					
	)
.

%Reads a single line until the end of a line or end of a file
%1st argument: The resulting line from input
%2nd argument: Last char read
readLine(Line, Char) :-
	get_char(Char),
	(isEndingChar(Char), Line = [], !;		%if the loaded char is end of line of file, end backtracking
		readLine(Line2, _), 
		[Char|Line2] = Line
	)
.

%True when a character Char is end of line or end of file
%1st argument: the character to be evaluated
isEndingChar(Char) :-
	Char == end_of_file;					%true if char is EOF
	(char_code(Char, Code), Code==10)		%or true if char is EOL
.

%Given a list of edges of a graph, returns a spanning tree
%1st argument: A list containing edges of a unoriented graph
%2nd argument: A discovered spanning tree
%Source: https://nlp.fi.muni.cz/uui/priklady/showfile.cgi?file=2.10_23.pl
getTree(Edges, Tree) :- 
	member(Edge, Edges), 
	step([Edge], Tree, Edges)
.

%Spreads into a spanning tree
%1st argument: 
%2nd argument: A spanning tree being formed
%3rd argument: A list of all edges of a graph
step(Tree1, Tree, Edges) :- 
	addEdge(Tree1, Tree2, Edges),
	step(Tree2, Tree, Edges)
.
step(Tree, Tree, Edges) :- 
	\+ addEdge(Tree, _, Edges)
.

%Adds and edge to a graph
%1st argument: The tree without the new edge
%2nd argument: The tree with the new edge
%3rd argument: A list of all edges of a graph
addEdge(Tree, [A-B|Tree], Edges) :- 
	areConnected(A, B, Edges), 
	isNode(A, Tree), 
	\+ isNode(B, Tree)
.

%A and B are adjacent, if there is a A-B edge in graph or B-A edge in graph
%1st argument: A first vertex
%2nd argument: A second vertex
%3rd argument: A list of all edges of a graph
areConnected(A, B, Edges) :- 
	member(A-B, Edges); 
	member(B-A, Edges)
.

%True when a vertex is connected
%1st argument: A vertex to be investigated
%2nd argument: A list of all edges of a graph
isNode(Vertex, Edges) :- areConnected(Vertex, _, Edges), !.
