"""
Visualizer of timmed traces
"""
import logging
import os

from clingo import Control
from clingo.script import enable_python
from clingraph.clingo_utils import ClingraphContext  # type: ignore
from clingraph.graphviz import compute_graphs, render  # type: ignore
from clingraph.orm import Factbase  # type: ignore

log = logging.getLogger("main")


ENCODINGS_PATH = os.path.join(".", os.path.join("src", "encodings"))


def visualize(trace: str, name_format: str = "{graph_name}", view: bool = True) -> None:
    """
    Visualize the automata using clingraph
    """
    args = []
    args.append("--warn=none")
    fb = Factbase(default_graph="trace")
    ctl = Control(args)
    ctx = ClingraphContext()
    log.debug(trace)
    ctl.add("base", [], trace)
    log.debug("File")
    log.debug(os.path.join(ENCODINGS_PATH, "viz_trace.lp"))
    ctl.load(os.path.join(ENCODINGS_PATH, "viz_trace.lp"))
    enable_python()

    ctl.ground([("base", [])], context=ctx)
    ctl.solve(on_model=fb.add_model)
    graphs = compute_graphs(fb)
    files = render(graphs, view=view, name_format=name_format, engine="neato")
    log.info("Render saved in %s", files)
