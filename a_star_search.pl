% arc
arc([N,Cost],M,Seed,_) :- A is N*Seed, B is Cost+1, M = [A,B].
arc([N,Cost],M,Seed,_) :- A is N*Seed + 1, B is Cost+2, M = [A,B].

% checks for a goal node
goal(N,Target) :- 0 is N mod Target.

% assigns the heuristic value to a node
h(N,Hvalue,Target) :- goal(N,Target),!, Hvalue is 0; Hvalue is 1/N.

% less than
less-than([Node1,Cost1],[Node2,Cost2],Target) :-
h(Node1,Hvalue1,Target), h(Node2,Hvalue2,Target),
F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
F1 =< F2.

% add to frontier
add-to-frontier([],X,X,_).
add-to-frontier([Head|X],Restof,New,Target) :- insert(Head,Restof,Result,Target),
											   add-to-frontier(X,Result,New,Target).

% insert into list
insert(X,[Y|T],[Y|NT],Target):- less-than(Y,X,Target),insert(X,T,NT,Target).
insert(X,[Y|T],[X,Y|T],Target):- less-than(X,Y,Target).
insert(X,[],[X],_).

% skeletal search algorithm
search([[Node,Cost] | FRest],_,Target,[Node, Cost]) :- goal(Node, Target).
search([[Node,Cost] | FRest],Seed,Target,Found) :-
	setof(X,arc([Node,Cost],X,Seed,Target), FNode),
	add-to-frontier(FNode,FRest,Result,Target),
	search(Result,Seed,Target,Found).

% a star search
a-star(Start,Seed,Target,Found) :- search([[Start,0]|[]],Seed,Target,Found).
