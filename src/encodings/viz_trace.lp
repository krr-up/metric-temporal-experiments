#include "viz_base.lp".
#defined view_subformulas/0.

graph(trace).
attr(graph,trace,overlap, prism).
% attr(graph,trace,overlap_scaling, -30).
attr(graph,trace,sep, "+20,10").
node(X):-t(X,T).
node(f(X)):-t(X,T).

attr(node,X,label, "< <br/> {{t}}' <br/> <FONT  POINT-SIZE='5' COLOR='gray'>{{x}}</FONT>>"):-t(X,T).
attr(node,X,(label,x), X):-t(X,T).
attr(node,X,(label,t), T):-t(X,T).
attr(node,X,shape, circle):-t(X,T).
attr(node,X,style, filled):-t(X,T).
attr(node,X,penwidth, "0.2"):-t(X,T).
attr(node,X,pos, @pos(X,1)):-t(X,T).
attr(node,X,fontsize, "8"):-t(X,T).
attr(node,X,width, "0.3"):-t(X,T).
attr(node,X,margin, "0"):-t(X,T).
attr(node,X,fillcolor, color_lightgray):-t(X,T).

attr(node,f(X),label, "<{% set f = f|default({}) %}{% for k, n in f.items() %}{{n}} {% endfor %}>"):-t(X,T).
attr(node,f(X),shape, square):-t(X,T).
attr(node,f(X),penwidth, "0.3"):-t(X,T).
attr(node,f(X),color, gray):-t(X,T).
attr(node,f(X),pos, @pos(X,0)):-t(X,T).
attr(node,f(X),fontsize, "8"):-t(X,T).
attr(node,f(X),(label,f,F),@get_lbl(F)):-true(F,X), prop_formula(F).
attr(node,f(X),(label,f,F),@get_lbl(F)):-true(F,X), view_subformulas, not prop_formula(F).


edge((f(X),X)):-true(F,X).
attr(edge,(f(X),X),style,dotted):-true(F,X).
attr(edge,(f(X),X),color,gray):-true(F,X).
attr(edge,(f(X),X),penwidth,"0.2"):-true(F,X).

edge((X,X+1)):-t(X,T),t(X+1,T').
attr(edge,(X,X+1),penwidth,"0.5"):-t(X,T),t(X+1,T').