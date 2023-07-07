#include "viz_base.lp".


% node((F,X)):-true(F,X).

node(X):-t(X,T).
node(f(X)):-t(X,T).

attr(node,X,label, "𝜏({{x}})={{t}}"):-t(X,T).
attr(node,X,(label,x), X):-t(X,T).
attr(node,X,(label,t), T):-t(X,T).
attr(node,X,shape, circle):-t(X,T).
attr(node,X,style, filled):-t(X,T).
attr(node,X,pos, @pos(X,0)):-t(X,T).
attr(node,X,fontsize, "8"):-t(X,T).
attr(node,X,width, "0.1"):-t(X,T).

attr(node,f(X),label, "<{% for k, n in f.items() %}{{n}} {% endfor %}>"):-t(X,T).
attr(node,f(X),shape, square):-t(X,T).
attr(node,f(X),pos, @pos(X,2)):-t(X,T).
attr(node,f(X),fontsize, "8"):-t(X,T).
attr(node,f(X),(label,f,F),@get_lbl(F)):-true(F,X).


% node(t(X)):-t(X,T).
% attr(node,t(X),fontsize, "8"):-t(X,T).
% attr(node,t(X),pos, @pos(X,0)):-t(X,T).
% attr(node,t(X),shape, none):-t(X,T).
% attr(node,t(X),label, T):-t(X,T).


edge((f(X),X)):-true(F,X).
edge((X,X+1)):-t(X,T),t(X+1,T').
attr(edge,(f(X),X),style,dotted):-true(F,X).