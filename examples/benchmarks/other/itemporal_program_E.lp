g1675(N0,N1,N2) :- eventually((1,1), g1682(N2,N0,N1)).
g1676(N0) :- g1681(N0).
g1677(N0,N1,N2) :- g1680(N4,N3,N2,N1,N0).
g1678(N0,N1) :- always((0,1), g1680(N4,N1,N0,N2,N3)).
g1672(N0,N1,N2,N3,N4) :- eventually((1,1), g1672(N0,N1,N2,N3,N4)).
g1679(N0,N1,N2,N3,N4) :- g1680(N2,N3,N0,N4,N1).
g1680(N0,N1,N2,N3,N4) :- eventually((0,1), g1672(N0,N1,N2,N3,N4)).
g1681(N0) :- g1674(N0).
g1681(N0) :- g1680(N4,N1,N3,N2,N0).

#external g1682(N2,N0,N1):g1682(N2,N0,N1).
#external eventually((1,1), g1682(N2,N0,N1)):g1682(N2,N0,N1).
#external always((0,1), g1680(N4,N1,N0,N2,N3)):g1680(N4,N1,N0,N2,N3).
#external eventually((0,1), g1672(N0,N1,N2,N3,N4)):g1672(N0,N1,N2,N3,N4).
#external g1672(N0,N1,N2,N3,N4):g1672(N0,N1,N2,N3,N4).
#external eventually((0,1), g1672(N0,N1,N2,N3,N4)):g1672(N0,N1,N2,N3,N4).

