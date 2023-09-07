#const pos_body_lit_color= "#B5D99C".
#const neg_body_lit_color= "#D9A69C".
#const tab_color= "#E0E0C8".
#const program_color = "#A4C9DE".
#const rule_color = "#C8D7E0".
#const external_color = "#EED2AA".


attr(graph_edges, default, dir, both).
attr(graph_edges, default, arrowtail, none).
attr(graph_edges, default, arrowhead, none).

attr(node,N,label,"<{{name}}{% if value is defined %} <br/><br/> <FONT POINT-SIZE='15pt'> <i><b>{{value}} </b></i></FONT> {% else %} {% endif %}>") :- node(N).
attr(node,N,(label,name),N) :- node(N).
attr(node,N,style,filled) :- node(N), not attr(node,N,shape,plaintext).
attr(edge,(N1,N2),fontsize,8):-edge((N1,N2)).


node(atom_tuple(I)) :- atom_tuple(I).
attr(node, atom_tuple(E), shape, tab):- node(atom_tuple(E)).
attr(node, atom_tuple(E), fillcolor, tab_color):- node(atom_tuple(E)).

node(literal_tuple(I)) :- literal_tuple(I).
attr(node, literal_tuple(E), shape, tab):- node(literal_tuple(E)).
attr(node, literal_tuple(E), fillcolor, tab_color):- node(literal_tuple(E)).

% Internal atoms 
node(atom_tuple(internal,E)) :- literal_tuple(I,E), not atom_tuple(_,E).


node(rule(H,B)):-rule(H,B).
attr(node,rule(H,B),shape,rectangle) :- node(rule(H,B)).
attr(node,rule(H,B),fillcolor,rule_color) :- node(rule(H,B)).


node(output(S,L)):- output(S,L).
attr(node, output(S,L), shape, plaintext):- node(output(S,L)).
attr(node, output(S,L), (label,value), S):- node(output(S,L)).

% node(atom_tuple(A,E)) :- literal_tuple(I,E), E>0, atom_tuple(A,E).
node(atom_tuple(I,E)) :- atom_tuple(I,E), E>0.
attr(node, atom_tuple(A,E), shape, box):- node(atom_tuple(A,E)).
attr(node, atom_tuple(A,E), (label,value), S):- atom_tuple(A,E), literal_tuple(L,E), output(S,L).

attr(node,atom_tuple(internal,E),(label,value),@concat("external:=",V)) :- node(atom_tuple(internal,E)), external(E,V).
attr(node,atom_tuple(internal,E),fillcolor,external_color) :- node(atom_tuple(internal,E)), external(E,V).


% Atoms as part of an atom tuple
edge((atom_tuple(I),atom_tuple(I,E))):-atom_tuple(I,E).

% Positive atom in a literal tuple
edge((literal_tuple(I),atom_tuple(A,E))):-literal_tuple(I,E), E>0, node(atom_tuple(A,E)).
attr(edge, (literal_tuple(I),atom_tuple(A,E)), color, pos_body_lit_color):-literal_tuple(I,E), E>0, node(atom_tuple(A,E)).
attr(edge, (literal_tuple(I),atom_tuple(A,E)), arrowhead, dot):-literal_tuple(I,E), E>0, node(atom_tuple(A,E)).

% Negative atom_tuple in a literal tuple
edge((literal_tuple(I),atom_tuple(A,-1*E))):-literal_tuple(I,E), E<0, node(atom_tuple(A,-1*E)).
attr(edge, (literal_tuple(I),atom_tuple(A,-1*E)), color, neg_body_lit_color):-literal_tuple(I,E), E<0, node(atom_tuple(A,-1*E)).
attr(edge, (literal_tuple(I),atom_tuple(A,-1*E)), arrowhead, odot):-literal_tuple(I,E), E<0, node(atom_tuple(A,-1*E)).

% Literals as body of a rule
edge((rule(H,normal(B)),literal_tuple(B))):-rule(H,normal(B)).
attr(edge,(rule(H,normal(B)),literal_tuple(B)),label,"body"):-rule(H,normal(B)).

% Atoms as choice head of a rule
edge((rule(choice(H),B),atom_tuple(H))):-rule(choice(H),B).
attr(edge,(rule(choice(H),B),atom_tuple(H)),label,"body"):-rule(choice(H),B).
% attr(edge,(rule(choice(H),B),atom_tuple(H)),arrowtail,oinv):-rule(choice(H),B).

% Atoms as disjuction head of a rule
edge((rule(disjunction(H),B),atom_tuple(H))):-rule(disjunction(H),B).
attr(edge,(rule(disjunction(H),B),atom_tuple(H)),label,"head"):-rule(disjunction(H),B).

% Outputs
edge((literal_tuple(L),output(S,L))):-output(S,L).
attr(edge,(literal_tuple(L),output(S,L)),style,dotted):-output(S,L).
