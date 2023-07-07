
import os

from clingo import Control
from clingraph.orm import Factbase
from clingraph.graphviz import compute_graphs, render
from clingraph.clingo_utils import ClingraphContext
from clingo.script import enable_python

import logging
log = logging.getLogger("main")


ENCODINGS_PATH = os.path.join(".", os.path.join("src", "encodings"))

def visualize(trace:str,name_format="{graph_name}"):
    '''
    Visualize the automata using clingraph
    '''
    print(trace)
    args = []
    args.append('--warn=none')
    fb = Factbase()
    ctl = Control(args)
    ctx = ClingraphContext()
    log.debug(trace)
    ctl.add("base", [], trace)
    log.debug("File")
    log.debug(os.path.join(ENCODINGS_PATH,"viz_trace.lp"))
    ctl.load(os.path.join(ENCODINGS_PATH,"viz_trace.lp"))
    enable_python()

    ctl.ground([("base", [])],context=ctx)
    ctl.solve(on_model=fb.add_model)
    graphs = compute_graphs(fb)
    files = render(graphs,view = True,name_format=name_format,engine="neato")
    log.info("Render saved in %s",files)

